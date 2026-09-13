import 'package:flutter/material.dart';

import '../../../core/utils/l10n_extension.dart';

class ApiScopeGuideScreen extends StatelessWidget {
  const ApiScopeGuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final cs = Theme.of(context).colorScheme;

    final groups = [
      _ScopeGroup(
        label: 'QSO',
        icon: Icons.swap_vert_outlined,
        color: Colors.blue,
        scopes: [
          ('qso:read', l10n.scopeQsoRead),
          ('qso:write', l10n.scopeQsoWrite),
          ('qso:delete', l10n.scopeQsoDelete),
        ],
      ),
      _ScopeGroup(
        label: l10n.scopeTestLogbook,
        icon: Icons.menu_book_outlined,
        color: Colors.teal,
        scopes: [
          ('logbook:read', l10n.scopeLogbookRead),
          ('logbook:write', l10n.scopeLogbookWrite),
          ('logbook:delete', l10n.scopeLogbookDelete),
        ],
      ),
      _ScopeGroup(
        label: l10n.scopeTestStation,
        icon: Icons.cell_tower_outlined,
        color: Colors.orange,
        scopes: [
          ('station:read', l10n.scopeStationRead),
          ('station:write', l10n.scopeStationWrite),
          ('station:delete', l10n.scopeStationDelete),
        ],
      ),
      _ScopeGroup(
        label: l10n.scopeTestContest,
        icon: Icons.emoji_events_outlined,
        color: Colors.purple,
        scopes: [
          ('contest:read', l10n.scopeContestRead),
          ('contest:write', l10n.scopeContestWrite),
          ('contest:delete', l10n.scopeContestDelete),
        ],
      ),
      _ScopeGroup(
        label: l10n.scopeTestConfirmation,
        icon: Icons.verified_outlined,
        color: Colors.green,
        scopes: [
          ('confirmation:read', l10n.scopeConfirmationRead),
        ],
      ),
      _ScopeGroup(
        label: l10n.scopeTestStatistics,
        icon: Icons.bar_chart_outlined,
        color: Colors.indigo,
        scopes: [
          ('statistic:read', l10n.scopeStatisticsRead),
        ],
      ),
      _ScopeGroup(
        label: l10n.scopeTestLookup,
        icon: Icons.search_outlined,
        color: Colors.cyan,
        scopes: [
          ('lookup:read', l10n.scopeLookupRead),
        ],
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: Text(l10n.apiScopeGuideTitle)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        children: [
          Card(
            color: cs.primaryContainer,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.info_outline, color: cs.onPrimaryContainer, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      l10n.apiScopeGuideIntro,
                      style: TextStyle(
                        color: cs.onPrimaryContainer,
                        fontSize: 13,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          ...groups.map((g) => _ScopeGroupCard(group: g)),
        ],
      ),
    );
  }
}

class _ScopeGroup {
  final String label;
  final IconData icon;
  final Color color;
  final List<(String, String)> scopes;
  const _ScopeGroup({
    required this.label,
    required this.icon,
    required this.color,
    required this.scopes,
  });
}

class _ScopeGroupCard extends StatelessWidget {
  final _ScopeGroup group;
  const _ScopeGroupCard({required this.group});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: group.color.withAlpha(30),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(group.icon, size: 18, color: group.color),
                ),
                const SizedBox(width: 10),
                Text(
                  group.label,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ...group.scopes.map((s) => _ScopeRow(scope: s.$1, desc: s.$2)),
          ],
        ),
      ),
    );
  }
}

class _ScopeRow extends StatelessWidget {
  final String scope;
  final String desc;
  const _ScopeRow({required this.scope, required this.desc});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check_circle_rounded, size: 16, color: Colors.green.shade600),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                  decoration: BoxDecoration(
                    color: cs.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    scope,
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: cs.onSurfaceVariant,
                    ),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  desc,
                  style: TextStyle(
                    fontSize: 12,
                    color: cs.onSurfaceVariant,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
