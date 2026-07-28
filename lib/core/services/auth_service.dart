import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../firebase/google_oauth_config.dart';
import '../utils/app_log.dart';

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
    AppLog.info('GoogleSignIn.initialize (serverClientId web)');
    await GoogleSignIn.instance.initialize(
      serverClientId: GoogleOAuthConfig.webClientId,
    );
    _googleInitialized = true;
    AppLog.info('GoogleSignIn prêt');
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
    AppLog.info('OTP send → $phoneNumber (brut: $rawPhone)');
    await _auth.setLanguageCode('fr');

    final completer = Completer<OtpSendResult>();

    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: const Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential) async {
        AppLog.info('OTP verificationCompleted (auto)');
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
        } catch (e, st) {
          AppLog.error('OTP auto sign-in échoué', e, st);
          if (!completer.isCompleted) {
            completer.completeError(e, st);
          }
        }
      },
      verificationFailed: (FirebaseAuthException e) {
        AppLog.error(
          'OTP verificationFailed code=${e.code} message=${e.message}',
          e,
        );
        if (!completer.isCompleted) {
          completer.completeError(e);
        }
      },
      codeSent: (String verificationId, int? resendToken) {
        AppLog.info('OTP codeSent verificationId=$verificationId');
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
        AppLog.info('OTP autoRetrievalTimeout id=$verificationId');
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
    AppLog.info('OTP verify code (len=${smsCode.length})');
    final credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode.trim(),
    );
    final result = await _auth.signInWithCredential(credential);
    AppLog.info('OTP sign-in OK uid=${result.user?.uid}');
    await ensureUserProfile();
    return result;
  }

  /// Connexion Google → Firebase Auth.
  /// Retourne null si l'utilisateur annule.
  Future<UserCredential?> signInWithGoogle() async {
    AppLog.info('Google Sign-In démarré');
    if (kIsWeb) {
      final provider = GoogleAuthProvider();
      final result = await _auth.signInWithPopup(provider);
      await ensureUserProfile();
      return result;
    }

    await initializeGoogleSignIn();

    try {
      final googleUser = await GoogleSignIn.instance.authenticate();
      AppLog.info('Google account: ${googleUser.email}');
      final idToken = googleUser.authentication.idToken;
      if (idToken == null) {
        AppLog.error('Google idToken null — SHA / serverClientId ?');
        throw FirebaseAuthException(
          code: 'missing-id-token',
          message:
              'Google n’a pas renvoyé d’idToken. Vérifie le serverClientId / SHA.',
        );
      }

      final credential = GoogleAuthProvider.credential(idToken: idToken);
      final result = await _auth.signInWithCredential(credential);
      AppLog.info('Firebase Google OK uid=${result.user?.uid}');
      await ensureUserProfile();
      return result;
    } on GoogleSignInException catch (e, st) {
      AppLog.error(
        'GoogleSignInException code=${e.code} description=${e.description}',
        e,
        st,
      );
      if (e.code == GoogleSignInExceptionCode.canceled) {
        AppLog.info('Google Sign-In annulé par l’utilisateur');
        return null;
      }
      rethrow;
    } catch (e, st) {
      AppLog.error('Google Sign-In échec', e, st);
      rethrow;
    }
  }

  /// Crée / met à jour users/{uid}.
  /// Ne fait PAS échouer la connexion si Firestore n’est pas prêt.
  Future<void> ensureUserProfile({String type = 'buyer'}) async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
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
          'type': type,
          'updatedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      }
    } catch (e, st) {
      AppLog.error('Firestore profil échoué', e, st);
    }
  }

  Future<void> setUserType(String type) async {
    final user = _auth.currentUser;
    if (user == null) return;
    await _firestore.collection('users').doc(user.uid).set({'type': type}, SetOptions(merge: true));
  }

  Future<String?> getUserType() async {
    final user = _auth.currentUser;
    if (user == null) return null;
    final snap = await _firestore.collection('users').doc(user.uid).get();
    return snap.data()?['type'] as String?;
  }

  Future<void> signOut() async {
    AppLog.info('Sign out');
    if (!kIsWeb && _googleInitialized) {
      await GoogleSignIn.instance.signOut();
    }
    await _auth.signOut();
  }
}
