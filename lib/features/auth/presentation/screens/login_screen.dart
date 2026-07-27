import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../../core/navigation/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/app_log.dart';
import '../../../../core/widgets/design_system.dart';
import '../providers/auth_providers.dart';

/// Connexion OTP SMS / Google — responsabilité Jean.
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _phoneController = TextEditingController();
  var _submitting = false;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _sendOtp() async {
    final phone = _phoneController.text.trim();
    if (phone.isEmpty) {
      _showMessage('Entre ton numéro de téléphone.');
      return;
    }

    AppLog.info('UI: bouton OTP pressé → $phone');
    setState(() => _submitting = true);
    try {
      final alreadySignedIn =
          await ref.read(authControllerProvider.notifier).sendOtp(phone);
      if (!mounted) return;
      if (alreadySignedIn) {
        _showMessage('Connexion réussie.');
        context.go(AppRoutes.home);
      } else {
        context.push(AppRoutes.otp);
      }
    } catch (e, st) {
      AppLog.error('UI OTP erreur', e, st);
      _showMessage(_formatError(e));
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  Future<void> _signInWithGoogle() async {
    AppLog.info('UI: bouton Google pressé');
    setState(() => _submitting = true);
    try {
      final signedIn =
          await ref.read(authControllerProvider.notifier).signInWithGoogle();
      if (!mounted) return;
      if (signedIn) {
        _showMessage('Connexion Google réussie.');
        context.go(AppRoutes.home);
      } else {
        AppLog.info('UI: Google annulé');
      }
    } catch (e, st) {
      AppLog.error('UI Google erreur', e, st);
      _showMessage(_formatError(e));
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  String _formatError(Object e) {
    if (e is FirebaseAuthException) {
      return _mapAuthError(e);
    }
    if (e is GoogleSignInException) {
      return 'Google (${e.code.name}): ${e.description ?? e.toString()}';
    }
    final text = e.toString();
    if (text.length > 160) {
      return '${text.substring(0, 160)}…';
    }
    return text;
  }

  String _mapAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-phone-number':
        return 'Numéro invalide. Utilise +229…';
      case 'too-many-requests':
        return 'Trop de tentatives. Réessaie plus tard.';
      case 'quota-exceeded':
        return 'Quota SMS dépassé. Utilise un numéro de test Firebase.';
      case 'missing-client-identifier':
      case 'app-not-authorized':
        return 'SHA / package incorrect dans Firebase (SHA-1/256).';
      case 'account-exists-with-different-credential':
        return 'Ce compte existe déjà avec une autre méthode.';
      case 'missing-id-token':
        return 'Config Google incomplète (serverClientId / SHA).';
      case 'network-request-failed':
        return 'Réseau indisponible. Vérifie ta connexion.';
      case 'captcha-check-failed':
      case 'web-context-cancelled':
        return 'Vérification reCAPTCHA échouée / annulée.';
      default:
        return 'Auth [${e.code}] ${e.message ?? ''}'.trim();
    }
  }

  void _showMessage(String message) {
    AppLog.info('UI snackbar: $message');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 6),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.sand,
      appBar: AppBar(
        title: const Text('Connexion'),
        leading: IconButton(
          icon: const Icon(TablerIcons.arrow_left, size: 20),
          onPressed: () => context.pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const MyMoodLogo(onDark: false, iconSize: 32),
            const SizedBox(height: 12),
            Text(
              'Tu recevras un code SMS. Les tarifs standards s’appliquent.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 32),
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              enabled: !_submitting,
              decoration: const InputDecoration(
                hintText: 'Numéro (ex. +22901…)',
                prefixIcon: Icon(TablerIcons.phone, size: 18),
              ),
            ),
            const SizedBox(height: 16),
            AppCtaButton(
              label: 'Recevoir le code SMS',
              loading: _submitting,
              onPressed: _sendOtp,
            ),
            const SizedBox(height: 12),
            AppSecondaryButton(
              label: 'Continuer avec Google',
              icon: TablerIcons.brand_google,
              onPressed: _submitting ? null : _signInWithGoogle,
            ),
            const Spacer(),
            TextButton(
              onPressed: () => context.go(AppRoutes.home),
              child: Text(
                'Continuer sans compte',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.navy,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
