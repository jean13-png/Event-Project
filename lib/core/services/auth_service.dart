/// Service d'authentification Firebase Auth.
/// OTP SMS, Google Sign-In, sessions — responsabilité Jean.
///
/// Firebase sera branché après `flutterfire configure`.
class AuthService {
  Future<void> sendOtp(String phoneNumber) async {
    throw UnimplementedError('À brancher sur Firebase Auth (OTP SMS)');
  }

  Future<void> verifyOtp({
    required String verificationId,
    required String smsCode,
  }) async {
    throw UnimplementedError('À brancher sur Firebase Auth (vérification OTP)');
  }

  Future<void> signInWithGoogle() async {
    throw UnimplementedError('À brancher sur Google Sign-In + Firebase Auth');
  }

  Future<void> signOut() async {
    throw UnimplementedError('À brancher sur Firebase Auth');
  }
}
