import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';

class EventTicketType {
  const EventTicketType({
    required this.type,
    required this.price,
    required this.totalQty,
    required this.soldQty,
    this.description = '',
  });

  final String type;
  final int price;
  final int totalQty;
  final int soldQty;
  final String description;

  int get available => (totalQty - soldQty).clamp(0, totalQty);

  Map<String, dynamic> toMap() => {
        'type': type,
        'price': price,
        'totalQty': totalQty,
        'soldQty': soldQty,
        'description': description,
      };

  factory EventTicketType.fromMap(Map<String, dynamic> map) {
    return EventTicketType(
      type: map['type'] as String? ?? '',
      price: (map['price'] as num?)?.toInt() ?? 0,
      totalQty: (map['totalQty'] as num?)?.toInt() ?? 0,
      soldQty: (map['soldQty'] as num?)?.toInt() ?? 0,
      description: map['description'] as String? ?? '',
    );
  }
}

class EventModel {
  const EventModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.date,
    required this.time,
    required this.locationName,
    required this.city,
    required this.organizerId,
    required this.tickets,
    required this.status,
    this.shareLink = '',
    this.views = 0,
  });

  final String id;
  final String title;
  final String description;
  final String category;
  final DateTime date;
  final String time;
  final String locationName;
  final String city;
  final String organizerId;
  final List<EventTicketType> tickets;
  final String status;
  final String shareLink;
  final int views;

  int get minPrice => tickets.isEmpty
      ? 0
      : tickets.map((t) => t.price).reduce((a, b) => a < b ? a : b);

  IconData get categoryIcon {
    switch (category.toLowerCase()) {
      case 'soirée':
      case 'soiree':
        return TablerIcons.moon_stars;
      case 'sport':
        return TablerIcons.trophy;
      case 'culture':
        return TablerIcons.palette;
      case 'gastronomie':
        return TablerIcons.tools_kitchen_2;
      case 'formation':
        return TablerIcons.microphone_2;
      case 'concert':
      default:
        return TablerIcons.music;
    }
  }

  String get dateLabel {
    const days = ['Lun.', 'Mar.', 'Mer.', 'Jeu.', 'Ven.', 'Sam.', 'Dim.'];
    const months = [
      'janv.',
      'févr.',
      'mars',
      'avr.',
      'mai',
      'juin',
      'juil.',
      'août',
      'sept.',
      'oct.',
      'nov.',
      'déc.',
    ];
    final d = days[date.weekday - 1];
    return '$d ${date.day} ${months[date.month - 1]} ${date.year}';
  }

  Map<String, dynamic> toMap() => {
        'title': title,
        'description': description,
        'category': category,
        'date': Timestamp.fromDate(date),
        'time': time,
        'location': {
          'name': locationName,
          'city': city,
        },
        'organizerId': organizerId,
        'tickets': tickets.map((t) => t.toMap()).toList(),
        'status': status,
        'shareLink': shareLink,
        'views': views,
        'createdAt': FieldValue.serverTimestamp(),
      };

  factory EventModel.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    final location = data['location'];
    String locationName = '';
    String city = '';
    if (location is Map) {
      locationName = location['name'] as String? ?? '';
      city = location['city'] as String? ?? '';
    } else if (location is String) {
      locationName = location;
    }

    final rawTickets = data['tickets'] as List<dynamic>? ?? [];
    final tickets = rawTickets
        .whereType<Map>()
        .map((e) => EventTicketType.fromMap(Map<String, dynamic>.from(e)))
        .toList();

    DateTime date;
    final rawDate = data['date'];
    if (rawDate is Timestamp) {
      date = rawDate.toDate();
    } else if (rawDate is String) {
      date = DateTime.tryParse(rawDate) ?? DateTime.now();
    } else {
      date = DateTime.now();
    }

    return EventModel(
      id: doc.id,
      title: data['title'] as String? ?? '',
      description: data['description'] as String? ?? '',
      category: data['category'] as String? ?? 'Concert',
      date: date,
      time: data['time'] as String? ?? '',
      locationName: locationName,
      city: city,
      organizerId: data['organizerId'] as String? ?? '',
      tickets: tickets,
      status: data['status'] as String? ?? 'draft',
      shareLink: data['shareLink'] as String? ?? '',
      views: (data['views'] as num?)?.toInt() ?? 0,
    );
  }
}
