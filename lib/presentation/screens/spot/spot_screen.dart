import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/enums/activity_type.dart';
import '../../../core/utils/l10n_extension.dart';
import '../../../data/datasources/remote/pota_datasource.dart';
import '../../../data/datasources/remote/sota_datasource.dart';
import '../../../data/models/pota_spot_model.dart';
import '../../../data/models/sota_spot_model.dart';
import '../../../data/models/wwff_spot_model.dart';
import '../../../providers/dx_spot_provider.dart';
import '../../../providers/pota_spot_provider.dart';
import '../../../providers/settings_provider.dart';
import '../../../providers/sota_spot_provider.dart';
import '../../../providers/wwff_spot_provider.dart';
import '../../../router.dart';

// Currently selected activity type
final _selectedActivityProvider =
    StateProvider<ActivityType>((_) => ActivityType.dx);

class SpotScreen extends ConsumerWidget {
  const SpotScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final selected = ref.watch(_selectedActivityProvider);

    return Scaffold(
      appBar: AppBar(
        leading: const DrawerMenuButton(),
        title: Text(l10n.spotTitle),
        actions: [
          if (selected.available)
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                switch (selected) {
                  case ActivityType.pota:
                    ref.invalidate(potaSpotsProvider);
                  case ActivityType.sota:
                    ref.invalidate(sotaSpotsProvider);
                  case ActivityType.wwff:
                    ref.invalidate(wwffSpotsProvider);
                  case ActivityType.dx:
                    ref.invalidate(dxSpotsProvider);
                  case ActivityType.iota:
                    break;
                }
              },
            ),
        ],
      ),
      body: Column(
        children: [
          _ActivitySelector(
            selected: selected,
            onChanged: (t) =>
                ref.read(_selectedActivityProvider.notifier).state = t,
          ),
          const Divider(height: 1),
          Expanded(
            child: switch (selected) {
              ActivityType.pota => const _PotaSpotContent(),
              ActivityType.sota => const _SotaSpotContent(),
              ActivityType.wwff => const _WwffSpotContent(),
              ActivityType.dx   => const _DxClusterContent(),
              ActivityType.iota => _ComingSoonView(activity: selected),
            },
          ),
        ],
      ),
      floatingActionButton: selected.canAddSpot
          ? FloatingActionButton.extended(
              onPressed: () => _showAddSpot(context, ref, selected),
              icon: const Icon(Icons.add),
              label: Text(l10n.spotAdd),
            )
          : (selected.available && selected != ActivityType.dx)
              ? FloatingActionButton.extended(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            '${selected.label} ${l10n.spotAddComingSoon}'),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                  icon: const Icon(Icons.add),
                  label: Text(l10n.spotAdd),
                  backgroundColor: Theme.of(context)
                      .colorScheme
                      .surfaceContainerHighest,
                  foregroundColor: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.5),
                )
              : null,
    );
  }

  void _showAddSpot(
      BuildContext context, WidgetRef ref, ActivityType activity) {
    final settings = ref.read(settingsProvider);
    final myCall = settings.activeStationCallsign ?? '';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => _AddSpotSheet(
        activity: activity,
        defaultCallsign: myCall,
        onSubmit: (data) async {
          switch (activity) {
            case ActivityType.sota:
              await ref.read(addSotaSpotProvider)(
                activator: data.activator,
                spotter: data.spotter,
                frequency: data.frequency,
                mode: data.mode,
                reference: data.reference,
                comments: data.comments,
              );
            default:
              await ref.read(addPotaSpotProvider)(
                activator: data.activator,
                spotter: data.spotter,
                frequency: data.frequency,
                mode: data.mode,
                reference: data.reference,
                comments: data.comments,
              );
          }
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Activity Selector
// ─────────────────────────────────────────────────────────────────────────────

class _ActivitySelector extends StatelessWidget {
  final ActivityType selected;
  final ValueChanged<ActivityType> onChanged;

  const _ActivitySelector({
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      height: 72,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        children: ActivityType.values.map((type) {
          final isSelected = type == selected;
          final isAvailable = type.available;

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: isAvailable ? () => onChanged(type) : null,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: isSelected
                      ? theme.colorScheme.primaryContainer
                      : isAvailable
                          ? theme.colorScheme.surfaceContainerHighest
                          : theme.colorScheme.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected
                        ? theme.colorScheme.primary
                        : Colors.transparent,
                    width: 1.5,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(type.icon,
                        style: TextStyle(
                            fontSize: 18,
                            color: isAvailable ? null : Colors.grey)),
                    const SizedBox(width: 6),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          type.label,
                          style: theme.textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: isSelected
                                ? theme.colorScheme.onPrimaryContainer
                                : isAvailable
                                    ? theme.colorScheme.onSurface
                                    : theme.colorScheme.onSurface
                                        .withValues(alpha: 0.35),
                          ),
                        ),
                        if (!isAvailable)
                          Text(
                            'Coming soon',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: theme.colorScheme.onSurface
                                  .withValues(alpha: 0.35),
                              fontSize: 9,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Coming Soon placeholder
// ─────────────────────────────────────────────────────────────────────────────

class _ComingSoonView extends StatelessWidget {
  final ActivityType activity;
  const _ComingSoonView({required this.activity});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(activity.icon, style: const TextStyle(fontSize: 56)),
          const SizedBox(height: 16),
          Text(
            activity.label,
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text(
            activity.fullName,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.5),
                ),
          ),
          const SizedBox(height: 20),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'Coming soon',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.5),
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Ortak spot altyapısı — dört aktivite tipi tek kalıptan çizilir.
// (Önceden içerik/filtre/tile/format kodunun dörder kopyası vardı.)
// ─────────────────────────────────────────────────────────────────────────────

String _formatAge(DateTime dt) {
  final diff = DateTime.now().toUtc().difference(dt.toUtc());
  if (diff.inMinutes < 1) return '<1m';
  if (diff.inMinutes < 60) return '${diff.inMinutes}m';
  if (diff.inHours < 24) return '${diff.inHours}h';
  return '${diff.inDays}d';
}

List<String> _distinct(Iterable<String?> values) =>
    values
        .whereType<String>()
        .where((v) => v.isNotEmpty)
        .toSet()
        .toList()
      ..sort();

/// Tile'ın ihtiyaç duyduğu ortak alanlar — her model buna eşlenir.
class _SpotView {
  final String activator;
  final String mode;
  final String? band;
  final String freqDisplay;
  final IconData? refIcon; // null → referans satırı yok (DX)
  final String? refLine;
  final String comments;
  final String spotter;
  final DateTime time;

  const _SpotView({
    required this.activator,
    required this.mode,
    required this.band,
    required this.freqDisplay,
    this.refIcon,
    this.refLine,
    required this.comments,
    required this.spotter,
    required this.time,
  });
}

class _SpotTile extends StatelessWidget {
  final _SpotView spot;
  final Color avatarBg;
  final Color avatarFg;

  const _SpotTile({
    required this.spot,
    required this.avatarBg,
    required this.avatarFg,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dimmed = theme.colorScheme.onSurface.withValues(alpha: 0.5);

    return ListTile(
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      leading: CircleAvatar(
        radius: 20,
        backgroundColor: avatarBg,
        child: Text(
          spot.band ?? '?',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: avatarFg,
          ),
        ),
      ),
      title: Row(
        children: [
          Text(spot.activator,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(width: 8),
          _ModeChip(spot.mode),
          const Spacer(),
          Text(
            spot.freqDisplay,
            style: theme.textTheme.bodySmall?.copyWith(
              fontFamily: 'monospace',
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (spot.refLine != null) ...[
            const SizedBox(height: 2),
            Row(
              children: [
                Icon(spot.refIcon, size: 12),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    spot.refLine!,
                    style: theme.textTheme.bodySmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
          if (spot.comments.isNotEmpty) ...[
            const SizedBox(height: 2),
            Text(
              spot.comments,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                fontStyle: FontStyle.italic,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          const SizedBox(height: 2),
          Row(
            children: [
              Icon(Icons.person_outline, size: 12, color: dimmed),
              const SizedBox(width: 4),
              Text(spot.spotter,
                  style:
                      theme.textTheme.bodySmall?.copyWith(color: dimmed)),
              const Spacer(),
              Text(_formatAge(spot.time),
                  style:
                      theme.textTheme.bodySmall?.copyWith(color: dimmed)),
            ],
          ),
        ],
      ),
    );
  }
}

/// Liste bölümü: boş / yükleniyor / hata / liste durumlarını tek yerde çizer.
class _SpotListSection extends StatelessWidget {
  final AsyncValue<List<_SpotView>> spots;
  final VoidCallback onRefresh;
  final Color avatarBg;
  final Color avatarFg;
  final bool showErrorDetails;

  const _SpotListSection({
    required this.spots,
    required this.onRefresh,
    required this.avatarBg,
    required this.avatarFg,
    this.showErrorDetails = false,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return spots.when(
      data: (list) {
        if (list.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.wifi_tethering_off,
                    size: 48,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.3)),
                const SizedBox(height: 12),
                Text(l10n.spotNoResults),
              ],
            ),
          );
        }
        return RefreshIndicator(
          onRefresh: () async => onRefresh(),
          child: ListView.separated(
            padding: const EdgeInsets.only(bottom: 88),
            itemCount: list.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, i) => _SpotTile(
              spot: list[i],
              avatarBg: avatarBg,
              avatarFg: avatarFg,
            ),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.cloud_off, size: 48),
              const SizedBox(height: 12),
              Text(l10n.spotLoadError,
                  style: Theme.of(context).textTheme.titleSmall),
              if (showErrorDetails) ...[
                const SizedBox(height: 6),
                Text(
                  e.toString(),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withValues(alpha: 0.6)),
                  textAlign: TextAlign.center,
                ),
              ],
              const SizedBox(height: 12),
              FilledButton.icon(
                onPressed: onRefresh,
                icon: const Icon(Icons.refresh),
                label: Text(l10n.retry),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Bir dropdown filtre tanımı — onChanged(null) temizler.
class _FilterSpec {
  final String placeholder;
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const _FilterSpec({
    required this.placeholder,
    required this.value,
    required this.items,
    required this.onChanged,
  });
}

class _SpotFilterBar extends StatelessWidget {
  final bool newestFirst;
  final VoidCallback onToggleSort;
  final List<_FilterSpec> filters;
  final VoidCallback onClearAll;

  const _SpotFilterBar({
    required this.newestFirst,
    required this.onToggleSort,
    required this.filters,
    required this.onClearAll,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final hasFilters = filters.any((f) => f.value != null);
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          FilterChip(
            label: Text(newestFirst ? l10n.sortNewest : l10n.sortOldest),
            avatar: Icon(
                newestFirst ? Icons.arrow_downward : Icons.arrow_upward,
                size: 14),
            selected: false,
            onSelected: (_) => onToggleSort(),
          ),
          for (final f in filters) ...[
            const SizedBox(width: 6),
            _DropdownChip(
              label: f.value ?? f.placeholder,
              active: f.value != null,
              items: f.items,
              onSelected: (v) => f.onChanged(v),
              onCleared: () => f.onChanged(null),
            ),
          ],
          if (hasFilters) ...[
            const SizedBox(width: 6),
            ActionChip(
              label: Text(l10n.filterClear),
              avatar: const Icon(Icons.clear, size: 14),
              onPressed: onClearAll,
            ),
          ],
        ],
      ),
    );
  }
}

class _DropdownChip extends StatelessWidget {
  final String label;
  final bool active;
  final List<String> items;
  final ValueChanged<String> onSelected;
  final VoidCallback onCleared;

  const _DropdownChip({
    required this.label,
    required this.active,
    required this.items,
    required this.onSelected,
    required this.onCleared,
  });

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      selected: active,
      deleteIcon: active ? const Icon(Icons.close, size: 14) : null,
      onDeleted: active ? onCleared : null,
      onSelected: (_) async {
        if (items.isEmpty) return;
        final result = await showDialog<String>(
          context: context,
          builder: (ctx) => SimpleDialog(
            children: items
                .map((item) => SimpleDialogOption(
                      onPressed: () => Navigator.pop(ctx, item),
                      child: Text(item),
                    ))
                .toList(),
          ),
        );
        if (result != null) onSelected(result);
      },
    );
  }
}

class _ModeChip extends StatelessWidget {
  final String mode;
  const _ModeChip(this.mode);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        mode,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.onSecondaryContainer,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Aktivite içerikleri — model → _SpotView eşlemesi dışında ortak yapı
// ─────────────────────────────────────────────────────────────────────────────

class _PotaSpotContent extends ConsumerWidget {
  const _PotaSpotContent();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final cs = Theme.of(context).colorScheme;
    final spots = ref.watch(filteredPotaSpotsProvider);
    final filter = ref.watch(potaSpotFilterProvider);
    final allSpots = ref.watch(potaSpotsProvider).valueOrNull ?? [];

    void update(PotaSpotFilter f) =>
        ref.read(potaSpotFilterProvider.notifier).state = f;

    return Column(
      children: [
        _SpotFilterBar(
          newestFirst: filter.newestFirst,
          onToggleSort: () =>
              update(filter.copyWith(newestFirst: !filter.newestFirst)),
          onClearAll: () => update(const PotaSpotFilter()),
          filters: [
            _FilterSpec(
              placeholder: l10n.filterBand,
              value: filter.band,
              items: _distinct(allSpots.map((s) => s.band)),
              onChanged: (v) => update(filter.copyWith(band: v)),
            ),
            _FilterSpec(
              placeholder: l10n.filterMode,
              value: filter.mode,
              items: _distinct(allSpots.map((s) => s.mode)),
              onChanged: (v) => update(filter.copyWith(mode: v)),
            ),
            _FilterSpec(
              placeholder: l10n.filterCountry,
              value: filter.country,
              items: _distinct(allSpots.map((s) => s.countryPrefix)),
              onChanged: (v) => update(filter.copyWith(country: v)),
            ),
          ],
        ),
        const Divider(height: 1),
        Expanded(
          child: _SpotListSection(
            spots: spots.whenData((list) => list
                .map((s) => _SpotView(
                      activator: s.activator,
                      mode: s.mode,
                      band: s.band,
                      freqDisplay: s.freqDisplay,
                      refIcon: Icons.park_outlined,
                      refLine: s.parkName.isNotEmpty
                          ? '${s.reference}  ${s.parkName}'
                          : s.reference,
                      comments: s.comments,
                      spotter: s.spotter,
                      time: s.spotTime,
                    ))
                .toList()),
            onRefresh: () => ref.invalidate(potaSpotsProvider),
            avatarBg: cs.primaryContainer,
            avatarFg: cs.onPrimaryContainer,
          ),
        ),
      ],
    );
  }
}

class _SotaSpotContent extends ConsumerWidget {
  const _SotaSpotContent();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final cs = Theme.of(context).colorScheme;
    final spots = ref.watch(filteredSotaSpotsProvider);
    final filter = ref.watch(sotaSpotFilterProvider);
    final allSpots = ref.watch(sotaSpotsProvider).valueOrNull ?? [];

    void update(SotaSpotFilter f) =>
        ref.read(sotaSpotFilterProvider.notifier).state = f;

    return Column(
      children: [
        _SpotFilterBar(
          newestFirst: filter.newestFirst,
          onToggleSort: () =>
              update(filter.copyWith(newestFirst: !filter.newestFirst)),
          onClearAll: () => update(const SotaSpotFilter()),
          filters: [
            _FilterSpec(
              placeholder: l10n.filterBand,
              value: filter.band,
              items: _distinct(allSpots.map((s) => s.band)),
              onChanged: (v) => update(filter.copyWith(band: v)),
            ),
            _FilterSpec(
              placeholder: l10n.filterMode,
              value: filter.mode,
              items: _distinct(allSpots.map((s) => s.mode)),
              onChanged: (v) => update(filter.copyWith(mode: v)),
            ),
            _FilterSpec(
              placeholder: l10n.filterAssociation,
              value: filter.association,
              items: _distinct(allSpots.map((s) => s.associationCode)),
              onChanged: (v) => update(filter.copyWith(association: v)),
            ),
          ],
        ),
        const Divider(height: 1),
        Expanded(
          child: _SpotListSection(
            spots: spots.whenData((list) => list
                .map((s) => _SpotView(
                      activator: s.activator,
                      mode: s.mode,
                      band: s.band,
                      freqDisplay: s.freqDisplay,
                      refIcon: Icons.terrain_outlined,
                      refLine: s.summitDetails.isNotEmpty
                          ? '${s.reference}  ${s.summitDetails}'
                          : s.reference,
                      comments: s.comments,
                      spotter: s.spotter,
                      time: s.spotTime,
                    ))
                .toList()),
            onRefresh: () => ref.invalidate(sotaSpotsProvider),
            avatarBg: cs.tertiaryContainer,
            avatarFg: cs.onTertiaryContainer,
          ),
        ),
      ],
    );
  }
}

class _WwffSpotContent extends ConsumerWidget {
  const _WwffSpotContent();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final cs = Theme.of(context).colorScheme;
    final spots = ref.watch(filteredWwffSpotsProvider);
    final filter = ref.watch(wwffSpotFilterProvider);
    final allSpots = ref.watch(wwffSpotsProvider).valueOrNull ?? [];

    void update(WwffSpotFilter f) =>
        ref.read(wwffSpotFilterProvider.notifier).state = f;

    return Column(
      children: [
        _SpotFilterBar(
          newestFirst: filter.newestFirst,
          onToggleSort: () =>
              update(filter.copyWith(newestFirst: !filter.newestFirst)),
          onClearAll: () => update(const WwffSpotFilter()),
          filters: [
            _FilterSpec(
              placeholder: l10n.filterBand,
              value: filter.band,
              items: _distinct(allSpots.map((s) => s.band)),
              onChanged: (v) => update(filter.copyWith(band: v)),
            ),
            _FilterSpec(
              placeholder: l10n.filterMode,
              value: filter.mode,
              items: _distinct(allSpots.map((s) => s.mode)),
              onChanged: (v) => update(filter.copyWith(mode: v)),
            ),
            _FilterSpec(
              placeholder: l10n.filterCountry,
              value: filter.country,
              items: _distinct(allSpots.map((s) => s.countryPrefix)),
              onChanged: (v) => update(filter.copyWith(country: v)),
            ),
          ],
        ),
        const Divider(height: 1),
        Expanded(
          child: _SpotListSection(
            spots: spots.whenData((list) => list
                .map((s) => _SpotView(
                      activator: s.activator,
                      mode: s.mode,
                      band: s.band,
                      freqDisplay: s.freqDisplay,
                      refIcon: Icons.eco_outlined,
                      refLine: s.referenceName.isNotEmpty
                          ? '${s.reference}  ${s.referenceName}'
                          : s.reference,
                      comments: s.comments,
                      spotter: s.spotter,
                      time: s.spotTime,
                    ))
                .toList()),
            onRefresh: () => ref.invalidate(wwffSpotsProvider),
            avatarBg: cs.secondaryContainer,
            avatarFg: cs.onSecondaryContainer,
          ),
        ),
      ],
    );
  }
}

class _DxClusterContent extends ConsumerWidget {
  const _DxClusterContent();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final cs = Theme.of(context).colorScheme;
    final spots = ref.watch(filteredDxSpotsProvider);
    final filter = ref.watch(dxSpotFilterProvider);
    final allSpots = ref.watch(dxSpotsProvider).valueOrNull ?? [];

    void update(DxSpotFilter f) =>
        ref.read(dxSpotFilterProvider.notifier).state = f;

    return Column(
      children: [
        _SpotFilterBar(
          newestFirst: filter.newestFirst,
          onToggleSort: () =>
              update(filter.copyWith(newestFirst: !filter.newestFirst)),
          onClearAll: () => update(const DxSpotFilter()),
          filters: [
            _FilterSpec(
              placeholder: l10n.filterBand,
              value: filter.band,
              items: _distinct(allSpots.map((s) => s.band)),
              onChanged: (v) => update(filter.copyWith(band: v)),
            ),
            _FilterSpec(
              placeholder: l10n.filterMode,
              value: filter.mode,
              items: _distinct(allSpots.map((s) => s.mode)),
              onChanged: (v) => update(filter.copyWith(mode: v)),
            ),
          ],
        ),
        const Divider(height: 1),
        Expanded(
          child: _SpotListSection(
            spots: spots.whenData((list) => list
                .map((s) => _SpotView(
                      activator: s.dxCall,
                      mode: s.mode,
                      band: s.band,
                      freqDisplay: s.freqDisplay,
                      comments: s.info,
                      spotter: s.spotter,
                      time: s.time,
                    ))
                .toList()),
            onRefresh: () => ref.invalidate(dxSpotsProvider),
            avatarBg: cs.primaryContainer,
            avatarFg: cs.onPrimaryContainer,
            showErrorDetails: true,
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Add Spot bottom sheet
// ─────────────────────────────────────────────────────────────────────────────

class _SpotData {
  final String activator, spotter, frequency, mode, reference, comments;
  const _SpotData({
    required this.activator,
    required this.spotter,
    required this.frequency,
    required this.mode,
    required this.reference,
    required this.comments,
  });
}

class _AddSpotSheet extends StatefulWidget {
  final ActivityType activity;
  final String defaultCallsign;
  final Future<void> Function(_SpotData) onSubmit;

  const _AddSpotSheet({
    required this.activity,
    required this.defaultCallsign,
    required this.onSubmit,
  });

  @override
  State<_AddSpotSheet> createState() => _AddSpotSheetState();
}

class _AddSpotSheetState extends State<_AddSpotSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _activator;
  late final TextEditingController _spotter;
  final _freq = TextEditingController();
  final _ref = TextEditingController();
  final _comments = TextEditingController();
  String _mode = 'SSB';
  bool _loading = false;
  String? _error;

  // Reference auto-lookup state
  final _pota = PotaDatasource();
  final _sota = SotaDatasource();
  Timer? _debounce;
  String? _refName;
  String? _refLocationDesc;
  bool _refLookupLoading = false;
  bool _refNotFound = false;

  static const _modes = [
    'SSB', 'CW', 'FT8', 'FT4', 'FM', 'AM', 'JS8', 'RTTY', 'PSK31',
  ];

  // POTA: 1-4 uppercase letters, dash, 4-5 digits  (e.g. PL-0001)
  static final _potaRefRegex = RegExp(r'^[A-Z]{1,4}-\d{4,5}$');
  // SOTA: XX/YY-NNN  (e.g. SP/TK-001)
  static final _sotaRefRegex = RegExp(r'^[A-Z]{1,3}/[A-Z]{2,6}-\d{3,4}$');

  @override
  void initState() {
    super.initState();
    _activator = TextEditingController(text: widget.defaultCallsign);
    _spotter = TextEditingController(text: widget.defaultCallsign);
    _ref.addListener(_onRefChanged);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _ref.removeListener(_onRefChanged);
    _activator.dispose();
    _spotter.dispose();
    _freq.dispose();
    _ref.dispose();
    _comments.dispose();
    super.dispose();
  }

  void _onRefChanged() {
    final activity = widget.activity;
    if (activity != ActivityType.pota && activity != ActivityType.sota) return;

    _debounce?.cancel();
    final val = _ref.text.trim().toUpperCase();

    final regex = activity == ActivityType.sota ? _sotaRefRegex : _potaRefRegex;
    if (!regex.hasMatch(val)) {
      if (_refName != null || _refNotFound || _refLookupLoading) {
        setState(() {
          _refName = null;
          _refLocationDesc = null;
          _refNotFound = false;
          _refLookupLoading = false;
        });
      }
      return;
    }

    setState(() {
      _refLookupLoading = true;
      _refName = null;
      _refLocationDesc = null;
      _refNotFound = false;
    });

    _debounce = Timer(const Duration(milliseconds: 600), () async {
      String? name;
      String? locationDesc;
      bool notFound = false;
      try {
        if (activity == ActivityType.sota) {
          final result = await _sota.getSummit(val);
          if (result == null) {
            notFound = true;
          } else {
            name = result.name;
            locationDesc =
                result.regionName.isNotEmpty ? result.regionName : null;
          }
        } else {
          final result = await _pota.getPark(val);
          if (result == null) {
            notFound = true;
          } else {
            name = result.name;
            locationDesc =
                result.locationDesc.isNotEmpty ? result.locationDesc : null;
          }
        }
      } catch (_) {
        // Ağ hatası — "bulunamadı" deme, sadece yüklemeyi bitir
        if (!mounted || _ref.text.trim().toUpperCase() != val) return;
        setState(() => _refLookupLoading = false);
        return;
      }
      // Discard if user already changed the field
      if (!mounted || _ref.text.trim().toUpperCase() != val) return;
      setState(() {
        _refLookupLoading = false;
        _refNotFound = notFound;
        _refName = name;
        _refLocationDesc = locationDesc;
      });
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      await widget.onSubmit(_SpotData(
        activator: _activator.text,
        spotter: _spotter.text,
        frequency: _freq.text,
        mode: _mode,
        reference: _ref.text,
        comments: _comments.text,
      ));
      if (!mounted) return;
      // Messenger'ı pop'tan ÖNCE al — pop sonrası bu context güvenilmez
      final messenger = ScaffoldMessenger.of(context);
      final sentMsg = context.l10n.spotSent;
      Navigator.pop(context);
      messenger.showSnackBar(SnackBar(content: Text(sentMsg)));
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header with activity badge
            Row(
              children: [
                Text(widget.activity.icon,
                    style: const TextStyle(fontSize: 22)),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.spotAdd,
                        style: theme.textTheme.titleMedium),
                    Text(
                      widget.activity.fullName,
                      style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.55)),
                    ),
                  ],
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Activator + Spotter
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _activator,
                    decoration: InputDecoration(
                      labelText: l10n.spotActivator,
                      border: const OutlineInputBorder(),
                    ),
                    textCapitalization: TextCapitalization.characters,
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? l10n.required : null,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    controller: _spotter,
                    decoration: InputDecoration(
                      labelText: l10n.spotSpotter,
                      border: const OutlineInputBorder(),
                    ),
                    textCapitalization: TextCapitalization.characters,
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? l10n.required : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Frequency + Mode
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _freq,
                    decoration: InputDecoration(
                      labelText: l10n.spotFrequency,
                      hintText: '14225',
                      border: const OutlineInputBorder(),
                      suffixText: 'kHz',
                    ),
                    keyboardType: const TextInputType.numberWithOptions(
                        decimal: true),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return l10n.required;
                      if (double.tryParse(v.trim()) == null) {
                        return l10n.invalidNumber;
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    initialValue: _mode,
                    decoration: InputDecoration(
                      labelText: l10n.mode,
                      border: const OutlineInputBorder(),
                    ),
                    items: _modes
                        .map((m) =>
                            DropdownMenuItem(value: m, child: Text(m)))
                        .toList(),
                    onChanged: (v) =>
                        setState(() => _mode = v ?? 'SSB'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Reference (label adapts to activity type)
            TextFormField(
              controller: _ref,
              decoration: InputDecoration(
                labelText: widget.activity.refLabel,
                hintText: widget.activity.refFormat,
                border: const OutlineInputBorder(),
                suffixIcon: _refLookupLoading
                    ? const Padding(
                        padding: EdgeInsets.all(12),
                        child: SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      )
                    : null,
              ),
              textCapitalization: TextCapitalization.characters,
              validator: (v) {
                if (v == null || v.trim().isEmpty) return l10n.required;
                return null;
              },
            ),
            // Reference name preview (POTA park / SOTA summit)
            if (_refName != null || _refNotFound)
              Padding(
                padding: const EdgeInsets.only(top: 6, left: 4),
                child: Row(
                  children: [
                    Icon(
                      _refName != null
                          ? (widget.activity == ActivityType.sota
                              ? Icons.terrain_outlined
                              : Icons.park_outlined)
                          : Icons.error_outline,
                      size: 14,
                      color: _refName != null
                          ? theme.colorScheme.primary
                          : theme.colorScheme.error,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        _refName != null
                            ? [
                                _refName!,
                                if (_refLocationDesc != null) _refLocationDesc!,
                              ].join(' — ')
                            : (widget.activity == ActivityType.sota
                                ? context.l10n.spotSummitNotFound
                                : context.l10n.spotParkNotFound),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: _refName != null
                              ? theme.colorScheme.primary
                              : theme.colorScheme.error,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 12),

            // Comments (optional)
            TextFormField(
              controller: _comments,
              decoration: InputDecoration(
                labelText: l10n.spotComments,
                hintText: l10n.spotCommentsHint,
                border: const OutlineInputBorder(),
              ),
            ),

            if (_error != null) ...[
              const SizedBox(height: 8),
              Text(
                _error!,
                style: TextStyle(
                    color: theme.colorScheme.error, fontSize: 12),
              ),
            ],
            const SizedBox(height: 16),

            FilledButton.icon(
              onPressed: _loading ? null : _submit,
              icon: _loading
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.send),
              label: Text(l10n.spotSend),
            ),
          ],
        ),
      ),
    );
  }
}
