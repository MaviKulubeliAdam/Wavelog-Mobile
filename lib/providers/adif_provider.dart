import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../core/utils/adif_generator.dart';
import '../core/utils/adif_parser.dart';
import '../data/models/qso_model.dart';
import '../data/repositories/qso_repository.dart';
import 'remote_datasource_provider.dart';
import 'station_provider.dart';

enum AdifOperation { idle, importing, exporting, success, error }

class AdifState {
  final AdifOperation operation;
  final int processedCount;
  final int totalCount;
  final String? errorMessage;
  final String? exportFilePath;

  const AdifState({
    this.operation = AdifOperation.idle,
    this.processedCount = 0,
    this.totalCount = 0,
    this.errorMessage,
    this.exportFilePath,
  });
}

final adifProvider =
    StateNotifierProvider<AdifNotifier, AdifState>((ref) {
  return AdifNotifier(ref.watch(qsoRepositoryProvider), ref);
});

class AdifNotifier extends StateNotifier<AdifState> {
  final QsoRepository _repo;
  final Ref _ref;

  AdifNotifier(this._repo, this._ref) : super(const AdifState());

  Future<void> importFile(String adifContent, int stationProfileId) async {
    final count = AdifParser.countRecords(adifContent);

    state = AdifState(
      operation: AdifOperation.importing,
      totalCount: count,
      processedCount: 0,
    );

    try {
      final result = await _repo.streamingImportAdif(
        adifContent,
        stationProfileId,
        (processed, total) {
          state = AdifState(
            operation: AdifOperation.importing,
            totalCount: total,
            processedCount: processed,
          );
        },
      );
      state = AdifState(
        operation: AdifOperation.success,
        totalCount: result.total,
        processedCount: result.imported,
      );
    } catch (e) {
      state = AdifState(
        operation: AdifOperation.error,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> exportAdif({
    int? stationId,
    DateTime? dateFrom,
    DateTime? dateTo,
    required String dialogTitle,
    required String noStationsMessage,
  }) async {
    state = const AdifState(operation: AdifOperation.exporting);

    try {
      final List<QsoModel> qsos;
      if (stationId != null) {
        qsos = await _repo.exportQsos(
            stationId: stationId, dateFrom: dateFrom, dateTo: dateTo);
      } else {
        final stations = await _ref.read(stationProvider.future);
        if (stations.isEmpty) {
          state = AdifState(
              operation: AdifOperation.error,
              errorMessage: noStationsMessage);
          return;
        }
        final results = await Future.wait(stations.map(
            (s) => _repo.exportQsos(stationId: s.id, dateFrom: dateFrom, dateTo: dateTo)));
        qsos = results.expand((l) => l).toList()
          ..sort((a, b) => a.dateTimeOn.compareTo(b.dateTimeOn));
      }

      final allStations = await _ref.read(stationProvider.future);
      final activeStation = stationId != null
          ? allStations.where((s) => s.id == stationId).firstOrNull
          : null;

      final adif = AdifGenerator.generate(qsos, station: activeStation);

      final now = DateTime.now();
      final stamp =
          '${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}'
          '_${now.hour.toString().padLeft(2, '0')}${now.minute.toString().padLeft(2, '0')}';
      final fileName = 'wavelog_$stamp.adif';
      final bytes = Uint8List.fromList(utf8.encode(adif));

      // SAF ile kullanıcı kayıt konumunu seçer (Android 13+ izin gerektirmez)
      final savedPath = await FilePicker.platform.saveFile(
        dialogTitle: dialogTitle,
        fileName: fileName,
        bytes: bytes,
      );

      // Temp dosyası oluştur ve share et (hem seçilen konuma hem paylaşım)
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/$fileName');
      await file.writeAsBytes(bytes);

      state = AdifState(
        operation: AdifOperation.success,
        exportFilePath: savedPath ?? file.path,
        processedCount: qsos.length,
      );

      await Share.shareXFiles([XFile(file.path)], text: 'Wavelog ADIF Export');
    } catch (e) {
      state = AdifState(
        operation: AdifOperation.error,
        errorMessage: e.toString(),
      );
    }
  }

  void reset() {
    state = const AdifState();
  }
}
