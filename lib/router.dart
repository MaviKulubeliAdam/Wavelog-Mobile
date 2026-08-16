import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'core/utils/l10n_extension.dart';
import 'core/utils/maidenhead.dart';
import 'presentation/screens/achievements/achievements_screen.dart';
import 'presentation/screens/antenna/antenna_compass_screen.dart';
import 'providers/pending_sync_provider.dart';
import 'providers/sync_count_provider.dart';
import 'presentation/screens/about/about_screen.dart';
import 'presentation/screens/adif/adif_screen.dart';
import 'presentation/screens/calendar/contest_calendar_screen.dart';
import 'presentation/screens/contest/contest_create_screen.dart';
import 'presentation/screens/contest/contest_log_screen.dart';
import 'presentation/screens/contest/contest_session_list_screen.dart';
import 'presentation/screens/home/home_screen.dart';
import 'data/models/contest_model.dart';
import 'presentation/screens/login/login_screen.dart';
import 'presentation/screens/lookup/callsign_lookup_screen.dart';
import 'presentation/screens/qso/add_qso_screen.dart';
import 'presentation/screens/qso/qso_detail_screen.dart';
import 'presentation/screens/qso/qso_list_screen.dart';
import 'presentation/screens/server_setup/server_setup_screen.dart';
import 'presentation/screens/settings/settings_screen.dart';
import 'presentation/screens/migration/migration_screen.dart';
import 'presentation/screens/setup_guide/setup_guide_screen.dart';
import 'presentation/screens/splash/splash_screen.dart';
import 'data/models/station_logbook_model.dart';
import 'data/models/station_model.dart';
import 'presentation/screens/station/create_station_screen.dart';
import 'presentation/screens/station/station_list_screen.dart';
import 'presentation/screens/station/station_logbook_detail_screen.dart';
import 'presentation/screens/statistics/statistics_screen.dart';
import 'presentation/screens/spot/spot_screen.dart';
import 'presentation/screens/map/map_screen.dart';
import 'providers/settings_provider.dart';

final _rootNavigatorKey  = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

// Accessed by DrawerMenuButton across the app
final shellScaffoldKey = GlobalKey<ScaffoldState>();

final appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/splash',
  routes: [
    GoRoute(path: '/splash',      builder: (c, s) => const SplashScreen()),
    GoRoute(path: '/migration',   builder: (c, s) => const MigrationScreen()),
    GoRoute(path: '/setup-guide', builder: (c, s) => const SetupGuideScreen()),
    GoRoute(path: '/server-setup',builder: (c, s) => const ServerSetupScreen()),
    GoRoute(path: '/login',       builder: (c, s) => const LoginScreen()),

    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) => MainShell(child: child),
      routes: [
        GoRoute(path: '/home',    builder: (c, s) => const HomeScreen()),
        GoRoute(
          path: '/qsos',
          builder: (c, s) => const QsoListScreen(),
          routes: [
            GoRoute(
              path: ':id',
              parentNavigatorKey: _rootNavigatorKey,
              builder: (c, s) => QsoDetailScreen(
                qsoId: Uri.decodeComponent(s.pathParameters['id'] ?? ''),
              ),
            ),
          ],
        ),
        GoRoute(
          path: '/lookup',
          builder: (c, s) {
            final prefill = s.uri.queryParameters['callsign'];
            return CallsignLookupScreen(prefillCallsign: prefill);
          },
        ),
        GoRoute(path: '/stations', builder: (c, s) => const StationListScreen()),
        GoRoute(path: '/stats',    builder: (c, s) => const StatisticsScreen()),
        GoRoute(path: '/spot',     builder: (c, s) => const SpotScreen()),
      ],
    ),

    GoRoute(
      path: '/stations/new',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (c, s) => const CreateStationScreen(),
    ),
    GoRoute(
      path: '/stations/edit',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (c, s) =>
          CreateStationScreen(existingStation: s.extra as StationModel?),
    ),
    GoRoute(
      path: '/stations/logbook/:id',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (c, s) {
        final logbook = s.extra as StationLogbookModel?;
        final id = int.tryParse(s.pathParameters['id'] ?? '') ?? 0;
        return StationLogbookDetailScreen(logbookId: id, initialLogbook: logbook);
      },
    ),
    GoRoute(
      path: '/add-qso',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (c, s) {
        final prefill = s.uri.queryParameters['callsign'];
        return AddQsoScreen(prefillCallsign: prefill);
      },
    ),
    GoRoute(
      path: '/contest',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (c, s) => const ContestSessionListScreen(),
      routes: [
        GoRoute(
          path: 'new',
          parentNavigatorKey: _rootNavigatorKey,
          builder: (c, s) =>
              ContestCreateScreen(editSession: s.extra as ContestSession?),
        ),
        GoRoute(
          path: 'log',
          parentNavigatorKey: _rootNavigatorKey,
          builder: (c, s) =>
              ContestLogScreen(session: s.extra as ContestSession?),
        ),
      ],
    ),
    GoRoute(
      path: '/calendar',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (c, s) => const ContestCalendarScreen(),
    ),
    GoRoute(
      path: '/adif',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (c, s) => const AdifScreen(),
    ),
    GoRoute(
      path: '/settings',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (c, s) => const SettingsScreen(),
    ),
    GoRoute(
      path: '/about',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (c, s) => const AboutScreen(),
    ),
    GoRoute(
      path: '/map',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (c, s) => const MapScreen(),
    ),
    GoRoute(
      path: '/antenna',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (c, s) => const AntennaCompassScreen(),
    ),
    GoRoute(
      path: '/achievements',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (c, s) => const AchievementsScreen(),
    ),
  ],
);

// ── Main Shell ─────────────────────────────────────────────────────────────────

class MainShell extends ConsumerWidget {
  final Widget child;
  const MainShell({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final useModern =
        ref.watch(settingsProvider.select((s) => s.useModernNav));
    return useModern ? _ModernShell(child: child) : _ClassicShell(child: child);
  }
}

// ── Classic Shell (original 6-tab nav) ────────────────────────────────────────

class _ClassicShell extends ConsumerWidget {
  final Widget child;
  const _ClassicShell({required this.child});

  static const _tabPaths = ['/home', '/qsos', '/lookup', '/stations', '/stats', '/spot'];
  static const _tabIcons = [
    Icons.home_outlined, Icons.list_outlined,
    Icons.search_outlined, Icons.cell_tower_outlined,
    Icons.bar_chart_outlined, Icons.wifi_tethering_outlined,
  ];
  static const _tabActiveIcons = [
    Icons.home, Icons.list, Icons.search, Icons.cell_tower,
    Icons.bar_chart, Icons.wifi_tethering,
  ];

  int _indexForLocation(String location) {
    for (var i = 0; i < _tabPaths.length; i++) {
      if (location.startsWith(_tabPaths[i])) return i;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(autoSyncProvider);
    final l10n = context.l10n;
    final location = GoRouterState.of(context).matchedLocation;
    final currentIndex = _indexForLocation(location);
    final labels = [
      l10n.navHome, l10n.navLogbook, l10n.navLookup,
      l10n.navStation, l10n.navStats, l10n.navSpot,
    ];

    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        onDestinationSelected: (i) => context.go(_tabPaths[i]),
        destinations: List.generate(
          _tabPaths.length,
          (i) => NavigationDestination(
            icon: Icon(_tabIcons[i]),
            selectedIcon: Icon(_tabActiveIcons[i]),
            label: labels[i],
          ),
        ),
      ),
    );
  }
}

// ── QSO type picker — shared by FAB ──────────────────────────────────────────

void _showQsoTypeSheet(BuildContext context) {
  final l10n = context.l10n;
  showModalBottomSheet<void>(
    context: context,
    builder: (ctx) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
              child: Text(l10n.qsoTypeTitle,
                  style: Theme.of(ctx).textTheme.titleMedium),
            ),
            ListTile(
              leading: const CircleAvatar(child: Icon(Icons.radio)),
              title: Text(l10n.normalQso),
              subtitle: Text(l10n.normalQsoDesc),
              onTap: () {
                Navigator.of(ctx).pop();
                context.push('/add-qso');
              },
            ),
            ListTile(
              leading: const CircleAvatar(child: Icon(Icons.emoji_events)),
              title: Text(l10n.contestQso),
              subtitle: Text(l10n.contestQsoDesc),
              onTap: () {
                Navigator.of(ctx).pop();
                context.push('/contest');
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    ),
  );
}

// ── Modern Shell (4-tab + FAB + Drawer) ──────────────────────────────────────

class _ModernShell extends StatelessWidget {
  final Widget child;
  const _ModernShell({required this.child});

  static const _tabPaths = ['/home', '/qsos', '/spot', '/lookup'];

  int _indexForLocation(String location) {
    for (var i = 0; i < _tabPaths.length; i++) {
      if (location.startsWith(_tabPaths[i])) return i;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final location = GoRouterState.of(context).matchedLocation;
    final currentIndex = _indexForLocation(location);

    return Scaffold(
      key: shellScaffoldKey,
      drawer: _AppDrawer(),
      body: child,
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showQsoTypeSheet(context),
        tooltip: l10n.addQso,
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        child: Row(
          children: [
            _BottomItem(
              icon: Icons.home_outlined,
              activeIcon: Icons.home,
              label: l10n.navHome,
              selected: currentIndex == 0,
              onTap: () => context.go('/home'),
            ),
            _BottomItem(
              icon: Icons.list_outlined,
              activeIcon: Icons.list,
              label: l10n.navLogbook,
              selected: currentIndex == 1,
              onTap: () => context.go('/qsos'),
            ),
            const Spacer(),
            _BottomItem(
              icon: Icons.wifi_tethering_outlined,
              activeIcon: Icons.wifi_tethering,
              label: l10n.navSpot,
              selected: currentIndex == 2,
              onTap: () => context.go('/spot'),
            ),
            _BottomItem(
              icon: Icons.search_outlined,
              activeIcon: Icons.search,
              label: l10n.navLookup,
              selected: currentIndex == 3,
              onTap: () => context.go('/lookup'),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Bottom nav item for modern shell ─────────────────────────────────────────

class _BottomItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _BottomItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final color = selected ? cs.primary : cs.onSurfaceVariant;
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(selected ? activeIcon : icon, color: color, size: 22),
              const SizedBox(height: 2),
              Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Navigation Drawer ─────────────────────────────────────────────────────────

class _AppDrawer extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final cs = Theme.of(context).colorScheme;
    final l10n = context.l10n;
    final pendingCount = ref.watch(pendingSyncCountProvider);
    ref.watch(autoSyncProvider);

    void go(String path) {
      Navigator.of(context).pop();
      context.push(path);
    }

    return Drawer(
      child: Column(
        children: [
          // ── Header ─────────────────────────────────────────────────────
          DrawerHeader(
            decoration: BoxDecoration(color: cs.primaryContainer),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 22,
                      backgroundColor: cs.primary,
                      child: Icon(Icons.radio, color: cs.onPrimary, size: 22),
                    ),
                    const Spacer(),
                    if (pendingCount > 0)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: cs.error.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              color: cs.error.withValues(alpha: 0.4)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.cloud_off, size: 12, color: cs.error),
                            const SizedBox(width: 4),
                            Text(
                              '$pendingCount',
                              style: TextStyle(
                                  fontSize: 11,
                                  color: cs.error,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  settings.activeStationCallsign ?? 'Wavelog Mobile',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: cs.onPrimaryContainer,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                if (settings.activeStationName != null)
                  Text(
                    settings.activeStationName!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: cs.onPrimaryContainer.withValues(alpha: 0.75),
                        ),
                  ),
                const SizedBox(height: 8),
                const _DrawerHeaderInfo(),
              ],
            ),
          ),

          // ── Nav items ──────────────────────────────────────────────────
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _DrawerItem(
                  icon: Icons.bar_chart_outlined,
                  label: l10n.navStats,
                  onTap: () => go('/stats'),
                ),
                _DrawerItem(
                  icon: Icons.cell_tower_outlined,
                  label: l10n.navStation,
                  onTap: () => go('/stations'),
                ),
                _DrawerItem(
                  icon: Icons.map_outlined,
                  label: l10n.drawerMap,
                  onTap: () => go('/map'),
                ),
                _DrawerItem(
                  icon: Icons.explore_outlined,
                  label: l10n.drawerAntenna,
                  onTap: () => go('/antenna'),
                ),
                _DrawerItem(
                  icon: Icons.military_tech_outlined,
                  label: l10n.drawerAchievements,
                  onTap: () => go('/achievements'),
                ),
                const Divider(indent: 16, endIndent: 16),
                _DrawerItem(
                  icon: Icons.calendar_month_outlined,
                  label: l10n.drawerContestCalendar,
                  onTap: () => go('/calendar'),
                ),
                _DrawerItem(
                  icon: Icons.emoji_events_outlined,
                  label: l10n.drawerContestSessions,
                  onTap: () => go('/contest'),
                ),
                _DrawerItem(
                  icon: Icons.import_export,
                  label: l10n.drawerAdif,
                  onTap: () => go('/adif'),
                ),
                const Divider(indent: 16, endIndent: 16),
                _DrawerItem(
                  icon: Icons.settings_outlined,
                  label: l10n.settingsTitle,
                  onTap: () => go('/settings'),
                ),
                _DrawerItem(
                  icon: Icons.info_outline,
                  label: l10n.aboutTitle,
                  onTap: () => go('/about'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Drawer header info (UTC clock + GPS grid) ────────────────────────────────

class _DrawerHeaderInfo extends StatefulWidget {
  const _DrawerHeaderInfo();

  @override
  State<_DrawerHeaderInfo> createState() => _DrawerHeaderInfoState();
}

class _DrawerHeaderInfoState extends State<_DrawerHeaderInfo> {
  late Timer _timer;
  String _utcTime = '';
  String? _grid;

  @override
  void initState() {
    super.initState();
    _tick();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
    _fetchGrid();
  }

  void _tick() {
    final now = DateTime.now().toUtc();
    final hh = now.hour.toString().padLeft(2, '0');
    final mm = now.minute.toString().padLeft(2, '0');
    final ss = now.second.toString().padLeft(2, '0');
    if (mounted) setState(() => _utcTime = '$hh:$mm:$ss');
  }

  Future<void> _fetchGrid() async {
    try {
      var perm = await Geolocator.checkPermission();
      if (perm == LocationPermission.denied) {
        perm = await Geolocator.requestPermission();
      }
      if (perm == LocationPermission.denied ||
          perm == LocationPermission.deniedForever) {
        return;
      }
      final pos = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.medium);
      final grid = latLngToGrid(pos.latitude, pos.longitude);
      if (mounted && grid != null) { setState(() => _grid = grid); }
    } catch (_) {}
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textColor =
        Theme.of(context).colorScheme.onPrimaryContainer.withValues(alpha: 0.8);
    final style = TextStyle(fontSize: 11, color: textColor, letterSpacing: 0.3);
    return Row(
      children: [
        Icon(Icons.access_time_outlined, size: 12, color: textColor),
        const SizedBox(width: 4),
        Text('$_utcTime UTC', style: style),
        if (_grid != null) ...[
          const SizedBox(width: 10),
          Icon(Icons.grid_on_outlined, size: 12, color: textColor),
          const SizedBox(width: 4),
          Text(_grid!, style: style),
        ],
      ],
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _DrawerItem({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return ListTile(
      leading: Icon(icon, color: cs.onSurfaceVariant, size: 22),
      title: Text(label),
      dense: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
      onTap: onTap,
    );
  }
}

// ── Drawer menu button — used by main tab screens' AppBars ───────────────────

class DrawerMenuButton extends ConsumerWidget {
  const DrawerMenuButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final useModern = ref.watch(settingsProvider.select((s) => s.useModernNav));
    if (!useModern) return const SizedBox.shrink();
    return IconButton(
      icon: const Icon(Icons.menu),
      tooltip: context.l10n.drawerMenu,
      onPressed: () => shellScaffoldKey.currentState?.openDrawer(),
    );
  }
}
