import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/services/auth_service.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

final authStateProvider = StreamProvider<User?>((ref) {
  return ref.watch(authServiceProvider).authStateChanges;
});

/// Session OTP en cours (après envoi du SMS).
class OtpSession {
  const OtpSession({
    required this.verificationId,
    required this.phoneNumber,
    this.resendToken,
  });

  final String verificationId;
  final String phoneNumber;
  final int? resendToken;
}

class AuthController extends Notifier<AsyncValue<OtpSession?>> {
  @override
  AsyncValue<OtpSession?> build() => const AsyncData(null);

  AuthService get _auth => ref.read(authServiceProvider);

  Future<bool> sendOtp(String phone) async {
    state = const AsyncLoading();
    try {
      final result = await _auth.sendOtp(phone);
      // Si déjà connecté via auto-verification, pas besoin d'écran OTP.
      if (_auth.currentUser != null) {
        state = const AsyncData(null);
        return true;
      }
      state = AsyncData(
        OtpSession(
          verificationId: result.verificationId,
          phoneNumber: result.phoneNumber,
          resendToken: result.resendToken,
        ),
      );
      return false;
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }

  Future<void> verifyOtp(String smsCode) async {
    final session = state.value;
    if (session == null || session.verificationId.isEmpty) {
      throw StateError('Aucune session OTP active. Renvoie un code.');
    }
    state = const AsyncLoading();
    try {
      await _auth.verifyOtp(
        verificationId: session.verificationId,
        smsCode: smsCode,
      );
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }

  /// Retourne false si l'utilisateur annule le sélecteur Google.
  Future<bool> signInWithGoogle() async {
    state = const AsyncLoading();
    try {
      final result = await _auth.signInWithGoogle();
      state = const AsyncData(null);
      return result != null;
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    state = const AsyncData(null);
  }
}

final authControllerProvider =
    NotifierProvider<AuthController, AsyncValue<OtpSession?>>(
  AuthController.new,
);
