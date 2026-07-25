import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';

import '../../features/payment/data/repositories/ticket_repository.dart';
import '../../features/wallet/data/repositories/wallet_repository.dart';
import '../utils/app_log.dart';

class PaymentSession {
  const PaymentSession({
    required this.reference,
    required this.amount,
    this.checkoutUrl,
    this.simulated = false,
  });

  final String reference;
  final int amount;
  final String? checkoutUrl;
  final bool simulated;
}

/// Paiement via Cloud Functions (FedaPay). Jamais d'appel API direct.
class PaymentService {
  PaymentService({
    FirebaseFunctions? functions,
    TicketRepository? ticketRepository,
    WalletRepository? walletRepository,
  })  : _functions = functions ?? FirebaseFunctions.instance,
        _tickets = ticketRepository ?? TicketRepository(),
        _wallets = walletRepository ?? WalletRepository();

  final FirebaseFunctions _functions;
  final TicketRepository _tickets;
  final WalletRepository _wallets;
  final _uuid = const Uuid();

  /// Crée une session de paiement côté serveur.
  /// Si la Cloud Function n'est pas déployée → mode simulation (dev).
  Future<PaymentSession> createPaymentSession({
    required String eventId,
    required String ticketType,
    required int quantity,
    required int unitPrice,
    required String buyerName,
    required String buyerPhone,
    required String organizerId,
    required String paymentMethod,
  }) async {
    final amount = unitPrice * quantity;
    final reference = 'evt_${_uuid.v4().substring(0, 8)}';
    AppLog.info(
      'createPaymentSession ref=$reference amount=$amount method=$paymentMethod',
    );

    if (amount == 0) {
      // Gratuit : émet le ticket tout de suite
      await _fulfillPurchase(
        eventId: eventId,
        ticketType: ticketType,
        quantity: quantity,
        unitPrice: unitPrice,
        buyerName: buyerName,
        buyerPhone: buyerPhone,
        organizerId: organizerId,
        reference: reference,
      );
      return PaymentSession(
        reference: reference,
        amount: 0,
        simulated: true,
      );
    }

    try {
      final callable = _functions.httpsCallable('createPaymentSession');
      final result = await callable.call(<String, dynamic>{
        'eventId': eventId,
        'ticketType': ticketType,
        'quantity': quantity,
        'amount': amount,
        'buyerName': buyerName,
        'buyerPhone': buyerPhone,
        'organizerId': organizerId,
        'paymentMethod': paymentMethod,
        'reference': reference,
      });
      final data = Map<String, dynamic>.from(result.data as Map);
      final checkoutUrl = data['checkoutUrl'] as String?;
      AppLog.info('CF createPaymentSession OK url=$checkoutUrl');
      return PaymentSession(
        reference: data['reference'] as String? ?? reference,
        amount: amount,
        checkoutUrl: checkoutUrl,
      );
    } on FirebaseFunctionsException catch (e, st) {
      AppLog.error(
        'CF indisponible (${e.code}) — simulation locale du paiement',
        e,
        st,
      );
      // Dev fallback : simule un paiement réussi
      await _fulfillPurchase(
        eventId: eventId,
        ticketType: ticketType,
        quantity: quantity,
        unitPrice: unitPrice,
        buyerName: buyerName,
        buyerPhone: buyerPhone,
        organizerId: organizerId,
        reference: reference,
      );
      return PaymentSession(
        reference: reference,
        amount: amount,
        simulated: true,
      );
    }
  }

  Future<void> openCheckoutUrl(String url) async {
    final uri = Uri.parse(url);
    AppLog.info('Ouverture checkout $url');
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw StateError('Impossible d’ouvrir $url');
    }
  }

  Future<List<String>> _fulfillPurchase({
    required String eventId,
    required String ticketType,
    required int quantity,
    required int unitPrice,
    required String buyerName,
    required String buyerPhone,
    required String organizerId,
    required String reference,
  }) async {
    final buyerId = FirebaseAuth.instance.currentUser?.uid ?? 'guest';
    final ticketIds = <String>[];

    for (var i = 0; i < quantity; i++) {
      final ticket = await _tickets.createTicket(
        eventId: eventId,
        buyerId: buyerId,
        buyerPhone: buyerPhone,
        buyerName: buyerName,
        type: ticketType,
        price: unitPrice,
      );
      ticketIds.add(ticket.id);
    }

    if (unitPrice > 0) {
      // Commission différée : pour l'instant 100% crédité (à ajuster plus tard)
      await _wallets.creditWallet(
        organizerId: organizerId,
        amount: unitPrice * quantity,
        reference: reference,
        title: 'Vente — $ticketType x$quantity',
      );
    }

    AppLog.info('Achat complété tickets=${ticketIds.length}');
    return ticketIds;
  }
}
