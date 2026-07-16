import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/datasources/remote/pota_datasource.dart';
import '../data/datasources/remote/sota_datasource.dart';
import '../services/auto_spot_service.dart';

final autoSpotServiceProvider = Provider<AutoSpotService>((_) {
  // Datasource'u bir kez oluştur — her spot gönderiminde yeni Dio kurma
  final pota = PotaDatasource();
  return AutoSpotService(
    prefix: 'as_pota',
    sendSpot: ({
      required String callsign,
      required String freqKhz,
      required String mode,
      required String reference,
    }) =>
        pota.addSpot(
          activator: callsign,
          spotter: callsign,
          frequency: freqKhz,
          mode: mode,
          reference: reference,
          comments: 'CQ CQ $mode 73',
        ),
  );
});

final sotaAutoSpotServiceProvider = Provider<AutoSpotService>((_) {
  final sota = SotaDatasource();
  return AutoSpotService(
    prefix: 'as_sota',
    sendSpot: ({
      required String callsign,
      required String freqKhz,
      required String mode,
      required String reference,
    }) =>
        sota.postSpot(
          activatorCallsign: callsign,
          summitCode: reference,
          frequency: freqKhz,
          mode: mode,
          spotter: callsign,
          comments: 'CQ CQ $mode 73',
        ),
  );
});
