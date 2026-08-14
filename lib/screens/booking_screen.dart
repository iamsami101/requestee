import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../data/app_store.dart';
import '../models/category.dart';
import '../models/service_request.dart';
import '../models/shop.dart';
import '../theme/app_colors.dart';
import 'confirmation_screen.dart';

/// Scheduling & dispatch (agents.md §3.6): in-shop appointment with time slots
/// or on-site dispatch to the requester's location.
class BookingScreen extends StatefulWidget {
  const BookingScreen({
    super.key,
    required this.store,
    required this.request,
    required this.shop,
    required this.mode,
  });

  final AppStore store;
  final ServiceRequest request;
  final Shop shop;
  final FulfilmentMode mode;

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  String? _selectedSlot;
  bool _confirming = false;

  static const _slots = [
    'Today, 10:00 AM',
    'Today, 1:30 PM',
    'Today, 4:30 PM',
    'Tomorrow, 9:00 AM',
    'Tomorrow, 11:30 AM',
    'Tomorrow, 3:00 PM',
  ];

  @override
  Widget build(BuildContext context) {
    final isOnSite = widget.mode == FulfilmentMode.onSite;
    final title = isOnSite ? 'Request on-site' : 'Book an appointment';
    final subtitle = isOnSite
        ? 'A ${widget.shop.name} technician will come to you.'
        : 'Choose a time slot at ${widget.shop.name}.';

    return Scaffold(
      backgroundColor: AppColors.paper,
      appBar: AppBar(title: Text(title)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: AppColors.mintWash,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          widget.shop.category.icon,
                          style: const TextStyle(fontSize: 24),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.shop.name,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              widget.request.summary,
                              style: Theme.of(context).textTheme.labelMedium,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(subtitle, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 6),
              Text(
                isOnSite
                    ? 'We\'ll send a worker to your saved location. You\'ll '
                          'pick a dispatch window below.'
                    : 'Pick a slot — shops confirm instantly on requesT.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.slate,
                ),
              ),
              const SizedBox(height: 16),
              if (isOnSite)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.location_on_rounded,
                          color: AppColors.signalCoral,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Dispatch to: your home address',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                        Text(
                          '~${widget.shop.distanceKm.toStringAsFixed(1)} km away',
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                      ],
                    ),
                  ),
                )
              else
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    for (final slot in _slots)
                      ChoiceChip(
                        label: Text(slot),
                        selected: _selectedSlot == slot,
                        selectedColor: AppColors.mintWash,
                        showCheckmark: false,
                        labelStyle: TextStyle(
                          color: _selectedSlot == slot
                              ? AppColors.deepTeal
                              : AppColors.charcoal,
                          fontWeight: FontWeight.w600,
                        ),
                        side: BorderSide(
                          color: _selectedSlot == slot
                              ? AppColors.deepTeal
                              : AppColors.mist,
                        ),
                        onSelected: (_) => setState(() => _selectedSlot = slot),
                      ),
                  ],
                ),
              const SizedBox(height: 28),
              AnimatedSwitcher(
                duration: 200.ms,
                child: SizedBox(
                  key: ValueKey(_confirming),
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: _canConfirm ? _confirm : null,
                    icon: _confirming
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Icon(
                            isOnSite
                                ? Icons.near_me_rounded
                                : Icons.event_available_rounded,
                          ),
                    label: Text(
                      _confirming
                          ? 'Booking…'
                          : isOnSite
                          ? 'Confirm dispatch'
                          : 'Confirm booking',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool get _canConfirm => _confirming || (_selectedSlot != null || _isOnSite);

  bool get _isOnSite => widget.mode == FulfilmentMode.onSite;

  Future<void> _confirm() async {
    setState(() => _confirming = true);
    await Future<void>.delayed(const Duration(milliseconds: 700));
    if (!mounted) return;

    final booking = widget.store.addBooking(
      request: widget.request,
      shop: widget.shop,
      mode: widget.mode,
      slot: _isOnSite ? 'Dispatch window: 1:30–5:30 PM' : (_selectedSlot ?? ''),
    );

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => ConfirmationScreen(
          store: widget.store,
          booking: booking,
          request: widget.request,
        ),
      ),
    );
  }
}
