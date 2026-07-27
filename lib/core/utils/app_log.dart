import 'package:flutter/foundation.dart';

/// Logs visibles dans le terminal `flutter run`.
abstract final class AppLog {
  static void info(String message) {
    debugPrint('[MyMood] $message');
  }

  static void error(String message, [Object? error, StackTrace? stack]) {
    debugPrint('[MyMood][ERROR] $message');
    if (error != null) {
      debugPrint('[MyMood][ERROR] → $error');
    }
    if (stack != null) {
      debugPrint('[MyMood][ERROR] stack:\n$stack');
    }
  }
}
