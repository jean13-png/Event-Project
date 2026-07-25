import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/services/notification_service.dart';

final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService();
});

final userNotificationsProvider =
    StreamProvider<List<AppNotification>>((ref) {
  final uid = FirebaseAuth.instance.currentUser?.uid;
  if (uid == null) {
    return Stream.value(const <AppNotification>[]);
  }
  return ref.watch(notificationServiceProvider).watchUserNotifications(uid);
});
