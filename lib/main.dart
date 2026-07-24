import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app.dart';
import 'core/firebase/firebase_options.dart';
import 'core/services/auth_service.dart';
import 'core/theme/app_colors.dart';
import 'core/utils/app_log.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FlutterError.onError = (details) {
    AppLog.error('FlutterError', details.exception, details.stack);
    FlutterError.presentError(details);
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    AppLog.error('PlatformError', error, stack);
    return true;
  };

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: AppColors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  AppLog.info('Démarrage EventBJ…');
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  AppLog.info('Firebase initialisé (${DefaultFirebaseOptions.currentPlatform.projectId})');
  await AuthService.initializeGoogleSignIn();

  runApp(const EventBjRoot());
  AppLog.info('App lancée — les logs [EventBJ] apparaissent ici');
}
