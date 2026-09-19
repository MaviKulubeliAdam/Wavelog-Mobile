import 'package:flutter_test/flutter_test.dart';
import 'package:wavelog_mobile/core/utils/qso_scope.dart';
import 'package:wavelog_mobile/data/models/qso_model.dart';
import 'package:wavelog_mobile/data/models/station_logbook_model.dart';

QsoModel _qso(int station, DateTime when) => QsoModel(
      callsign: 'K1ABC',
      dateTimeOn: when,
      band: '20m',
      mode: 'SSB',
      rstSent: '59',
      rstRcvd: '59',
      stationProfileId: station,
    );

void main() {
  const logbooks = [
    StationLogbookModel(id: 1, name: 'Both', stationIds: [10, 20]),
    StationLogbookModel(id: 2, name: 'Empty'),
  ];

  group('activeScopeStationIds', () {
    test('logbook wins over active station and brings all its stations', () {
      final ids = activeScopeStationIds(
          logbookId: 1, stationId: 10, logbooks: logbooks);
      expect(ids, {10, 20});
    });

    test('falls back to the active station without a logbook', () {
      expect(
          activeScopeStationIds(
              logbookId: null, stationId: 20, logbooks: logbooks),
          {20});
    });

    test('falls back to the station when the logbook is unknown or empty', () {
      expect(
          activeScopeStationIds(
              logbookId: 2, stationId: 10, logbooks: logbooks),
          {10});
      expect(
          activeScopeStationIds(
              logbookId: 1, stationId: 10, logbooks: null),
          {10});
    });

    test('no scope at all means everything', () {
      expect(
          activeScopeStationIds(
              logbookId: null, stationId: null, logbooks: logbooks),
          isNull);
    });
  });

  test('filterByStations keeps only QSOs of the scoped stations', () {
    final now = DateTime.now();
    final qsos = [_qso(10, now), _qso(20, now), _qso(30, now)];
    expect(filterByStations(qsos, {10, 30}).map((q) => q.stationProfileId),
        [10, 30]);
    expect(filterByStations(qsos, null), qsos);
  });

  test('countQsos splits today / month / year / total', () {
    final now = DateTime.now();
    final lastYear = DateTime(now.year - 1, 6, 15);
    final qsos = [
      _qso(10, now),
      _qso(10, now.subtract(const Duration(minutes: 5))),
      _qso(10, lastYear),
    ];
    final c = countQsos(qsos);
    expect(c.totalQsos, 3);
    expect(c.yearQsos, 2);
    expect(c.monthQsos, 2);
    expect(c.todayQsos >= 1, isTrue);
  });
}
