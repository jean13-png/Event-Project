import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/navigation/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/app_log.dart';
import '../providers/auth_providers.dart';

/// Saisie du code OTP reçu par SMS.
class OtpScreen extends ConsumerStatefulWidget {
  const OtpScreen({super.key});

  @override
  ConsumerState<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends ConsumerState<OtpScreen> {
  final _codeController = TextEditingController();
  var _submitting = false;

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _verify() async {
    final code = _codeController.text.trim();
    if (code.length < 6) {
      _showMessage('Entre le code à 6 chiffres.');
      return;
    }

    setState(() => _submitting = true);
    try {
      AppLog.info('UI: validation OTP');
      await ref.read(authControllerProvider.notifier).verifyOtp(code);
      if (!mounted) return;
      _showMessage('Connexion réussie.');
      context.go(AppRoutes.home);
    } on FirebaseAuthException catch (e, st) {
      AppLog.error('UI OTP verify FirebaseAuthException', e, st);
      _showMessage(
        e.code == 'invalid-verification-code'
            ? 'Code incorrect. Réessaie.'
            : 'Auth [${e.code}] ${e.message ?? ''}',
      );
    } catch (e, st) {
      AppLog.error('UI OTP verify erreur', e, st);
      _showMessage(e.toString());
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(authControllerProvider).value;

    return Scaffold(
      backgroundColor: AppColors.sand,
      appBar: AppBar(
        title: const Text('Code SMS'),
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
              'Vérification',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 8),
            Text(
              session == null
                  ? 'Entre le code reçu par SMS.'
                  : 'Code envoyé au ${session.phoneNumber}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 32),
            TextField(
              controller: _codeController,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              enabled: !_submitting,
              maxLength: 6,
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    letterSpacing: 8,
                  ),
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(
                hintText: '••••••',
                counterText: '',
              ),
              onSubmitted: (_) => _verify(),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _submitting ? null : _verify,
              child: _submitting
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.white,
                      ),
                    )
                  : const Text('Valider'),
            ),
          ],
        ),
      ),
    );
  }
}
