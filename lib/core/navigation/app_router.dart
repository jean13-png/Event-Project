import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/admin/presentation/screens/admin_dashboard_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/otp_screen.dart';
import '../../features/event_page/presentation/screens/event_page_screen.dart';
import '../../features/explore/presentation/screens/explore_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/notifications/presentation/screens/notifications_screen.dart';
import '../../features/payment/presentation/screens/checkout_screen.dart';
import '../../features/payment/presentation/screens/payment_success_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/tickets/presentation/screens/tickets_screen.dart';
import '../../features/wallet/presentation/screens/wallet_screen.dart';
import '../../features/wallet/presentation/screens/withdraw_screen.dart';
import 'app_route_observer.dart';
import 'main_shell.dart';

abstract final class AppRoutes {
  static const home = '/';
  static const explore = '/explore';
  static const pass = '/pass';
  static const profile = '/profile';
  static const login = '/login';
  static const otp = '/otp';
  static const wallet = '/wallet';
  static const withdraw = '/wallet/withdraw';
  static const notifications = '/notifications';
  static const admin = '/admin';
  static const event = '/events/:eventId';
}

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.home,
  observers: [AppRouteObserver()],
  redirect: (context, state) {
    final adminPaths = {AppRoutes.admin};
    if (adminPaths.contains(state.matchedLocation)) {
      return null;
    }
    return null;
  },
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
              path: AppRoutes.pass,
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
      path: AppRoutes.otp,
      builder: (context, state) => const OtpScreen(),
    ),
    GoRoute(
      path: AppRoutes.wallet,
      builder: (context, state) => const WalletScreen(),
    ),
    GoRoute(
      path: AppRoutes.withdraw,
      builder: (context, state) => const WithdrawScreen(),
    ),
    GoRoute(
      path: AppRoutes.notifications,
      builder: (context, state) => const NotificationsScreen(),
    ),
    GoRoute(
      path: AppRoutes.admin,
      builder: (context, state) => const AdminDashboardScreen(),
    ),
    GoRoute(
      path: '/events/:eventId',
      builder: (context, state) {
        final eventId = state.pathParameters['eventId']!;
        return EventPageScreen(eventId: eventId);
      },
      routes: [
        GoRoute(
          path: 'checkout',
          builder: (context, state) {
            final eventId = state.pathParameters['eventId']!;
            return CheckoutScreen(eventId: eventId);
          },
        ),
        GoRoute(
          path: 'success',
          builder: (context, state) {
            final eventId = state.pathParameters['eventId']!;
            final extra = state.extra as Map<String, dynamic>? ?? {};
            final ticketIds = extra['ticketIds'] as List<dynamic>? ?? const [];
            return PaymentSuccessScreen(
              eventId: eventId,
              buyerName: extra['buyerName'] as String? ?? 'Acheteur',
              ticketName: extra['ticketName'] as String? ?? 'Ticket',
              amountXof: extra['amount'] as int? ?? 0,
              ticketIds: ticketIds.cast<String>(),
            );
          },
        ),
      ],
    ),
  ],
  errorBuilder: (context, state) => Scaffold(
    body: Center(
      child: Text('Page introuvable\n${state.uri}'),
    ),
  ),
);
