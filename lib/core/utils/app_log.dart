import 'package:flutter/foundation.dart';

/// Logs visibles dans le terminal `flutter run`.
abstract final class AppLog {
  static void info(String message) {
    debugPrint('[EventBJ] $message');
  }

  static void error(String message, [Object? error, StackTrace? stack]) {
    debugPrint('[EventBJ][ERROR] $message');
    if (error != null) {
      debugPrint('[EventBJ][ERROR] → $error');
    }
    if (stack != null) {
      debugPrint('[EventBJ][ERROR] stack:\n$stack');
    }
  }
}
