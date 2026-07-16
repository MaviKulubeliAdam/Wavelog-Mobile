import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/utils/l10n_extension.dart';
import '../../../data/models/station_logbook_model.dart';
import '../../../data/models/station_model.dart';
import '../../../providers/station_logbook_provider.dart';
import '../../../providers/station_provider.dart';

class StationLogbookDetailScreen extends ConsumerWidget {
  final int logbookId;
  final StationLogbookModel? initialLogbook;

  const StationLogbookDetailScreen({
    super.key,
    required this.logbookId,
    this.initialLogbook,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final logbooks = ref.watch(stationLogbookProvider);

    final logbook = logbooks.whenData((list) {
      return list.cast<StationLogbookModel?>().firstWhere(
            (lb) => lb?.id == logbookId,
            orElse: () => initialLogbook,
          );
    }).valueOrNull ??
        initialLogbook;

    return Scaffold(
      appBar: AppBar(
        title: Text(logbook?.name ?? l10n.logbooks),
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'logbook_detail_fab',
        onPressed: () => _showLinkDialog(context, ref, logbook),
        icon: const Icon(Icons.add_link),
        label: Text(l10n.linkLocation),
      ),
      body: logbook == null
          ? const Center(child: CircularProgressIndicator())
          : logbook.locations.isEmpty
              ? const _EmptyLocations()
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(0, 8, 0, 88),
                  itemCount: logbook.locations.length,
                  itemBuilder: (ctx, i) => _LinkedLocationTile(
                    station: logbook.locations[i],
                    logbookId: logbookId,
                  ),
                ),
    );
  }

  Future<void> _showLinkDialog(
      BuildContext context, WidgetRef ref, StationLogbookModel? logbook) async {
    final l10n = context.l10n;
    final allStations = ref.read(stationProvider).valueOrNull ?? [];
    final linkedIds =
        (logbook?.locations.map((s) => s.id).toSet()) ?? <int>{};
    final available =
        allStations.where((s) => !linkedIds.contains(s.id)).toList();

    if (available.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.noStations)));
      return;
    }

    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.linkLocation),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: available.length,
            itemBuilder: (_, i) {
              final station = available[i];
              return ListTile(
                leading: const Icon(Icons.cell_tower_outlined),
                title: Text(station.profileName),
                subtitle: Text(station.callsign),
                onTap: () async {
                  Navigator.of(ctx).pop();
                  final err = await ref
                      .read(stationLogbookProvider.notifier)
                      .link(logbookId, station.id);
                  if (err != null && context.mounted) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text(err)));
                  }
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text(l10n.cancel)),
        ],
      ),
    );
  }
}

class _LinkedLocationTile extends ConsumerWidget {
  final StationModel station;
  final int logbookId;
  const _LinkedLocationTile(
      {required this.station, required this.logbookId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: ListTile(
        leading: Icon(
          station.isActive ? Icons.cell_tower : Icons.cell_tower_outlined,
          color: station.isActive
              ? Theme.of(context).colorScheme.primary
              : null,
        ),
        title: Text(station.profileName),
        subtitle: Text(
            '${station.callsign}  ${station.gridSquare != null ? "• ${station.gridSquare}" : ""}'),
        trailing: IconButton(
          icon: Icon(Icons.link_off,
              color: Theme.of(context).colorScheme.error),
          tooltip: l10n.unlinkLocation,
          onPressed: () => _confirmUnlink(context, ref),
        ),
      ),
    );
  }

  Future<void> _confirmUnlink(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.unlinkLocation),
        content: Text('${station.profileName} — ${station.callsign}'),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: Text(l10n.cancel)),
          FilledButton(
            style: FilledButton.styleFrom(
                backgroundColor: Theme.of(ctx).colorScheme.error),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(l10n.unlinkLocation),
          ),
        ],
      ),
    );
    if (ok == true && context.mounted) {
      final err = await ref
          .read(stationLogbookProvider.notifier)
          .unlink(logbookId, station.id);
      if (err != null && context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(err)));
      }
    }
  }
}

class _EmptyLocations extends StatelessWidget {
  const _EmptyLocations();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.link_off,
                size: 64,
                color: Theme.of(context).colorScheme.onSurfaceVariant),
            const SizedBox(height: 16),
            Text(
              l10n.linkedLocations,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.linkLocation,
              style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}
