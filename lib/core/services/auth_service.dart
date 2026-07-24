import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../firebase/google_oauth_config.dart';

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
/// OTP SMS, Google Sign-In, sessions — responsabilité Jean.
class AuthService {
  AuthService({
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  static var _googleInitialized = false;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  /// À appeler une fois après Firebase.initializeApp (google_sign_in 7+).
  static Future<void> initializeGoogleSignIn() async {
    if (_googleInitialized || kIsWeb) return;
    await GoogleSignIn.instance.initialize(
      serverClientId: GoogleOAuthConfig.webClientId,
    );
    _googleInitialized = true;
  }

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

  /// Envoie le SMS OTP via Firebase.
  Future<OtpSendResult> sendOtp(String rawPhone) async {
    final phoneNumber = normalizeBeninPhone(rawPhone);
    await _auth.setLanguageCode('fr');

    final completer = Completer<OtpSendResult>();

    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: const Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential) async {
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

  /// Connexion Google → Firebase Auth.
  /// Retourne null si l'utilisateur annule.
  Future<UserCredential?> signInWithGoogle() async {
    if (kIsWeb) {
      final provider = GoogleAuthProvider();
      final result = await _auth.signInWithPopup(provider);
      await ensureUserProfile();
      return result;
    }

    await initializeGoogleSignIn();

    try {
      final googleUser = await GoogleSignIn.instance.authenticate();
      final idToken = googleUser.authentication.idToken;
      if (idToken == null) {
        throw FirebaseAuthException(
          code: 'missing-id-token',
          message:
              'Google n’a pas renvoyé d’idToken. Vérifie le serverClientId.',
        );
      }

      final credential = GoogleAuthProvider.credential(idToken: idToken);
      final result = await _auth.signInWithCredential(credential);
      await ensureUserProfile();
      return result;
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) {
        return null;
      }
      rethrow;
    }
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
        'displayName': user.displayName ?? snap.data()?['displayName'] ?? '',
        'phone': user.phoneNumber ?? snap.data()?['phone'] ?? '',
        'email': user.email ?? snap.data()?['email'] ?? '',
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    }
  }

  Future<void> signOut() async {
    if (!kIsWeb && _googleInitialized) {
      await GoogleSignIn.instance.signOut();
    }
    await _auth.signOut();
  }
}
