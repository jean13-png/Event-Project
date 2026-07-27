class OnboardingSlide {
  const OnboardingSlide({
    required this.title,
    required this.description,
    required this.imagePath,
  });

  final String title;
  final String description;
  final String imagePath;
}

const onboardingSlides = [
  OnboardingSlide(
    title: 'Bienvenue sur EventBJ',
    description:
        'Découvrez les meilleurs événements au Bénin : concerts, soirées, festivals, sports et activités culturelles.',
    imagePath: 'assets/images/onboarding/onboard_1.png',
  ),
  OnboardingSlide(
    title: 'Ne ratez aucun événement',
    description:
        'Retrouvez tous les événements près de chez vous, filtrez par catégorie, ville ou date, et réservez en quelques clics.',
    imagePath: 'assets/images/onboarding/onboard_2.png',
  ),
  OnboardingSlide(
    title: 'Préparez votre sortie',
    description:
        'Achetez vos tickets en ligne, recevez votre QR code et présentez-le directement à l’entrée.',
    imagePath: 'assets/images/onboarding/onboard_3.png',
  ),
];
