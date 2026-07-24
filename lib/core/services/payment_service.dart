/// Paiement via Cloud Functions (FedaPay / Kkiapay).
/// Ne jamais appeler l'API paiement depuis le client — responsabilité Jean.
class PaymentService {
  Future<String> createPaymentSession({
    required String eventId,
    required String ticketType,
    required int quantity,
    required String buyerName,
    required String buyerPhone,
  }) async {
    throw UnimplementedError(
      'À brancher sur Cloud Function createPaymentSession',
    );
  }
}
