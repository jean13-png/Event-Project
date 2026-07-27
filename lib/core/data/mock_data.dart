import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';

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
    required this.imageUrl,
    this.isOrganizerEvent = false,
    required this.organizerName,
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
  final String imageUrl;
  final bool isOrganizerEvent;
  final String organizerName;
  final List<TicketTypeMock> tickets;

  int get minPrice => tickets.map((t) => t.priceXof).reduce((a, b) => a < b ? a : b);
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
    imageUrl: 'https://images.unsplash.com/photo-1506157786151-b8498f5f36f5?w=800',
    isOrganizerEvent: false,
    organizerName: 'Événementiel Bénin',
    tickets: const [
      TicketTypeMock(id: 'std', name: 'Standard', priceXof: 5000, available: 120, description: 'Accès général'),
      TicketTypeMock(id: 'vip', name: 'VIP', priceXof: 15000, available: 40, description: 'Zone VIP + 1 consommation'),
      TicketTypeMock(id: 'free-pass', name: 'Pass presse', priceXof: 0, available: 10, description: 'Sur invitation'),
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
      imageUrl: 'https://images.unsplash.com/photo-1540039155733-4e8c2b5ecc90?w=800',
      isOrganizerEvent: false,
      organizerName: 'Sunset Events',
      tickets: const [TicketTypeMock(id: 's', name: 'Entrée', priceXof: 3000, available: 80)],
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
      imageUrl: 'https://images.unsplash.com/photo-1533174072545-7a4c676c2120?w=800',
      isOrganizerEvent: false,
      organizerName: 'Office du Tourisme',
      tickets: const [TicketTypeMock(id: 's', name: 'Entrée', priceXof: 0, available: 500)],
    ),
  ];

  static final List<EventMock> organizerEvents = [
    EventMock(
      id: 'org-1',
      title: 'Nuit de la mode',
      category: 'Mode',
      categoryIcon: TablerIcons.shirt,
      dateLabel: 'Sam. 16 août',
      timeLabel: '18:00',
      venue: 'Centre Culturel',
      city: 'Porto-Novo',
      description: 'Défilé mode et networking.',
      imageUrl: 'https://images.unsplash.com/photo-1539109136881-3be0616acf4b?w=800',
      isOrganizerEvent: true,
      organizerName: 'Kouame Events',
      tickets: const [
        TicketTypeMock(id: 'std', name: 'Standard', priceXof: 5000, available: 200),
        TicketTypeMock(id: 'vip', name: 'VIP', priceXof: 25000, available: 50),
      ],
    ),
    EventMock(
      id: 'org-2',
      title: 'Tech Meetup BJ',
      category: 'Tech',
      categoryIcon: TablerIcons.device_laptop,
      dateLabel: 'Mer. 20 août',
      timeLabel: '09:00',
      venue: 'Incubateur NTIC',
      city: 'Cotonou',
      description: 'Talks, démos et ateliers tech.',
      imageUrl: 'https://images.unsplash.com/photo-1544531586-fde5298cdd40?w=800',
      isOrganizerEvent: true,
      organizerName: 'Kouame Events',
      tickets: const [
        TicketTypeMock(id: 'free', name: 'Gratuit', priceXof: 0, available: 120),
      ],
    ),
    EventMock(
      id: 'org-3',
      title: 'Afro Groove Live',
      category: 'Concert',
      categoryIcon: TablerIcons.music,
      dateLabel: 'Ven. 22 août',
      timeLabel: '20:30',
      venue: 'Espace Lagoon',
      city: 'Cotonou',
      description: 'Live band, DJ set et ambiance.',
      imageUrl: 'https://images.unsplash.com/photo-1506157786151-b8498f5f36f5?w=800',
      isOrganizerEvent: true,
      organizerName: 'Kouame Events',
      tickets: const [
        TicketTypeMock(id: 'std', name: 'Standard', priceXof: 4000, available: 300),
        TicketTypeMock(id: 'vip', name: 'VIP', priceXof: 12000, available: 100),
      ],
    ),
  ];

  static EventMock eventById(String id) {
    if (id == demoConcert.id) return demoConcert;
    final all = [...suggestions, ...organizerEvents];
    return all.firstWhere((e) => e.id == id, orElse: () => demoConcert);
  }

  static const walletBalance = 245000;
  static const walletPending = 35000;

  static const transactions = [
    WalletTxMock(title: 'Vente — Afro Night (VIP x2)', amountXof: 27000, dateLabel: 'Hier', isCredit: true),
    WalletTxMock(title: 'Vente — Afro Night (Standard)', amountXof: 4500, dateLabel: 'Hier', isCredit: true),
    WalletTxMock(title: 'Retrait MTN Money', amountXof: 50000, dateLabel: '12 juil.', isCredit: false),
  ];

  static const notifications = [
    NotificationMock(title: 'Nouveau ticket vendu', body: 'VIP x1 — Afro Night Cotonou — 15 000 F', timeLabel: 'Il y a 12 min'),
    NotificationMock(title: 'Rappel événement', body: 'Afro Night commence demain à 21:00', timeLabel: 'Il y a 2 h', read: true),
    NotificationMock(title: 'Retrait traité', body: '50 000 F envoyés sur MTN Money', timeLabel: '12 juil.', read: true),
  ];
}
