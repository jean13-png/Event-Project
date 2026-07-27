import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_colors.dart';
import '../data/onboarding_model.dart';
import '../providers/onboarding_providers.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key, this.onComplete});

  final VoidCallback? onComplete;

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final slides = onboardingSlides;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        backgroundColor: AppColors.sand,
        body: Column(
          children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: slides.length,
              itemBuilder: (context, index) {
                final slide = slides[index];
                return Column(
                  children: [
                    Expanded(
                      child: Image.asset(
                        slide.imagePath,
                        fit: BoxFit.contain,
                        width: double.infinity,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
                      child: Column(
                        children: [
                          Text(
                            slide.title,
                            style: GoogleFonts.inter(
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                              letterSpacing: -0.3,
                              color: AppColors.ink,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            slide.description,
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              height: 1.5,
                              color: AppColors.muted,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          _BuildBottomControls(
            slides: slides,
            pageController: _pageController,
            onComplete: widget.onComplete,
          ),
        ],
      ),
    );
  }
}

class _BuildBottomControls extends ConsumerWidget {
  const _BuildBottomControls({
    required this.slides,
    required this.pageController,
    this.onComplete,
  });

  final List<OnboardingSlide> slides;
  final PageController pageController;
  final VoidCallback? onComplete;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              TextButton(
                onPressed: () async {
                  await _finish(ref);
                },
                child: Text(
                  'Passer',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.muted,
                  ),
                ),
              ),
              const Spacer(),
              AnimatedBuilder(
                animation: pageController,
                builder: (context, child) {
                  double page = 0;
                  if (pageController.hasClients && pageController.position.hasPixels) {
                    page = pageController.page ?? 0;
                  }
                  final currentPage = page.round();
                  return ElevatedButton.icon(
                    onPressed: () async {
                      if (currentPage < slides.length - 1) {
                        pageController.nextPage(
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeInOut,
                        );
                      } else {
                        await _finish(ref);
                      }
                    },
                    icon: Icon(Icons.arrow_forward, size: 20, color: AppColors.white),
                    label: Text(
                      currentPage < slides.length - 1 ? 'Suivant' : 'C\'est parti',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.orange,
                      foregroundColor: AppColors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                      minimumSize: const Size(0, 48),
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 18),
          _DotsIndicator(slides: slides, pageController: pageController),
        ],
      ),
    );
  }

  Future<void> _finish(WidgetRef ref) async {
    final repo = ref.read(onboardingServiceProvider);
    await repo.setCompleted();
    onComplete?.call();
  }
}

class _DotsIndicator extends StatelessWidget {
  const _DotsIndicator({
    required this.slides,
    required this.pageController,
  });

  final List<OnboardingSlide> slides;
  final PageController pageController;



  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(slides.length, (index) {
        return AnimatedBuilder(
          animation: pageController,
          builder: (context, child) {
            double delta = 0;
            if (pageController.hasClients && pageController.position.hasPixels) {
              delta = (pageController.page ?? 0) - index;
            }
            final isActive = delta.abs() < 0.5;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              height: 8,
              width: isActive ? 24 : 8,
              decoration: BoxDecoration(
                color: isActive ? AppColors.navy : AppColors.navy.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
            );
          },
        );
      }),
    );
  }
}
