/// Options Firebase — générer avec :
/// `dart pub global activate flutterfire_cli && flutterfire configure`
///
/// Placeholder volontaire : l'app démarre sans Firebase pour l'instant.
class DefaultFirebaseOptions {
  static Never get currentPlatform {
    throw UnsupportedError(
      'Firebase non configuré. Lance `flutterfire configure` puis remplace ce fichier.',
    );
  }
}
