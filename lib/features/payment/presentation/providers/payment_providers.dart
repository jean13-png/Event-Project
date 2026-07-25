import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/services/payment_service.dart';
import '../../data/repositories/ticket_repository.dart';

final paymentServiceProvider = Provider<PaymentService>((ref) {
  return PaymentService();
});

final ticketRepositoryProvider = Provider<TicketRepository>((ref) {
  return TicketRepository();
});
