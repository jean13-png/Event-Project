import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/navigation/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/design_system.dart';
import '../../../../core/services/organizer_service.dart';
import '../../../../core/services/cloudinary_service.dart';
import '../../../../core/shared/models/event_model.dart';
import '../../../auth/presentation/providers/auth_providers.dart';

class OrganizerEventFormScreen extends ConsumerStatefulWidget {
  const OrganizerEventFormScreen({super.key, this.eventId});

  final String? eventId;

  @override
  ConsumerState<OrganizerEventFormScreen> createState() => _OrganizerEventFormScreenState();
}

class _OrganizerEventFormScreenState extends ConsumerState<OrganizerEventFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _locationController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _ticketNameController = TextEditingController();
  final _ticketPriceController = TextEditingController();
  final _ticketQtyController = TextEditingController();

  DateTime _date = DateTime.now().add(const Duration(days: 7));
  TimeOfDay _time = const TimeOfDay(hour: 20, minute: 0);
  String _category = 'Concert';
  final String _city = 'Cotonou';
  bool _loading = false;
  File? _poster;

  final List<Map<String, dynamic>> _tickets = [];

  @override
  void dispose() {
    _titleController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    _ticketNameController.dispose();
    _ticketPriceController.dispose();
    _ticketQtyController.dispose();
    super.dispose();
  }

  Future<void> _pickPoster() async {
    final picker = ImagePicker();
    final file = await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (file != null) setState(() => _poster = File(file.path));
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);

    try {
      final user = ref.read(authStateProvider).value;
      if (user == null) throw Exception('Utilisateur non connecté');

      final organizerService = OrganizerService();
      String? imageUrl = _poster?.path ?? '';
      if (_poster != null) {
        final cloudinary = CloudinaryService();
        imageUrl = await cloudinary.uploadImage(_poster!) ?? imageUrl;
      }

      final event = EventModel(
        id: widget.eventId ?? DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        category: _category,
        categoryIcon: EventModel.iconForCategory(_category),
        dateLabel: EventModel.formatDate(_date),
        timeLabel: EventModel.formatTime(_time),
        location: _locationController.text.trim(),
        city: _city,
        organizerId: user.uid,
        tickets: _tickets.map((t) => TicketType(name: t['name'], price: double.tryParse(t['price']) ?? 0, totalQty: int.tryParse(t['qty']) ?? 0)).toList(),
        imageUrl: imageUrl,
        status: EventStatus.published,
        createdAt: DateTime.now(),
        date: _date,
        time: _time,
      );

      final eventId = await organizerService.createEvent(event);

      await ref.read(notificationServiceProvider).createNotification(
            user.uid,
            'Événement publié',
            '${_titleController.text.trim()} est maintenant visible.',
          );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Événement publié (id: $eventId)'), backgroundColor: AppColors.green),
      );
      context.go(AppRoutes.home);
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erreur: $e')));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.sand,
      appBar: AppBar(
        title: const Text('Créer un événement'),
        leading: IconButton(onPressed: () => context.pop(), icon: const Icon(TablerIcons.arrow_left, size: 20)),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Titre'),
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Requis' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _locationController,
              decoration: const InputDecoration(labelText: 'Lieu'),
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Requis' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
              maxLines: 4,
            ),
            const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            initialValue: _category,
            decoration: const InputDecoration(labelText: 'Catégorie'),
            items: const ['Concert', 'Soirée', 'Culture', 'Sport', 'Formation', 'Gastronomie', 'Tech', 'Mode']
                .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                .toList(),
            onChanged: (v) => setState(() => _category = v ?? _category),
          ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      final picked = await showDatePicker(context: context, initialDate: _date, firstDate: DateTime.now(), lastDate: DateTime.now().add(const Duration(days: 365)));
                      if (picked != null) setState(() => _date = picked);
                    },
                    icon: const Icon(TablerIcons.calendar, size: 18),
                    label: Text('${_date.day}/${_date.month}/${_date.year}'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      final picked = await showTimePicker(context: context, initialTime: _time);
                      if (picked != null) setState(() => _time = picked);
                    },
                    icon: const Icon(TablerIcons.clock, size: 18),
                    label: Text(_time.format(context)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(onPressed: _pickPoster, icon: const Icon(TablerIcons.photo, size: 18), label: Text(_poster == null ? 'Ajouter une affiche' : 'Affiche sélectionnée')),
            const SizedBox(height: 20),
            const Text('Billets', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.ink)),
            const SizedBox(height: 8),
            ..._tickets.map((t) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: AppSurfaceCard(
                    child: Row(
                      children: [
                        Expanded(child: Text('${t['name']} — ${t['price']} F — ${t['qty']} places')),
                        IconButton(onPressed: () => setState(() => _tickets.remove(t)), icon: const Icon(TablerIcons.trash, size: 18, color: AppColors.muted)),
                      ],
                    ),
                  ),
                )),
            Row(
              children: [
                Expanded(child: TextFormField(controller: _ticketNameController, decoration: const InputDecoration(labelText: 'Type'))),
                const SizedBox(width: 8),
                SizedBox(width: 80, child: TextFormField(controller: _ticketPriceController, decoration: const InputDecoration(labelText: 'Prix'), keyboardType: TextInputType.number)),
                const SizedBox(width: 8),
                SizedBox(width: 80, child: TextFormField(controller: _ticketQtyController, decoration: const InputDecoration(labelText: 'Qté'), keyboardType: TextInputType.number)),
              ],
            ),
            const SizedBox(height: 8),
            TextButton.icon(
              onPressed: () {
                if (_ticketNameController.text.trim().isEmpty ||
                    _ticketPriceController.text.trim().isEmpty ||
                    _ticketQtyController.text.trim().isEmpty) {
                  return;
                }
                setState(() {
                  _tickets.add({
                    'name': _ticketNameController.text.trim(),
                    'price': _ticketPriceController.text.trim(),
                    'qty': _ticketQtyController.text.trim(),
                  });
                  _ticketNameController.clear();
                  _ticketPriceController.clear();
                  _ticketQtyController.clear();
                });
              },
              icon: const Icon(TablerIcons.plus, size: 18),
              label: const Text('Ajouter un type de billet'),
            ),
            const SizedBox(height: 20),
            AppCtaButton(label: 'Publier', loading: _loading, onPressed: _loading ? null : _submit),
          ],
        ),
      ),
    );
  }
}
