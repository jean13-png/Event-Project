import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/utils/app_log.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/design_system.dart';
import '../providers/payment_providers.dart';
import '../../../event_page/data/models/event_model.dart';
import '../../../event_page/presentation/providers/event_providers.dart';

/// Checkout billetterie — nom, téléphone, type, Mobile Money.
class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key, required this.eventId});

  final String eventId;

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  late EventTicketType _selected;
  var _quantity = 1;
  var _method = 'mtn';
  var _loading = false;

  @override
  void initState() {
    super.initState();
    _selected = const EventTicketType(
      type: 'Standard',
      price: 5000,
      totalQty: 120,
      soldQty: 0,
      description: 'Accès général',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  int get _total => _selected.price * _quantity;

  Future<void> _pay() async {
    if (_nameController.text.trim().isEmpty ||
        _phoneController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nom et téléphone requis')),
      );
      return;
    }

    final eventAsync = ref.read(eventProvider(widget.eventId));
    final event = eventAsync.value;
    if (event == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Événement introuvable')),
      );
      return;
    }

    setState(() => _loading = true);
    try {
      final session = await ref.read(paymentServiceProvider).createPaymentSession(
            eventId: widget.eventId,
            ticketType: _selected.type,
            quantity: _quantity,
            unitPrice: _selected.price,
            buyerName: _nameController.text.trim(),
            buyerPhone: _phoneController.text.trim(),
            organizerId: event.organizerId,
            paymentMethod: _method,
          );

      if (!mounted) return;

      if (session.checkoutUrl != null && session.checkoutUrl!.isNotEmpty) {
        await ref.read(paymentServiceProvider).openCheckoutUrl(session.checkoutUrl!);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Paiement lancé — ref: ${session.reference}'),
            backgroundColor: AppColors.green,
          ),
        );
      }

      context.push(
        '/events/${widget.eventId}/success',
        extra: {
          'buyerName': _nameController.text.trim(),
          'ticketName': _selected.type,
          'amount': _total,
          'method': _method,
          'ticketIds': session.ticketIds,
        },
      );
    } catch (e, st) {
      AppLog.error('Checkout pay erreur', e, st);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Paiement échoué: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final eventAsync = ref.watch(eventProvider(widget.eventId));

    return Scaffold(
      backgroundColor: AppColors.sand,
      appBar: AppBar(
        title: const Text('Achat de ticket'),
        leading: IconButton(
          icon: const Icon(TablerIcons.arrow_left, size: 20),
          onPressed: () => context.pop(),
        ),
      ),
      body: eventAsync.when(
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.navy)),
        error: (e, _) => Center(child: Text('Erreur: $e', style: const TextStyle(color: AppColors.muted))),
        data: (event) {
          if (event.tickets.isNotEmpty && _selected.type != event.tickets.first.type) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                setState(() => _selected = event.tickets.first);
              }
            });
          }

          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
            children: [
              Text(
                event.title,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.3,
                  color: AppColors.ink,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${event.dateLabel} · ${event.venue}',
                style: GoogleFonts.inter(fontSize: 12, color: AppColors.muted),
              ),
              const SizedBox(height: 22),
              Text(
                'Type de ticket',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.ink,
                ),
              ),
              const SizedBox(height: 12),
              ...event.tickets.map((t) {
                final selected = t.type == _selected.type;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: AppSurfaceCard(
                    onTap: () => setState(() => _selected = t),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 14,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          selected
                              ? TablerIcons.circle_check
                              : TablerIcons.circle,
                          size: 20,
                          color: selected ? AppColors.navy : AppColors.muted,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            t.type,
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.ink,
                            ),
                          ),
                        ),
                        Text(
                          t.price == 0 ? 'Gratuit' : '${t.price} FCFA',
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: t.price == 0 ? AppColors.green : AppColors.orange,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
              const SizedBox(height: 14),
              Text(
                'Quantité',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.ink,
                ),
              ),
              const SizedBox(height: 12),
              AppSurfaceCard(
                child: Row(
                  children: [
                    IconButton(
                      onPressed: _quantity > 1
                          ? () => setState(() => _quantity--)
                          : null,
                      icon: const Icon(TablerIcons.minus, size: 18),
                    ),
                    Expanded(
                      child: Text(
                        '$_quantity',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: _quantity < 10
                          ? () => setState(() => _quantity++)
                          : null,
                      icon: const Icon(TablerIcons.plus, size: 18),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              Text(
                'Tes infos',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.ink,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Pas de compte obligatoire — le ticket partira par SMS.',
                style: GoogleFonts.inter(fontSize: 12, color: AppColors.muted),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _nameController,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  hintText: 'Nom complet',
                  prefixIcon: Icon(TablerIcons.user, size: 18),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  hintText: 'Téléphone (+229…)',
                  prefixIcon: Icon(TablerIcons.phone, size: 18),
                ),
              ),
              const SizedBox(height: 22),
              Text(
                'Paiement',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.ink,
                ),
              ),
              const SizedBox(height: 12),
              _PayMethodTile(
                label: 'MTN Mobile Money',
                icon: TablerIcons.device_mobile,
                selected: _method == 'mtn',
                onTap: () => setState(() => _method = 'mtn'),
              ),
              const SizedBox(height: 10),
              _PayMethodTile(
                label: 'Moov Money',
                icon: TablerIcons.device_mobile,
                selected: _method == 'moov',
                onTap: () => setState(() => _method = 'moov'),
              ),
              const SizedBox(height: 10),
              _PayMethodTile(
                label: 'Carte bancaire',
                icon: TablerIcons.credit_card,
                selected: _method == 'card',
                onTap: () => setState(() => _method = 'card'),
              ),
              const SizedBox(height: 22),
              AppSurfaceCard(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      _total == 0 ? 'Gratuit' : '${_total.toStringAsFixed(0)} FCFA',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: _total == 0 ? AppColors.green : AppColors.orange,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              AppCtaButton(
                label: _total == 0 ? 'Réserver' : 'Payer maintenant',
                loading: _loading,
                onPressed: _loading ? null : _pay,
              ),
            ],
          );
        },
      ),
    );
  }
}

class _PayMethodTile extends StatelessWidget {
  const _PayMethodTile({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppSurfaceCard(
      onTap: onTap,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      child: Row(
        children: [
          Icon(
            selected ? TablerIcons.circle_check : icon,
            size: 20,
            color: selected ? AppColors.navy : AppColors.muted,
          ),
          const SizedBox(width: 12),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: AppColors.ink,
            ),
          ),
        ],
      ),
    );
  }
}
