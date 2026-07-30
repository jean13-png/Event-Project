import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../data/onboarding_model.dart';

class OnboardingScreen extends ConsumerWidget {
  const OnboardingScreen({super.key, this.onComplete});

  final VoidCallback? onComplete;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final slides = onboardingSlides;
    final pageController = PageController();

    return Scaffold(
      backgroundColor: AppColors.sand,
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: pageController,
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
                            style: AppTextStyles.h2,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            slide.description,
                            style: AppTextStyles.body,
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
            pageController: pageController,
            onComplete: onComplete,
          ),
        ],
      ),
    );
  }
}

class _BuildBottomControls extends StatelessWidget {
  const _BuildBottomControls({
    required this.slides,
    required this.pageController,
    this.onComplete,
  });

  final List<OnboardingSlide> slides;
  final PageController pageController;
  final VoidCallback? onComplete;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () async {
                  await Navigator.of(context).pushReplacementNamed('/');
                  onComplete?.call();
                },
                child: Text(
                  'Passer',
                  style: AppTextStyles.body.copyWith(color: AppColors.muted),
                ),
              ),
              ElevatedButton.icon(
                onPressed: () async {
                  final currentPage = pageController.page?.round() ?? 0;
                  if (currentPage < slides.length - 1) {
                    pageController.nextPage(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeInOut,
                    );
                  } else {
                    await Navigator.of(context).pushReplacementNamed('/');
                    onComplete?.call();
                  }
                },
                icon: const Icon(Icons.arrow_forward, size: 20),
                label: const Text('C\'est parti'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.orange,
                  foregroundColor: AppColors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          _DotsIndicator(slides: slides, pageController: pageController),
        ],
      ),
    );
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
            if (pageController.position.hasPixels) {
              delta = (pageController.page ?? 0) - index;
            }
            final isActive = delta.abs() < 0.5;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              height: 8,
              width: isActive ? 24 : 8,
              decoration: BoxDecoration(
                color: isActive ? AppColors.navy : const Color(0x140D3B6E),
                borderRadius: BorderRadius.circular(8),
              ),
            );
          },
        );
      }),
    );
  }
}
