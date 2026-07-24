import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';

/// Données mock pour les écrans Jean (avant branchement Firestore).
class TicketTypeMock {
  const TicketTypeMock({
    required this.id,
    required this.name,
    required this.priceXof,
    required this.available,
    this.description = '',
  });

  final String id;
  final String name;
  final int priceXof;
  final int available;
  final String description;
}

class EventMock {
  const EventMock({
    required this.id,
    required this.title,
    required this.category,
    required this.categoryIcon,
    required this.dateLabel,
    required this.timeLabel,
    required this.venue,
    required this.city,
    required this.description,
    required this.tickets,
  });

  final String id;
  final String title;
  final String category;
  final IconData categoryIcon;
  final String dateLabel;
  final String timeLabel;
  final String venue;
  final String city;
  final String description;
  final List<TicketTypeMock> tickets;

  int get minPrice =>
      tickets.map((t) => t.priceXof).reduce((a, b) => a < b ? a : b);
}

class WalletTxMock {
  const WalletTxMock({
    required this.title,
    required this.amountXof,
    required this.dateLabel,
    required this.isCredit,
  });

  final String title;
  final int amountXof;
  final String dateLabel;
  final bool isCredit;
}

class NotificationMock {
  const NotificationMock({
    required this.title,
    required this.body,
    required this.timeLabel,
    this.read = false,
  });

  final String title;
  final String body;
  final String timeLabel;
  final bool read;
}

abstract final class MockData {
  static final EventMock demoConcert = EventMock(
    id: 'demo-concert',
    title: 'Afro Night Cotonou',
    category: 'Concert',
    categoryIcon: TablerIcons.music,
    dateLabel: 'Sam. 2 août 2025',
    timeLabel: '21:00',
    venue: 'Palais des Congrès',
    city: 'Cotonou',
    description:
        'Une soirée afrobeat avec les meilleurs artistes de la scène locale. '
        'Dress code chic décontracté. Parking disponible sur place.',
    tickets: const [
      TicketTypeMock(
        id: 'std',
        name: 'Standard',
        priceXof: 5000,
        available: 120,
        description: 'Accès général',
      ),
      TicketTypeMock(
        id: 'vip',
        name: 'VIP',
        priceXof: 15000,
        available: 40,
        description: 'Zone VIP + 1 consommation',
      ),
      TicketTypeMock(
        id: 'free-pass',
        name: 'Pass presse',
        priceXof: 0,
        available: 10,
        description: 'Sur invitation',
      ),
    ],
  );

  static final List<EventMock> suggestions = [
    EventMock(
      id: 'demo-soiree',
      title: 'Lagune Sunset',
      category: 'Soirée',
      categoryIcon: TablerIcons.moon_stars,
      dateLabel: 'Ven. 8 août',
      timeLabel: '19:00',
      venue: 'Haie Vive',
      city: 'Cotonou',
      description: '',
      tickets: const [
        TicketTypeMock(id: 's', name: 'Entrée', priceXof: 3000, available: 80),
      ],
    ),
    EventMock(
      id: 'demo-culture',
      title: 'Festival Vodun Days',
      category: 'Culture',
      categoryIcon: TablerIcons.palette,
      dateLabel: 'Dim. 10 août',
      timeLabel: '16:00',
      venue: 'Place Goho',
      city: 'Ouidah',
      description: '',
      tickets: const [
        TicketTypeMock(id: 's', name: 'Entrée', priceXof: 0, available: 500),
      ],
    ),
  ];

  static EventMock eventById(String id) {
    if (id == demoConcert.id) return demoConcert;
    return suggestions.firstWhere(
      (e) => e.id == id,
      orElse: () => demoConcert,
    );
  }

  static const walletBalance = 245000;
  static const walletPending = 35000;

  static const transactions = [
    WalletTxMock(
      title: 'Vente — Afro Night (VIP x2)',
      amountXof: 27000,
      dateLabel: 'Hier',
      isCredit: true,
    ),
    WalletTxMock(
      title: 'Vente — Afro Night (Standard)',
      amountXof: 4500,
      dateLabel: 'Hier',
      isCredit: true,
    ),
    WalletTxMock(
      title: 'Retrait MTN Money',
      amountXof: 50000,
      dateLabel: '12 juil.',
      isCredit: false,
    ),
  ];

  static const notifications = [
    NotificationMock(
      title: 'Nouveau ticket vendu',
      body: 'VIP x1 — Afro Night Cotonou — 15 000 F',
      timeLabel: 'Il y a 12 min',
    ),
    NotificationMock(
      title: 'Rappel événement',
      body: 'Afro Night commence demain à 21:00',
      timeLabel: 'Il y a 2 h',
      read: true,
    ),
    NotificationMock(
      title: 'Retrait traité',
      body: '50 000 F envoyés sur MTN Money',
      timeLabel: '12 juil.',
      read: true,
    ),
  ];
}
