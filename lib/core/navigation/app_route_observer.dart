import 'package:flutter/material.dart';

import '../utils/app_log.dart';

/// Logue chaque navigation dans le terminal `flutter run`.
class AppRouteObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    AppLog.info('NAV push → ${route.settings.name ?? route.settings}');
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    AppLog.info('NAV pop ← ${route.settings.name ?? route.settings}');
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    AppLog.info(
      'NAV replace ${oldRoute?.settings.name} → ${newRoute?.settings.name}',
    );
  }
}
