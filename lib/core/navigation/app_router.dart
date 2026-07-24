import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/event_page/presentation/screens/event_page_screen.dart';
import '../../features/explore/presentation/screens/explore_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/map/presentation/screens/map_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/tickets/presentation/screens/tickets_screen.dart';
import '../../features/wallet/presentation/screens/wallet_screen.dart';
import 'main_shell.dart';

abstract final class AppRoutes {
  static const home = '/';
  static const explore = '/explore';
  static const map = '/map';
  static const tickets = '/tickets';
  static const profile = '/profile';
  static const login = '/login';
  static const wallet = '/wallet';
  static const event = '/events/:eventId';
}

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.home,
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return MainShell(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.home,
              builder: (context, state) => const HomeScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.explore,
              builder: (context, state) => const ExploreScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.map,
              builder: (context, state) => const MapScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.tickets,
              builder: (context, state) => const TicketsScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.profile,
              builder: (context, state) => const ProfileScreen(),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: AppRoutes.login,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: AppRoutes.wallet,
      builder: (context, state) => const WalletScreen(),
    ),
    GoRoute(
      path: '/events/:eventId',
      builder: (context, state) {
        final eventId = state.pathParameters['eventId']!;
        return EventPageScreen(eventId: eventId);
      },
    ),
  ],
  errorBuilder: (context, state) => Scaffold(
    body: Center(
      child: Text('Page introuvable\n${state.uri}'),
    ),
  ),
);

/// Icônes Tabler pour la bottom nav (DESIGN.md).
abstract final class NavIcons {
  static const home = TablerIcons.home;
  static const explore = TablerIcons.search;
  static const map = TablerIcons.map_pin;
  static const tickets = TablerIcons.ticket;
  static const profile = TablerIcons.user_circle;
}
