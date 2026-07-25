import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

import '../utils/app_log.dart';

class AppNotification {
  const AppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.createdAt,
    this.read = false,
  });

  final String id;
  final String title;
  final String body;
  final DateTime createdAt;
  final bool read;
}

/// Push FCM + stockage notifications utilisateur.
class NotificationService {
  NotificationService({
    FirebaseMessaging? messaging,
    FirebaseFirestore? firestore,
  })  : _messaging = messaging ?? FirebaseMessaging.instance,
        _db = firestore ?? FirebaseFirestore.instance;

  final FirebaseMessaging _messaging;
  final FirebaseFirestore _db;

  Future<void> init() async {
    if (kIsWeb) {
      AppLog.info('FCM: skip init web (config VAPID plus tard)');
      return;
    }
    try {
      final settings = await _messaging.requestPermission();
      AppLog.info('FCM permission=${settings.authorizationStatus}');
      final token = await _messaging.getToken();
      AppLog.info('FCM token=${token?.substring(0, 12)}…');
      await _saveToken(token);

      FirebaseMessaging.onMessage.listen((message) {
        AppLog.info(
          'FCM foreground: ${message.notification?.title}',
        );
      });
    } catch (e, st) {
      AppLog.error('FCM init échoué', e, st);
    }
  }

  Future<void> _saveToken(String? token) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null || token == null) return;
    await _db.collection('users').doc(uid).set({
      'fcmTokens': FieldValue.arrayUnion([token]),
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Stream<List<AppNotification>> watchUserNotifications(String userId) {
    return _db
        .collection('users')
        .doc(userId)
        .collection('notifications')
        .orderBy('createdAt', descending: true)
        .limit(50)
        .snapshots()
        .map(
          (snap) => snap.docs.map((doc) {
            final data = doc.data();
            final createdAt = data['createdAt'];
            return AppNotification(
              id: doc.id,
              title: data['title'] as String? ?? '',
              body: data['body'] as String? ?? '',
              createdAt:
                  createdAt is Timestamp ? createdAt.toDate() : DateTime.now(),
              read: data['read'] as bool? ?? false,
            );
          }).toList(),
        );
  }

  Future<void> seedDemoNotification(String userId) async {
    await _db.collection('users').doc(userId).collection('notifications').add({
      'title': 'Bienvenue sur EventBJ',
      'body': 'Tes alertes de ventes et rappels apparaîtront ici.',
      'read': false,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}
