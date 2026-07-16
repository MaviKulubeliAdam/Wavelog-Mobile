import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:xml/xml.dart';
import '../../models/solar_data_model.dart';

class SolarDatasource {
  static const _url = 'https://www.hamqsl.com/solarxml.php';

  final Dio _dio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 20),
    receiveTimeout: const Duration(seconds: 20),
    responseType: ResponseType.plain,
    headers: {
      'User-Agent': 'Mozilla/5.0 (Linux; Android 10) WavelogMobile/1.0',
      'Accept': 'text/xml, application/xml, */*',
    },
  ));

  Future<SolarDataModel> fetchSolarData() async {
    try {
      final response = await _dio.get<String>(_url);
      final body = response.data;
      if (body == null || body.isEmpty) {
        throw Exception('Empty response from solar data feed');
      }
      return _parse(body);
    } on DioException catch (e) {
      debugPrint('Solar fetch DioException: ${e.type} — ${e.message}');
      debugPrint('Solar response: ${e.response?.statusCode} ${e.response?.data}');
      rethrow;
    } catch (e) {
      debugPrint('Solar fetch error: $e');
      rethrow;
    }
  }

  SolarDataModel _parse(String xml) {
    final document = XmlDocument.parse(xml);
    // XML root is <solar><solardata>...</solardata></solar>
    final solardata = document.findAllElements('solardata').firstOrNull;
    if (solardata == null) throw Exception('Malformed solar XML: <solardata> not found');

    String text(String tag) =>
        solardata.findElements(tag).firstOrNull?.innerText.trim() ?? '';

    int intVal(String tag) => int.tryParse(text(tag).replaceAll(' ', '')) ?? 0;

    double doubleVal(String tag) =>
        double.tryParse(text(tag).replaceAll(' ', '')) ?? 0.0;

    final conditions = <BandCondition>[];
    final calcCond = solardata.findElements('calculatedconditions').firstOrNull;
    if (calcCond != null) {
      for (final band in calcCond.findElements('band')) {
        final name = band.getAttribute('name') ?? '';
        final time = band.getAttribute('time') ?? '';
        final cond = band.innerText.trim();
        if (name.isNotEmpty && time.isNotEmpty) {
          conditions.add(BandCondition(band: name, time: time, condition: cond));
        }
      }
    }

    return SolarDataModel(
      updated: text('updated'),
      solarFlux: intVal('solarflux'),
      solarWind: doubleVal('solarwind').round(),
      sunspots: intVal('sunspots'),
      kIndex: intVal('kindex'),
      aIndex: intVal('aindex'),
      signalNoise: text('signalnoise'),
      conditions: conditions,
    );
  }
}
