import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Résultat de l'envoi OTP (codeSent).
class OtpSendResult {
  const OtpSendResult({
    required this.verificationId,
    required this.phoneNumber,
    this.resendToken,
  });

  final String verificationId;
  final String phoneNumber;
  final int? resendToken;
}

/// Service d'authentification Firebase Auth.
/// OTP SMS + sessions — responsabilité Jean.
class AuthService {
  AuthService({
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  /// Normalise un numéro béninois vers E.164 (+229…).
  static String normalizeBeninPhone(String raw) {
    var phone = raw.trim().replaceAll(RegExp(r'[\s\-.]'), '');
    if (phone.startsWith('00')) {
      phone = '+${phone.substring(2)}';
    }
    if (phone.startsWith('+')) {
      return phone;
    }
    if (phone.startsWith('229') && phone.length >= 11) {
      return '+$phone';
    }
    if (phone.startsWith('0')) {
      phone = phone.substring(1);
    }
    return '+229$phone';
  }

  /// Envoie le SMS OTP via Firebase (équivalent Android verifyPhoneNumber).
  Future<OtpSendResult> sendOtp(String rawPhone) async {
    final phoneNumber = normalizeBeninPhone(rawPhone);
    await _auth.setLanguageCode('fr');

    final completer = Completer<OtpSendResult>();

    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: const Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential) async {
        // Auto-retrieval / validation instantanée Android.
        try {
          await _auth.signInWithCredential(credential);
          await ensureUserProfile();
          if (!completer.isCompleted) {
            completer.complete(
              OtpSendResult(
                verificationId: credential.verificationId ?? '',
                phoneNumber: phoneNumber,
              ),
            );
          }
        } catch (e) {
          if (!completer.isCompleted) {
            completer.completeError(e);
          }
        }
      },
      verificationFailed: (FirebaseAuthException e) {
        if (!completer.isCompleted) {
          completer.completeError(e);
        }
      },
      codeSent: (String verificationId, int? resendToken) {
        if (!completer.isCompleted) {
          completer.complete(
            OtpSendResult(
              verificationId: verificationId,
              phoneNumber: phoneNumber,
              resendToken: resendToken,
            ),
          );
        }
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        // Conservé pour reprise manuelle si auto-retrieval expire.
        if (!completer.isCompleted) {
          completer.complete(
            OtpSendResult(
              verificationId: verificationId,
              phoneNumber: phoneNumber,
            ),
          );
        }
      },
    );

    return completer.future;
  }

  /// Vérifie le code SMS et connecte l'utilisateur.
  Future<UserCredential> verifyOtp({
    required String verificationId,
    required String smsCode,
  }) async {
    final credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode.trim(),
    );
    final result = await _auth.signInWithCredential(credential);
    await ensureUserProfile();
    return result;
  }

  /// Crée / met à jour users/{uid} selon le cahier des charges.
  Future<void> ensureUserProfile({String type = 'buyer'}) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final ref = _firestore.collection('users').doc(user.uid);
    final snap = await ref.get();

    if (!snap.exists) {
      await ref.set({
        'uid': user.uid,
        'displayName': user.displayName ?? '',
        'phone': user.phoneNumber ?? '',
        'email': user.email ?? '',
        'type': type,
        'createdAt': FieldValue.serverTimestamp(),
        'preferences': <String, dynamic>{},
      });
    } else {
      await ref.set({
        'phone': user.phoneNumber ?? snap.data()?['phone'] ?? '',
        'email': user.email ?? snap.data()?['email'] ?? '',
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    }
  }

  Future<void> signOut() => _auth.signOut();
}
