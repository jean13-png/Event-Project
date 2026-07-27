import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/onboarding_service.dart';

final onboardingServiceProvider = Provider<OnboardingService>((ref) {
  return OnboardingService();
});

final onboardingCompletedProvider = FutureProvider<bool>((ref) async {
  final service = ref.watch(onboardingServiceProvider);
  return service.isCompleted();
});
