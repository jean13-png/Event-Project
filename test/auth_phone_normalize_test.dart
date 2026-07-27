import 'package:flutter_test/flutter_test.dart';
import 'package:mymood/core/services/auth_service.dart';

void main() {
  group('AuthService.normalizeBeninPhone', () {
    test('ajoute +229 et retire le 0 local', () {
      expect(AuthService.normalizeBeninPhone('01999999'), '+2291999999');
      expect(AuthService.normalizeBeninPhone('01 99 99 99'), '+2291999999');
    });

    test('conserve le format E.164', () {
      expect(AuthService.normalizeBeninPhone('+22901999999'), '+22901999999');
      expect(AuthService.normalizeBeninPhone('0022901999999'), '+22901999999');
    });
  });
}
