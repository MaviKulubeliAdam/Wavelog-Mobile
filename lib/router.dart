import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'core/utils/l10n_extension.dart';
import 'presentation/screens/about/about_screen.dart';
import 'presentation/screens/adif/adif_screen.dart';
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

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/setup-guide',
      builder: (context, state) => const SetupGuideScreen(),
    ),
    GoRoute(
      path: '/server-setup',
      builder: (context, state) => const ServerSetupScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) => MainShell(child: child),
      routes: [
        GoRoute(
          path: '/home',
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: '/qsos',
          builder: (context, state) => const QsoListScreen(),
          routes: [
            GoRoute(
              path: ':id',
              parentNavigatorKey: _rootNavigatorKey,
              builder: (context, state) => QsoDetailScreen(
                qsoId: Uri.decodeComponent(state.pathParameters['id'] ?? ''),
              ),
            ),
          ],
        ),
        GoRoute(
          path: '/lookup',
          builder: (context, state) {
            final prefill = state.uri.queryParameters['callsign'];
            return CallsignLookupScreen(prefillCallsign: prefill);
          },
        ),
        GoRoute(
          path: '/stations',
          builder: (context, state) => const StationListScreen(),
        ),
        GoRoute(
          path: '/stats',
          builder: (context, state) => const StatisticsScreen(),
        ),
        GoRoute(
          path: '/spot',
          builder: (context, state) => const SpotScreen(),
        ),
      ],
    ),
    GoRoute(
      path: '/stations/new',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const CreateStationScreen(),
    ),
    GoRoute(
      path: '/stations/edit',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) =>
          CreateStationScreen(existingStation: state.extra as StationModel?),
    ),
    GoRoute(
      path: '/stations/logbook/:id',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final logbook = state.extra as StationLogbookModel?;
        final id = int.tryParse(state.pathParameters['id'] ?? '') ?? 0;
        return StationLogbookDetailScreen(logbookId: id, initialLogbook: logbook);
      },
    ),
    GoRoute(
      path: '/add-qso',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final prefill = state.uri.queryParameters['callsign'];
        return AddQsoScreen(prefillCallsign: prefill);
      },
    ),
    GoRoute(
      path: '/contest',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const ContestSessionListScreen(),
      routes: [
        GoRoute(
          path: 'new',
          parentNavigatorKey: _rootNavigatorKey,
          builder: (context, state) =>
              ContestCreateScreen(editSession: state.extra as ContestSession?),
        ),
        GoRoute(
          path: 'log',
          parentNavigatorKey: _rootNavigatorKey,
          builder: (context, state) =>
              ContestLogScreen(session: state.extra as ContestSession?),
        ),
      ],
    ),
    GoRoute(
      path: '/adif',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const AdifScreen(),
    ),
    GoRoute(
      path: '/settings',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const SettingsScreen(),
    ),
    GoRoute(
      path: '/about',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const AboutScreen(),
    ),
    GoRoute(
      path: '/map',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const MapScreen(),
    ),
  ],
);

class MainShell extends StatelessWidget {
  final Widget child;
  const MainShell({super.key, required this.child});

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
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final location = GoRouterState.of(context).matchedLocation;
    final currentIndex = _indexForLocation(location);

    final labels = [l10n.navHome, l10n.navLogbook, l10n.navLookup, l10n.navStation, l10n.navStats, l10n.navSpot];

    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        onDestinationSelected: (index) => context.go(_tabPaths[index]),
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
