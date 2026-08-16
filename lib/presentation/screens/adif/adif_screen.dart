import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import '../../../core/utils/l10n_extension.dart';
import '../../../providers/adif_provider.dart';
import '../../../providers/station_provider.dart';

class AdifScreen extends ConsumerStatefulWidget {
  final ({String name, String content})? initialFile;
  const AdifScreen({super.key, this.initialFile});

  @override
  ConsumerState<AdifScreen> createState() => _AdifScreenState();
}

class _AdifScreenState extends ConsumerState<AdifScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  int? _importStationId;
  String? _selectedFileName;
  String? _selectedFileContent;

  int? _exportStationId;
  DateTime? _exportDateFrom;
  DateTime? _exportDateTo;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    if (widget.initialFile != null) {
      _selectedFileName    = widget.initialFile!.name;
      _selectedFileContent = widget.initialFile!.content;
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        withData: true,
      );
      if (result == null || result.files.isEmpty) return;
      final file = result.files.first;

      // Android SAF uzantı filtresini desteklemiyor; Flutter tarafında kontrol et
      final ext = file.name.split('.').last.toLowerCase();
      if (ext != 'adi' && ext != 'adif') {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(context.l10n.invalidFileExtension)),
          );
        }
        return;
      }

      // Android'de bytes null gelebilir; path'ten fallback oku
      String? content;
      if (file.bytes != null) {
        content = utf8.decode(file.bytes!, allowMalformed: true);
      } else if (file.path != null) {
        final bytes = await File(file.path!).readAsBytes();
        content = utf8.decode(bytes, allowMalformed: true);
      }

      if (!mounted) return;
      if (content == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.fileReadError)),
        );
        return;
      }

      setState(() {
        _selectedFileName = file.name;
        _selectedFileContent = content;
      });
    } on PlatformException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${context.l10n.error}: ${e.message ?? e.code}')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${context.l10n.error}: $e')),
      );
    }
  }

  Future<void> _pickDate({required bool isFrom}) async {
    final initial = isFrom
        ? (_exportDateFrom ?? DateTime.now())
        : (_exportDateTo ?? DateTime.now());
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(1990),
      lastDate: DateTime.now(),
    );
    if (picked == null) return;
    setState(() {
      if (isFrom) {
        _exportDateFrom = picked;
        if (_exportDateTo != null && _exportDateTo!.isBefore(picked)) {
          _exportDateTo = picked;
        }
      } else {
        _exportDateTo = picked;
        if (_exportDateFrom != null && _exportDateFrom!.isAfter(picked)) {
          _exportDateFrom = picked;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final adifState = ref.watch(adifProvider);
    final stations = ref.watch(stationProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.adifTitle),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(icon: const Icon(Icons.upload_file), text: l10n.importTab),
            Tab(icon: const Icon(Icons.download), text: l10n.exportTab),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildImportTab(adifState, stations),
          _buildExportTab(adifState, stations),
        ],
      ),
    );
  }

  Widget _buildImportTab(AdifState adifState, AsyncValue stationsAsync) {
    final l10n = context.l10n;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.selectAdifFile,
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: adifState.operation == AdifOperation.importing
                      ? null
                      : _pickFile,
                  icon: const Icon(Icons.folder_open),
                  label: Text(l10n.selectFileBtn),
                ),
                if (_selectedFileName != null) ...[
                  const SizedBox(height: 8),
                  Row(children: [
                    const Icon(Icons.insert_drive_file_outlined, size: 16),
                    const SizedBox(width: 4),
                    Expanded(child: Text(_selectedFileName!)),
                  ]),
                ],
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),

        stationsAsync.when(
          data: (list) {
            if ((list as List).isEmpty) return const SizedBox.shrink();
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: DropdownButtonFormField<int>(
                  initialValue: _importStationId,
                  decoration:
                      InputDecoration(labelText: l10n.stationRequired),
                  items: list
                      .map((s) => DropdownMenuItem<int>(
                            value: s.id,
                            child: Text('${s.callsign} — ${s.profileName}'),
                          ))
                      .toList(),
                  onChanged: (v) => setState(() => _importStationId = v),
                ),
              ),
            );
          },
          loading: () => const SizedBox.shrink(),
          error: (_, __) => const SizedBox.shrink(),
        ),

        const SizedBox(height: 12),

        if (adifState.operation == AdifOperation.importing)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(l10n.importing(
                          adifState.processedCount, adifState.totalCount)),
                      if (adifState.totalCount > 0)
                        Text(
                          '%${(adifState.processedCount / adifState.totalCount * 100).toInt()}',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: adifState.totalCount > 0
                          ? adifState.processedCount / adifState.totalCount
                          : null,
                      minHeight: 8,
                    ),
                  ),
                ],
              ),
            ),
          ),

        _StatusCard(
            adifState: adifState, tabIndex: 0, controller: _tabController),

        const SizedBox(height: 16),

        FilledButton.icon(
          onPressed: (_selectedFileContent == null ||
                  _importStationId == null ||
                  adifState.operation == AdifOperation.importing)
              ? null
              : () => ref.read(adifProvider.notifier).importFile(
                    _selectedFileContent!,
                    _importStationId!,
                  ),
          icon: const Icon(Icons.upload),
          label: Text(l10n.importBtn),
        ),
      ],
    );
  }

  Widget _buildExportTab(AdifState adifState, AsyncValue stationsAsync) {
    final l10n = context.l10n;
    final cs = Theme.of(context).colorScheme;
    final fmt = DateFormat('dd.MM.yyyy');

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.exportFilters,
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 16),

                stationsAsync.when(
                  data: (list) => DropdownButtonFormField<int?>(
                    initialValue: _exportStationId,
                    decoration: InputDecoration(
                      labelText: l10n.stationFilter,
                      prefixIcon: const Icon(Icons.cell_tower_outlined),
                    ),
                    items: [
                      DropdownMenuItem<int?>(
                        value: null,
                        child: Text(l10n.allStations),
                      ),
                      ...(list as List).map((s) => DropdownMenuItem<int?>(
                            value: s.id,
                            child: Text('${s.callsign} — ${s.profileName}'),
                          )),
                    ],
                    onChanged: (v) => setState(() => _exportStationId = v),
                  ),
                  loading: () => const LinearProgressIndicator(),
                  error: (_, __) => const SizedBox.shrink(),
                ),

                const SizedBox(height: 16),

                Row(children: [
                  Expanded(
                    child: _DatePickerTile(
                      label: l10n.startDate,
                      date: _exportDateFrom,
                      formatted: _exportDateFrom != null
                          ? fmt.format(_exportDateFrom!)
                          : null,
                      notSelectedLabel: l10n.notSelected,
                      onTap: () => _pickDate(isFrom: true),
                      onClear: _exportDateFrom != null
                          ? () => setState(() => _exportDateFrom = null)
                          : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _DatePickerTile(
                      label: l10n.endDate,
                      date: _exportDateTo,
                      formatted: _exportDateTo != null
                          ? fmt.format(_exportDateTo!)
                          : null,
                      notSelectedLabel: l10n.notSelected,
                      onTap: () => _pickDate(isFrom: false),
                      onClear: _exportDateTo != null
                          ? () => setState(() => _exportDateTo = null)
                          : null,
                    ),
                  ),
                ]),

                if (_exportDateFrom != null || _exportDateTo != null) ...[
                  const SizedBox(height: 8),
                  TextButton.icon(
                    onPressed: () => setState(() {
                      _exportDateFrom = null;
                      _exportDateTo = null;
                    }),
                    icon: const Icon(Icons.clear, size: 16),
                    label: Text(l10n.clearDates),
                    style: TextButton.styleFrom(
                        foregroundColor: cs.error,
                        padding: EdgeInsets.zero),
                  ),
                ],
              ],
            ),
          ),
        ),

        const SizedBox(height: 12),

        if (_exportDateFrom != null || _exportDateTo != null || _exportStationId != null)
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: [
              if (_exportDateFrom != null)
                Chip(
                  avatar: const Icon(Icons.calendar_today, size: 14),
                  label: Text('${fmt.format(_exportDateFrom!)} →'),
                  visualDensity: VisualDensity.compact,
                ),
              if (_exportDateTo != null)
                Chip(
                  avatar: const Icon(Icons.calendar_today, size: 14),
                  label: Text('→ ${fmt.format(_exportDateTo!)}'),
                  visualDensity: VisualDensity.compact,
                ),
            ],
          ),

        const SizedBox(height: 12),

        if (adifState.operation == AdifOperation.exporting)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(children: [
                const CircularProgressIndicator(),
                const SizedBox(width: 12),
                Text(l10n.exporting),
              ]),
            ),
          ),

        _StatusCard(
            adifState: adifState, tabIndex: 1, controller: _tabController),

        const SizedBox(height: 16),

        FilledButton.icon(
          onPressed: adifState.operation == AdifOperation.exporting
              ? null
              : () {
                  ref.read(adifProvider.notifier).reset();
                  ref.read(adifProvider.notifier).exportAdif(
                        stationId: _exportStationId,
                        dateFrom: _exportDateFrom,
                        dateTo: _exportDateTo,
                        dialogTitle: l10n.selectSaveLocation,
                        noStationsMessage: l10n.noStationForExport,
                      );
                },
          icon: const Icon(Icons.download),
          label: Text(l10n.exportAndShare),
        ),
      ],
    );
  }
}

class _DatePickerTile extends StatelessWidget {
  final String label;
  final DateTime? date;
  final String? formatted;
  final String notSelectedLabel;
  final VoidCallback onTap;
  final VoidCallback? onClear;

  const _DatePickerTile({
    required this.label,
    required this.date,
    required this.formatted,
    required this.notSelectedLabel,
    required this.onTap,
    this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          border: Border.all(color: cs.outlineVariant),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(children: [
          Icon(Icons.calendar_month_outlined, size: 18, color: cs.primary),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: TextStyle(
                        fontSize: 11, color: cs.onSurfaceVariant)),
                Text(
                  formatted ?? notSelectedLabel,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: date != null
                        ? FontWeight.bold
                        : FontWeight.normal,
                    color: date != null ? null : cs.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          if (onClear != null)
            GestureDetector(
              onTap: onClear,
              child: Icon(Icons.close, size: 16, color: cs.error),
            ),
        ]),
      ),
    );
  }
}

class _StatusCard extends StatelessWidget {
  final AdifState adifState;
  final int tabIndex;
  final TabController controller;

  const _StatusCard({
    required this.adifState,
    required this.tabIndex,
    required this.controller,
  });

  void _copyPath(BuildContext context, String path) {
    Clipboard.setData(ClipboardData(text: path));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(context.l10n.pathCopied),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _reshare(String path) async {
    if (File(path).existsSync()) {
      await Share.shareXFiles([XFile(path)], text: 'Wavelog ADIF Export');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    if (adifState.operation == AdifOperation.success &&
        controller.index == tabIndex) {
      final path = adifState.exportFilePath;
      // Mesajı l10n ile burada kur — provider dil bilgisine sahip değil
      final successText = tabIndex == 0
          ? l10n.qsoImported(adifState.processedCount, adifState.totalCount)
          : l10n.qsoExported(adifState.processedCount);
      return Card(
        color: Colors.green.shade900,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                const Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: 10),
                Text(successText,
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
              ]),

              if (path != null) ...[
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(children: [
                    const Icon(Icons.folder_outlined,
                        color: Colors.white70, size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        path,
                        style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 11,
                            fontFamily: 'monospace'),
                      ),
                    ),
                  ]),
                ),
                const SizedBox(height: 8),
                Row(children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _copyPath(context, path),
                      icon: const Icon(Icons.copy, size: 15,
                          color: Colors.white),
                      label: Text(l10n.copyPath,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 13)),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.white38),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _reshare(path),
                      icon: const Icon(Icons.share, size: 15,
                          color: Colors.white),
                      label: Text(l10n.reshare,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 13)),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.white38),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                      ),
                    ),
                  ),
                ]),
              ],
            ],
          ),
        ),
      );
    }

    if (adifState.operation == AdifOperation.error) {
      return Card(
        color: Colors.red.shade900,
        child: ListTile(
          leading: const Icon(Icons.error, color: Colors.white),
          title: Text(adifState.errorMessage ?? l10n.error,
              style: const TextStyle(color: Colors.white)),
        ),
      );
    }
    return const SizedBox.shrink();
  }
}
