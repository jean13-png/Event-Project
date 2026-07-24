import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/navigation/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/auth_providers.dart';

/// Connexion OTP SMS — responsabilité Jean.
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
    } on FirebaseAuthException catch (e) {
      _showMessage(_mapAuthError(e));
    } catch (e) {
      _showMessage('Impossible d’envoyer le SMS. Réessaie.');
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  String _mapAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-phone-number':
        return 'Numéro invalide. Utilise le format +229…';
      case 'too-many-requests':
        return 'Trop de tentatives. Réessaie plus tard.';
      case 'quota-exceeded':
        return 'Quota SMS dépassé. Utilise un numéro de test Firebase.';
      case 'missing-client-identifier':
        return 'SHA manquant dans Firebase (ajoute SHA-1 / SHA-256).';
      default:
        return e.message ?? 'Erreur d’authentification (${e.code}).';
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
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
            Text(
              'EventBJ',
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    color: AppColors.navy,
                  ),
            ),
            const SizedBox(height: 8),
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
            ElevatedButton(
              onPressed: _submitting ? null : _sendOtp,
              child: _submitting
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.white,
                      ),
                    )
                  : const Text('Recevoir le code SMS'),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: _submitting
                  ? null
                  : () {
                      _showMessage(
                        'Google Sign-In — prochaine étape.',
                      );
                    },
              icon: const Icon(TablerIcons.brand_google, size: 18),
              label: const Text('Continuer avec Google'),
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
