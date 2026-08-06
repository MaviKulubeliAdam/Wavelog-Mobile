import 'package:dio/dio.dart';
import 'package:xml/xml.dart';
import '../../models/contest_event_model.dart';

class ContestCalendarDatasource {
  static const _feedUrl = 'https://www.contestcalendar.com/calendar.rss';

  final Dio _dio;
  ContestCalendarDatasource(this._dio);

  Future<List<ContestEvent>> fetchEvents() async {
    final resp = await _dio.get<String>(
      _feedUrl,
      options: Options(
        responseType: ResponseType.plain,
        receiveTimeout: const Duration(seconds: 15),
      ),
    );

    final doc = XmlDocument.parse(resp.data ?? '');
    final items = doc.findAllElements('item');
    final events = <ContestEvent>[];

    for (final item in items) {
      final title = item.findElements('title').firstOrNull?.innerText.trim() ?? '';
      final desc = item.findElements('description').firstOrNull?.innerText.trim() ?? '';
      final link = item.findElements('link').firstOrNull?.innerText.trim() ?? '';

      // Description format: "0000Z-0500Z, Aug 6" or "0000Z-2359Z, Aug 6-7"
      final (start, end) = _parseDates(desc);

      events.add(ContestEvent(
        title: title,
        description: desc,
        link: link,
        startUtc: start,
        endUtc: end,
      ));
    }

    return events;
  }

  // Parses "0000Z-2359Z, Aug 6" or "0000Z-2359Z, Aug 6-7" etc.
  (DateTime?, DateTime?) _parseDates(String desc) {
    try {
      // Extract time range: "0000Z-2359Z"
      final timeRe = RegExp(r'(\d{4})Z-(\d{4})Z');
      final timeMatch = timeRe.firstMatch(desc);
      if (timeMatch == null) return (null, null);

      final startHour = int.parse(timeMatch.group(1)!.substring(0, 2));
      final startMin = int.parse(timeMatch.group(1)!.substring(2, 4));
      final endHour = int.parse(timeMatch.group(2)!.substring(0, 2));
      final endMin = int.parse(timeMatch.group(2)!.substring(2, 4));

      // Extract date part after the comma: "Aug 6" or "Aug 6-7"
      final dateRe = RegExp(r',\s*([A-Za-z]+)\s+(\d+)(?:-(\d+))?');
      final dateMatch = dateRe.firstMatch(desc);
      if (dateMatch == null) return (null, null);

      final monthStr = dateMatch.group(1)!;
      final startDay = int.parse(dateMatch.group(2)!);
      final endDay = dateMatch.group(3) != null
          ? int.parse(dateMatch.group(3)!)
          : startDay;

      final now = DateTime.now().toUtc();
      // Try current year first, fall back to next year if date is in past
      int year = now.year;
      final month = _monthIndex(monthStr);
      if (month == null) return (null, null);

      DateTime startDt = DateTime.utc(year, month, startDay, startHour, startMin);
      DateTime endDt = DateTime.utc(year, month, endDay, endHour, endMin);

      // If contest already ended and was more than 2 months ago, assume next year
      if (endDt.isBefore(now.subtract(const Duration(days: 60)))) {
        startDt = DateTime.utc(year + 1, month, startDay, startHour, startMin);
        endDt = DateTime.utc(year + 1, month, endDay, endHour, endMin);
      }

      // If end time < start time (e.g. starts 0000Z ends 0500Z next day)
      if (endDt.isBefore(startDt)) {
        endDt = endDt.add(const Duration(days: 1));
      }

      return (startDt, endDt);
    } catch (_) {
      return (null, null);
    }
  }

  int? _monthIndex(String month) {
    const months = {
      'jan': 1, 'feb': 2, 'mar': 3, 'apr': 4, 'may': 5, 'jun': 6,
      'jul': 7, 'aug': 8, 'sep': 9, 'oct': 10, 'nov': 11, 'dec': 12,
    };
    return months[month.toLowerCase().substring(0, 3)];
  }
}
