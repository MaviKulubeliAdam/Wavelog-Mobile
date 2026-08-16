import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/utils/error_l10n.dart';
import '../../../core/utils/l10n_extension.dart';
import '../../../data/models/station_logbook_model.dart';
import '../../../data/models/station_model.dart';
import '../../../providers/remote_datasource_provider.dart';
import '../../../providers/settings_provider.dart';
import '../../../providers/station_logbook_provider.dart';
import '../../../providers/station_provider.dart';
import '../../widgets/common/error_view.dart';

class StationListScreen extends ConsumerStatefulWidget {
  const StationListScreen({super.key});

  @override
  ConsumerState<StationListScreen> createState() => _StationListScreenState();
}

class _StationListScreenState extends ConsumerState<StationListScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 2, vsync: this);
    _tabs.addListener(() {
      if (!_tabs.indexIsChanging) setState(() {});
    });
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final tabIndex = _tabs.index;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.stationSetup),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: l10n.refresh,
            onPressed: () {
              if (tabIndex == 0) {
                ref.read(stationLogbookProvider.notifier).refresh();
              } else {
                ref.read(stationProvider.notifier).refresh();
              }
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabs,
          tabs: [
            Tab(icon: const Icon(Icons.book_outlined), text: l10n.logbooks),
            Tab(
                icon: const Icon(Icons.cell_tower_outlined),
                text: l10n.locations),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'station_setup_fab',
        onPressed: tabIndex == 0
            ? () => _showCreateLogbookDialog(context)
            : () => context.push('/stations/new'),
        child: const Icon(Icons.add),
      ),
      body: TabBarView(
        controller: _tabs,
        children: const [_LogbooksTab(), _LocationsTab()],
      ),
    );
  }

  Future<void> _showCreateLogbookDialog(BuildContext context) async {
    final l10n = context.l10n;
    final ctrl = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.newLogbook),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          decoration: InputDecoration(labelText: l10n.logbookName),
          onSubmitted: (_) => Navigator.of(ctx).pop(true),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: Text(l10n.cancel)),
          FilledButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              child: Text(l10n.save)),
        ],
      ),
    );
    if (ok == true && ctrl.text.trim().isNotEmpty && mounted) {
      final err = await ref
          .read(stationLogbookProvider.notifier)
          .createLogbook(ctrl.text.trim());
      if (err != null && context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(err)));
      }
    }
    ctrl.dispose();
  }
}

// ─────────────────────────── Logbooks Tab ──────────────────────────────────

class _LogbooksTab extends ConsumerWidget {
  const _LogbooksTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final logbooks = ref.watch(stationLogbookProvider);
    final settings = ref.watch(settingsProvider);

    return logbooks.when(
      data: (list) {
        if (list.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.book_outlined,
                      size: 64,
                      color: Theme.of(context).colorScheme.onSurfaceVariant),
                  const SizedBox(height: 16),
                  Text(l10n.newLogbook,
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text(
                    l10n.noStationsHint,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant),
                  ),
                ],
              ),
            ),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(0, 8, 0, 88),
          itemCount: list.length,
          itemBuilder: (ctx, i) => _LogbookTile(
            logbook: list[i],
            isActive: settings.activeLogbookId == list[i].id,
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => ErrorView(
        message: localizeError(context, e),
        onRetry: () => ref.read(stationLogbookProvider.notifier).refresh(),
      ),
    );
  }
}

class _LogbookTile extends ConsumerWidget {
  final StationLogbookModel logbook;
  final bool isActive;
  const _LogbookTile({required this.logbook, required this.isActive});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      color: isActive ? theme.colorScheme.primaryContainer : null,
      child: ListTile(
        onTap: () =>
            context.push('/stations/logbook/${logbook.id}', extra: logbook),
        leading: Icon(
          Icons.book_outlined,
          color: isActive ? theme.colorScheme.primary : null,
        ),
        title: Text(logbook.name),
        subtitle: Text(
            '${logbook.locations.length} ${l10n.locations.toLowerCase()}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isActive)
              Chip(
                label: Text(l10n.activeLogbook,
                    style: const TextStyle(fontSize: 11)),
                backgroundColor:
                    theme.colorScheme.primary.withValues(alpha: 0.2),
                padding: EdgeInsets.zero,
                visualDensity: VisualDensity.compact,
              ),
            PopupMenuButton<_LogbookAction>(
              onSelected: (a) => _handle(context, ref, a),
              itemBuilder: (_) => [
                _item(Icons.check_circle_outline, l10n.setActiveLogbook,
                    _LogbookAction.setActive, theme),
                _item(Icons.edit_outlined, l10n.renameLogbook,
                    _LogbookAction.rename, theme),
                _item(Icons.delete_outlined, l10n.deleteLogbook,
                    _LogbookAction.delete, theme,
                    danger: true),
              ],
            ),
          ],
        ),
      ),
    );
  }

  PopupMenuItem<_LogbookAction> _item(
      IconData icon, String label, _LogbookAction value, ThemeData theme,
      {bool danger = false}) {
    final color = danger ? theme.colorScheme.error : null;
    return PopupMenuItem(
      value: value,
      child: Row(children: [
        Icon(icon, size: 20, color: color),
        const SizedBox(width: 12),
        Text(label, style: TextStyle(color: color)),
      ]),
    );
  }

  Future<void> _handle(
      BuildContext context, WidgetRef ref, _LogbookAction action) async {
    final l10n = context.l10n;
    switch (action) {
      case _LogbookAction.setActive:
        final err = await ref
            .read(stationLogbookProvider.notifier)
            .setActive(logbook.id);
        if (err != null && context.mounted) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(err)));
        }

      case _LogbookAction.rename:
        final ctrl = TextEditingController(text: logbook.name);
        final ok = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text(l10n.renameLogbook),
            content: TextField(
              controller: ctrl,
              autofocus: true,
              decoration: InputDecoration(labelText: l10n.logbookName),
              onSubmitted: (_) => Navigator.of(ctx).pop(true),
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.of(ctx).pop(false),
                  child: Text(l10n.cancel)),
              FilledButton(
                  onPressed: () => Navigator.of(ctx).pop(true),
                  child: Text(l10n.save)),
            ],
          ),
        );
        if (ok == true && ctrl.text.trim().isNotEmpty && context.mounted) {
          final err = await ref
              .read(stationLogbookProvider.notifier)
              .updateLogbook(logbook.id, ctrl.text.trim());
          if (err != null && context.mounted) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(err)));
          }
        }
        ctrl.dispose();

      case _LogbookAction.delete:
        final ok = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text(l10n.deleteLogbookConfirm),
            content: Text(l10n.deleteLogbookWarning),
            actions: [
              TextButton(
                  onPressed: () => Navigator.of(ctx).pop(false),
                  child: Text(l10n.cancel)),
              FilledButton(
                style: FilledButton.styleFrom(
                    backgroundColor: Theme.of(ctx).colorScheme.error),
                onPressed: () => Navigator.of(ctx).pop(true),
                child: Text(l10n.deleteStation),
              ),
            ],
          ),
        );
        if (ok == true && context.mounted) {
          final err = await ref
              .read(stationLogbookProvider.notifier)
              .deleteLogbook(logbook.id);
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(err ?? l10n.logbookDeleted),
            ));
          }
        }
    }
  }
}

enum _LogbookAction { setActive, rename, delete }

// ─────────────────────────── Locations Tab ─────────────────────────────────

class _LocationsTab extends ConsumerWidget {
  const _LocationsTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final stations = ref.watch(stationProvider);
    final settings = ref.watch(settingsProvider);

    return stations.when(
      data: (list) {
        if (list.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.cell_tower_outlined,
                      size: 64,
                      color: Theme.of(context).colorScheme.onSurfaceVariant),
                  const SizedBox(height: 16),
                  Text(l10n.noStations,
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text(
                    l10n.noStationsHint,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant),
                  ),
                ],
              ),
            ),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(0, 8, 0, 88),
          itemCount: list.length,
          itemBuilder: (ctx, i) => _LocationTile(
            station: list[i],
            isSelected: settings.activeStationProfileId == list[i].id,
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => ErrorView(
        message: localizeError(context, e),
        onRetry: () => ref.read(stationProvider.notifier).refresh(),
      ),
    );
  }
}

class _LocationTile extends ConsumerWidget {
  final StationModel station;
  final bool isSelected;
  const _LocationTile({required this.station, required this.isSelected});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      color: isSelected ? theme.colorScheme.primaryContainer : null,
      child: ListTile(
        onTap: () => _activate(context, ref),
        leading: Icon(
          station.isActive ? Icons.cell_tower : Icons.cell_tower_outlined,
          color: station.isActive ? theme.colorScheme.primary : null,
        ),
        title: Text(station.profileName, style: theme.textTheme.titleMedium),
        subtitle: Text(
          '${station.callsign}  ${station.gridSquare != null ? "• ${station.gridSquare}" : ""}',
          style: theme.textTheme.bodySmall,
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isSelected)
              Chip(
                label: Text(l10n.active, style: const TextStyle(fontSize: 11)),
                backgroundColor:
                    theme.colorScheme.primary.withValues(alpha: 0.2),
                padding: EdgeInsets.zero,
                visualDensity: VisualDensity.compact,
              ),
            PopupMenuButton<_LocationAction>(
              onSelected: (a) => _handle(context, ref, a),
              itemBuilder: (_) => [
                _item(Icons.edit_outlined, l10n.editStation,
                    _LocationAction.edit, theme),
                _item(Icons.copy_outlined, l10n.cloneStation,
                    _LocationAction.clone, theme),
                _item(Icons.delete_outlined, l10n.deleteStation,
                    _LocationAction.delete, theme,
                    danger: true),
              ],
            ),
          ],
        ),
      ),
    );
  }

  PopupMenuItem<_LocationAction> _item(
      IconData icon, String label, _LocationAction value, ThemeData theme,
      {bool danger = false}) {
    final color = danger ? theme.colorScheme.error : null;
    return PopupMenuItem(
      value: value,
      child: Row(children: [
        Icon(icon, size: 20, color: color),
        const SizedBox(width: 12),
        Text(label, style: TextStyle(color: color)),
      ]),
    );
  }

  Future<void> _activate(BuildContext context, WidgetRef ref) async {
    await ref.read(settingsProvider.notifier).setActiveStation(station);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content:
              Text(context.l10n.stationActivated(station.callsign))));
    }
    // Sync active station to server in background — ignore failures (offline-safe)
    ref.read(wavelogRemoteDatasourceProvider).setActiveStation(station.id).catchError((_) {});
  }

  Future<void> _handle(
      BuildContext context, WidgetRef ref, _LocationAction action) async {
    final l10n = context.l10n;
    switch (action) {
      case _LocationAction.edit:
        final full = await ref
            .read(stationProvider.notifier)
            .getStationDetail(station.id);
        if (!context.mounted) return;
        if (full == null) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(l10n.loadDetailsFailed)));
          return;
        }
        context.push('/stations/edit', extra: full);

      case _LocationAction.clone:
        final ctrl = TextEditingController(
            text: '${station.profileName} ${l10n.copySuffix}');
        final ok = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text(l10n.cloneStation),
            content: TextField(
              controller: ctrl,
              autofocus: true,
              decoration: InputDecoration(labelText: l10n.newStationName),
              onSubmitted: (_) => Navigator.of(ctx).pop(true),
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.of(ctx).pop(false),
                  child: Text(l10n.cancel)),
              FilledButton(
                  onPressed: () => Navigator.of(ctx).pop(true),
                  child: Text(l10n.cloneStation)),
            ],
          ),
        );
        if (ok == true && ctrl.text.trim().isNotEmpty && context.mounted) {
          final err = await ref
              .read(stationProvider.notifier)
              .cloneStation(station, ctrl.text.trim());
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(err ?? l10n.stationCloned),
            ));
          }
        }
        ctrl.dispose();

      case _LocationAction.delete:
        if (ref.read(settingsProvider).activeStationProfileId == station.id) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(l10n.cannotDeleteActiveStation)));
          return;
        }
        final ok = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text(l10n.deleteStationConfirm),
            content: Text(l10n.deleteStationWarning),
            actions: [
              TextButton(
                  onPressed: () => Navigator.of(ctx).pop(false),
                  child: Text(l10n.cancel)),
              FilledButton(
                style: FilledButton.styleFrom(
                    backgroundColor: Theme.of(ctx).colorScheme.error),
                onPressed: () => Navigator.of(ctx).pop(true),
                child: Text(l10n.deleteStation,
                    style: const TextStyle(color: Colors.white)),
              ),
            ],
          ),
        );
        if (ok == true && context.mounted) {
          final err =
              await ref.read(stationProvider.notifier).deleteStation(station.id);
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(err ?? l10n.stationDeleted),
            ));
          }
        }
    }
  }
}

enum _LocationAction { edit, clone, delete }
