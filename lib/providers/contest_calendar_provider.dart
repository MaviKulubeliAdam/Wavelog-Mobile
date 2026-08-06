import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_widget/home_widget.dart';
import 'package:intl/intl.dart';
import '../data/datasources/remote/contest_calendar_datasource.dart';
import '../data/models/contest_event_model.dart';

// Plain Dio with no baseUrl — only for external feeds
final _plainDioProvider = Provider<Dio>((ref) => Dio());

final contestCalendarDatasourceProvider =
    Provider<ContestCalendarDatasource>((ref) {
  return ContestCalendarDatasource(ref.watch(_plainDioProvider));
});

final contestCalendarProvider =
    FutureProvider.autoDispose<List<ContestEvent>>((ref) async {
  final events = await ref.watch(contestCalendarDatasourceProvider).fetchEvents();
  // Push top 3 upcoming events to the Android home screen widget
  _updateHomeWidget(events).ignore();
  return events;
});

Future<void> _updateHomeWidget(List<ContestEvent> events) async {
  try {
    final upcoming = events
        .where((e) => !e.isPast)
        .take(3)
        .toList();

    final dateFmt = DateFormat('MMM d');
    for (var i = 0; i < 3; i++) {
      final title = i < upcoming.length ? upcoming[i].title : '';
      final date = i < upcoming.length && upcoming[i].startUtc != null
          ? dateFmt.format(upcoming[i].startUtc!)
          : '';
      await HomeWidget.saveWidgetData('contest_title_$i', title);
      await HomeWidget.saveWidgetData('contest_date_$i', date);
    }

    await HomeWidget.updateWidget(
      androidName: 'ContestWidget',
      qualifiedAndroidName: 'com.wavelog_mobile.ContestWidget',
    );
  } catch (e) {
    if (kDebugMode) debugPrint('HomeWidget update failed: $e');
  }
}
