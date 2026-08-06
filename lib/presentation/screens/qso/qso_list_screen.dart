import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../../core/constants/band_mode_data.dart';
import '../../../core/utils/adif_generator.dart';
import '../../../core/utils/error_l10n.dart';
import '../../../core/utils/l10n_extension.dart';
import '../../../data/models/qso_model.dart';
import '../../../providers/qso_provider.dart';
import '../../widgets/common/error_view.dart';
import '../../widgets/qso/qso_list_tile.dart';
import '../../../router.dart';

class QsoListScreen extends ConsumerStatefulWidget {
  const QsoListScreen({super.key});

  @override
  ConsumerState<QsoListScreen> createState() => _QsoListScreenState();
}

class _QsoListScreenState extends ConsumerState<QsoListScreen> {
  final _searchCtrl = TextEditingController();
  Timer? _searchDebounce;

  // Multi-select state
  final _selectedIds = <String>{};
  bool _selectionMode = false;

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _searchCtrl.dispose();
    super.dispose();
  }

  void _enterSelectionMode(String id) {
    setState(() {
      _selectionMode = true;
      _selectedIds.add(id);
    });
  }

  void _exitSelectionMode() {
    setState(() {
      _selectionMode = false;
      _selectedIds.clear();
    });
  }

  void _toggleSelection(String id) {
    setState(() {
      if (_selectedIds.contains(id)) {
        _selectedIds.remove(id);
        if (_selectedIds.isEmpty) _selectionMode = false;
      } else {
        _selectedIds.add(id);
      }
    });
  }

  void _selectAll(List<QsoModel> list) {
    setState(() {
      _selectedIds.addAll(list.map((q) => q.localId ?? '').where((id) => id.isNotEmpty));
    });
  }

  Future<void> _exportSelected(List<QsoModel> all) async {
    final selected = all.where((q) => _selectedIds.contains(q.localId)).toList();
    if (selected.isEmpty) return;
    final adif = AdifGenerator.generate(selected);
    final dir = await getTemporaryDirectory();
    final now = DateTime.now();
    final stamp =
        '${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}'
        '_${now.hour.toString().padLeft(2, '0')}${now.minute.toString().padLeft(2, '0')}';
    final file = File('${dir.path}/wavelog_$stamp.adif');
    await file.writeAsString(adif);
    await Share.shareXFiles([XFile(file.path)], text: 'Wavelog ADIF Export');
  }

  Future<void> _deleteSelected(List<QsoModel> all) async {
    final l10n = context.l10n;
    final count = _selectedIds.length;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.deleteQsoTitle),
        content: Text(l10n.deleteSelectedConfirm(count)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    for (final qso in all.where((q) => _selectedIds.contains(q.localId))) {
      await ref.read(qsoProvider.notifier).deleteQso(qso);
    }
    _exitSelectionMode();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    // Filtrelenmiş görünüm — filtre değişimi ağa çıkmaz
    final qsos = ref.watch(filteredQsoProvider);
    final filter = ref.watch(qsoFilterProvider);
    final cs = Theme.of(context).colorScheme;

    return PopScope(
      canPop: !_selectionMode,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _exitSelectionMode();
      },
      child: Scaffold(
        appBar: _selectionMode
            ? AppBar(
                leading: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: _exitSelectionMode,
                ),
                title: Text(l10n.selectedCount(_selectedIds.length)),
                actions: [
                  qsos.whenData((list) => list).valueOrNull != null
                      ? IconButton(
                          icon: const Icon(Icons.select_all),
                          tooltip: l10n.selectAll,
                          onPressed: () =>
                              _selectAll(qsos.valueOrNull ?? []),
                        )
                      : const SizedBox.shrink(),
                ],
              )
            : AppBar(
                leading: const DrawerMenuButton(),
                title: Text(l10n.logbookTitle),
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(56),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                    child: SearchBar(
                      controller: _searchCtrl,
                      hintText: l10n.searchHint,
                      leading: const Icon(Icons.search),
                      trailing: [
                        if (_searchCtrl.text.isNotEmpty)
                          IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchCtrl.clear();
                              ref.read(qsoProvider.notifier).applyFilter(
                                  filter.copyWith(callsign: ''));
                            },
                          )
                      ],
                      onChanged: (v) {
                        _searchDebounce?.cancel();
                        _searchDebounce =
                            Timer(const Duration(milliseconds: 350), () {
                          ref.read(qsoProvider.notifier).applyFilter(
                              filter.copyWith(callsign: v));
                        });
                      },
                    ),
                  ),
                ),
                actions: [
                  PopupMenuButton<void>(
                    icon: const Icon(Icons.filter_list),
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        child: Text(l10n.refresh),
                        onTap: () {
                          _searchCtrl.clear();
                          ref.read(qsoProvider.notifier).clearFilter();
                        },
                      ),
                    ],
                  ),
                ],
              ),
        body: Column(
          children: [
            if (!_selectionMode) ...[
              SizedBox(
                height: 44,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: FilterChip(
                        label: Text(l10n.filterAll),
                        selected: filter.band == null,
                        onSelected: (_) => ref
                            .read(qsoProvider.notifier)
                            .applyFilter(filter.copyWith(band: null)),
                      ),
                    ),
                    ...kCommonBands.map(
                      (b) => Padding(
                        padding: const EdgeInsets.only(right: 6),
                        child: FilterChip(
                          label: Text(b),
                          selected: filter.band == b,
                          onSelected: (_) => ref
                              .read(qsoProvider.notifier)
                              .applyFilter(filter.copyWith(band: b)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 44,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: FilterChip(
                        label: Text(l10n.filterAllModes),
                        selected: filter.mode == null,
                        onSelected: (_) => ref
                            .read(qsoProvider.notifier)
                            .applyFilter(filter.copyWith(mode: null)),
                      ),
                    ),
                    ...kCommonModes.map(
                      (m) => Padding(
                        padding: const EdgeInsets.only(right: 6),
                        child: FilterChip(
                          label: Text(m),
                          selected: filter.mode == m,
                          onSelected: (_) => ref
                              .read(qsoProvider.notifier)
                              .applyFilter(filter.copyWith(mode: m)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            Expanded(
              child: qsos.when(
                data: (list) {
                  if (list.isEmpty) {
                    return EmptyView(
                      message: l10n.noQsos,
                      icon: Icons.radio_outlined,
                    );
                  }
                  return RefreshIndicator(
                    onRefresh: () => ref.read(qsoProvider.notifier).refresh(),
                    child: ListView.builder(
                      itemCount: list.length,
                      itemBuilder: (context, i) {
                        final qso = list[i];
                        final id = qso.localId ?? '';
                        final isSelected = _selectedIds.contains(id);

                        return InkWell(
                          onLongPress: _selectionMode
                              ? null
                              : () => _enterSelectionMode(id),
                          onTap: _selectionMode
                              ? () => _toggleSelection(id)
                              : null,
                          child: ColoredBox(
                            color: isSelected
                                ? cs.primaryContainer.withValues(alpha: 0.35)
                                : Colors.transparent,
                            child: Row(
                              children: [
                                if (_selectionMode)
                                  Padding(
                                    padding: const EdgeInsets.only(left: 4),
                                    child: Checkbox(
                                      value: isSelected,
                                      onChanged: (_) => _toggleSelection(id),
                                    ),
                                  ),
                                Expanded(
                                  child: QsoListTile(
                                    qso: qso,
                                    onTap: _selectionMode
                                        ? () => _toggleSelection(id)
                                        : () => context.push(
                                            '/qsos/${Uri.encodeComponent(id.isEmpty ? i.toString() : id)}'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
                loading: () =>
                    const Center(child: CircularProgressIndicator()),
                error: (e, _) => ErrorView(
                  message: localizeError(context, e),
                  onRetry: () => ref.read(qsoProvider.notifier).refresh(),
                ),
              ),
            ),
            if (_selectionMode && _selectedIds.isNotEmpty)
              _SelectionActionBar(
                count: _selectedIds.length,
                onExport: () => _exportSelected(qsos.valueOrNull ?? []),
                onDelete: () => _deleteSelected(qsos.valueOrNull ?? []),
              ),
          ],
        ),
        floatingActionButton: _selectionMode
            ? null
            : FloatingActionButton(
                onPressed: () => context.push('/add-qso'),
                child: const Icon(Icons.add),
              ),
      ),
    );
  }
}

class _SelectionActionBar extends StatelessWidget {
  final int count;
  final VoidCallback onExport;
  final VoidCallback onDelete;

  const _SelectionActionBar({
    required this.count,
    required this.onExport,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final cs = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        border: Border(top: BorderSide(color: cs.outlineVariant)),
      ),
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 8,
        bottom: MediaQuery.of(context).padding.bottom + 8,
      ),
      child: Row(
        children: [
          Text(
            l10n.selectedCount(count),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600),
          ),
          const Spacer(),
          OutlinedButton.icon(
            onPressed: onExport,
            icon: const Icon(Icons.share, size: 16),
            label: Text(l10n.exportSelected),
          ),
          const SizedBox(width: 8),
          FilledButton.icon(
            onPressed: onDelete,
            style: FilledButton.styleFrom(
                backgroundColor: cs.errorContainer,
                foregroundColor: cs.onErrorContainer),
            icon: const Icon(Icons.delete_outline, size: 16),
            label: Text(l10n.deleteSelected),
          ),
        ],
      ),
    );
  }
}
