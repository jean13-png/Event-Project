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
    title: 'Bienvenue sur MyMood',
    description:
        'Explorez les meilleurs événements, adresses chill, restaurants et spots incontournables au Bénin. C\'est vous qui choisissez l\'ambiance.',
    imagePath: 'assets/images/Images_onboarding/image écran 1.png',
  ),
  OnboardingSlide(
    title: 'Trouvez les meilleures soirées',
    description:
        'Concerts, festivals, soirées à thème ou afterworks... Ne ratez plus aucun événement vibrant au Bénin.',
    imagePath: 'assets/images/Images_onboarding/image ecran2.png',
  ),
  OnboardingSlide(
    title: 'Détendez-vous et savourez',
    description:
        'Lounges cosy, rooftops avec vue, bars à jus ou restaurants gourmands... Découvrez les meilleurs spots pour décompresser.',
    imagePath: 'assets/images/Images_onboarding/image écran 3.png',
  ),
];
