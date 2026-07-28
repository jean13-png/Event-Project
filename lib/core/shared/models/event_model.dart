import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';

enum EventStatus { draft, published, cancelled, completed }
enum EventCategory { concert, soirtee, sport, culture, gastronomie, formation, autre }

class EventModel {
  final String id;
  final String title;
  final String description;
  final String category;
  final IconData categoryIcon;
  final String dateLabel;
  final String timeLabel;
  final String location;
  final String city;
  final double? latitude;
  final double? longitude;
  final String organizerId;
  final List<TicketType> tickets;
  final EventStatus status;
  final int views;
  final String? shareLink;
  final String? imageUrl;
  final List<String>? additionalImages;
  final String? videoUrl;
  final bool isPublic;
  final DateTime createdAt;
  final DateTime? date;
  final TimeOfDay? time;

  EventModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.categoryIcon,
    required this.dateLabel,
    required this.timeLabel,
    required this.location,
    required this.city,
    this.latitude,
    this.longitude,
    required this.organizerId,
    required this.tickets,
    required this.status,
    this.views = 0,
    this.shareLink,
    this.imageUrl,
    this.additionalImages,
    this.videoUrl,
    this.isPublic = true,
    required this.createdAt,
    this.date,
    this.time,
  });

  factory EventModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final date = (data['date'] as Timestamp?)?.toDate() ?? DateTime.now();
    final time = TimeOfDay(
      hour: (data['time'] as int?) ?? 0,
      minute: (data['timeMinute'] as int?) ?? 0,
    );
    final category = data['category'] ?? 'autre';
    final location = data['location'] ?? '';
    return EventModel(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      category: category,
      categoryIcon: iconForCategory(category),
      dateLabel: formatDate(date),
      timeLabel: formatTime(time),
      location: location,
      city: location.split(',').last.trim(),
      latitude: (data['latitude'] as num?)?.toDouble(),
      longitude: (data['longitude'] as num?)?.toDouble(),
      organizerId: data['organizerId'] ?? '',
      tickets: (data['tickets'] as List<dynamic>?)
              ?.map((t) => TicketType.fromMap(t as Map<String, dynamic>))
              .toList() ??
          [],
      status: EventStatus.values.firstWhere(
        (e) => e.name == (data['status'] ?? 'draft'),
        orElse: () => EventStatus.draft,
      ),
      views: data['views'] ?? 0,
      shareLink: data['shareLink'],
      imageUrl: data['imageUrl'],
      additionalImages: (data['additionalImages'] as List<dynamic>?)
          ?.map((i) => i as String)
          .toList(),
      videoUrl: data['videoUrl'],
      isPublic: data['isPublic'] ?? true,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      date: date,
      time: time,
    );
  }

  Map<String, dynamic> toFirestore() {
    final date = this.date ?? createdAt;
    final time = this.time ?? const TimeOfDay(hour: 0, minute: 0);
    return {
      'title': title,
      'description': description,
      'category': category,
      'date': Timestamp.fromDate(date),
      'time': time.hour,
      'timeMinute': time.minute,
      'location': location,
      'latitude': latitude,
      'longitude': longitude,
      'organizerId': organizerId,
      'tickets': tickets.map((t) => t.toMap()).toList(),
      'status': status.name,
      'views': views,
      'shareLink': shareLink,
      'imageUrl': imageUrl,
      'additionalImages': additionalImages,
      'videoUrl': videoUrl,
      'isPublic': isPublic,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  static IconData iconForCategory(String category) {
    switch (category.toLowerCase()) {
      case 'concert':
        return TablerIcons.music;
      case 'soirée':
        return TablerIcons.moon_stars;
      case 'culture':
        return TablerIcons.palette;
      case 'gastronomie':
        return TablerIcons.chef_hat;
      case 'sport':
        return TablerIcons.ball_basketball;
      case 'formation':
        return TablerIcons.school;
      case 'tech':
        return TablerIcons.device_laptop;
      case 'mode':
        return TablerIcons.shirt;
      default:
        return TablerIcons.calendar_event;
    }
  }

  static String formatDate(DateTime date) {
    const months = ['janv.', 'févr.', 'mars', 'avr.', 'mai', 'juin', 'juil.', 'août', 'sept.', 'oct.', 'nov.', 'déc.'];
    final weekday = ['Lun.', 'Mar.', 'Mer.', 'Jeu.', 'Ven.', 'Sam.', 'Dim.'][date.weekday - 1];
    return '$weekday ${date.day} ${months[date.month - 1]} ${date.year}';
  }

  static String formatTime(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  bool get isPaid => tickets.any((t) => t.price > 0);
  double get minPrice => tickets.isEmpty ? 0 : tickets.map((t) => t.price).reduce((a, b) => a < b ? a : b);
}

class TicketType {
  final String name;
  final double price;
  final int totalQty;
  final int soldQty;
  final String? description;

  TicketType({
    required this.name,
    required this.price,
    required this.totalQty,
    this.soldQty = 0,
    this.description,
  });

  factory TicketType.fromMap(Map<String, dynamic> map) {
    return TicketType(
      name: map['name'] ?? '',
      price: (map['price'] as num?)?.toDouble() ?? 0,
      totalQty: map['totalQty'] ?? 0,
      soldQty: map['soldQty'] ?? 0,
      description: map['description'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'price': price,
      'totalQty': totalQty,
      'soldQty': soldQty,
      'description': description,
    };
  }

  int get remaining => totalQty - soldQty;
  bool get isSoldOut => remaining <= 0;
}

enum TicketStatus { active, scanned, cancelled }

class TicketModel {
  final String id;
  final String eventId;
  final String buyerId;
  final String buyerName;
  final String buyerPhone;
  final String type;
  final double price;
  final String qrCode;
  final TicketStatus status;
  final DateTime purchasedAt;

  TicketModel({
    required this.id,
    required this.eventId,
    required this.buyerId,
    required this.buyerName,
    required this.buyerPhone,
    required this.type,
    required this.price,
    required this.qrCode,
    required this.status,
    required this.purchasedAt,
  });

  factory TicketModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return TicketModel(
      id: doc.id,
      eventId: data['eventId'] ?? '',
      buyerId: data['buyerId'] ?? '',
      buyerName: data['buyerName'] ?? '',
      buyerPhone: data['buyerPhone'] ?? '',
      type: data['type'] ?? '',
      price: (data['price'] as num?)?.toDouble() ?? 0,
      qrCode: data['qrCode'] ?? '',
      status: TicketStatus.values.firstWhere(
        (e) => e.name == (data['status'] ?? 'active'),
        orElse: () => TicketStatus.active,
      ),
      purchasedAt: (data['purchasedAt'] as Timestamp?)?.toDate() ??
          DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'eventId': eventId,
      'buyerId': buyerId,
      'buyerName': buyerName,
      'buyerPhone': buyerPhone,
      'type': type,
      'price': price,
      'qrCode': qrCode,
      'status': status.name,
      'purchasedAt': Timestamp.fromDate(purchasedAt),
    };
  }
}

class UserModel {
  final String uid;
  final String displayName;
  final String phone;
  final String? email;
  final UserType type;
  final List<String> preferences;
  final List<String> savedEvents;
  final List<String> followedOrganizers;
  final DateTime createdAt;

  UserModel({
    required this.uid,
    required this.displayName,
    required this.phone,
    this.email,
    required this.type,
    this.preferences = const [],
    this.savedEvents = const [],
    this.followedOrganizers = const [],
    required this.createdAt,
  });

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      uid: doc.id,
      displayName: data['displayName'] ?? data['phone'] ?? '',
      phone: data['phone'] ?? '',
      email: data['email'],
      type: UserType.values.firstWhere(
        (e) => e.name == (data['type'] ?? 'buyer'),
        orElse: () => UserType.buyer,
      ),
      preferences:
          (data['preferences'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
      savedEvents:
          (data['savedEvents'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
      followedOrganizers: (data['followedOrganizers'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'displayName': displayName,
      'phone': phone,
      'email': email,
      'type': type.name,
      'preferences': preferences,
      'savedEvents': savedEvents,
      'followedOrganizers': followedOrganizers,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}

enum UserType { buyer, organizer, admin }
