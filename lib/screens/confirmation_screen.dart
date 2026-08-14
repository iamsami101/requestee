import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:motor/motor.dart';

import '../data/app_store.dart';
import '../models/booking.dart';
import '../models/category.dart';
import '../models/service_request.dart';
import '../theme/adaptive_palette.dart';
import '../theme/app_theme.dart';

/// Booking confirmation (agents.md §3.6 → §3.1). Accent animates coral → teal,
/// reinforcing "urgent problem" → "resolved/trusted" (design.md §6). Voice is
/// human and specific (design.md §8): "Booked with Al-Noor Electronics…".
class ConfirmationScreen extends StatefulWidget {
  const ConfirmationScreen({
    super.key,
    required this.store,
    required this.booking,
    required this.request,
  });

  final AppStore store;
  final Booking booking;
  final ServiceRequest request;

  @override
  State<ConfirmationScreen> createState() => _ConfirmationScreenState();
}

class _ConfirmationScreenState extends State<ConfirmationScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color get _accent => Color.lerp(
    context.palette.signalCoral,
    context.palette.deepTeal,
    Curves.easeOut.transform(_controller.value),
  )!;

  String get _headline {
    final verb = widget.booking.mode == FulfilmentMode.onSite
        ? 'Dispatched'
        : 'Booked';
    return '$verb with ${widget.booking.shop.name}';
  }

  String get _detail {
    if (widget.booking.mode == FulfilmentMode.onSite) {
      return 'A technician is on the way to your location. Expect a '
          'confirmation call within minutes.';
    }
    return 'for ${widget.booking.slot}. Your appointment is confirmed — '
        'the shop will send a reminder before the slot.';
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final palette = context.palette;

    return Scaffold(
      backgroundColor: palette.surface,
      body: SafeArea(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            final accent = _accent;
            return Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(28),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      width: 92,
                      height: 92,
                      decoration: BoxDecoration(
                        color: accent.withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        widget.booking.mode == FulfilmentMode.onSite
                            ? Icons.near_me_rounded
                            : Icons.event_available_rounded,
                        color: accent,
                        size: 44,
                      ),
                    ).animate().scale(
                      begin: const Offset(0.6, 0.6),
                      end: const Offset(1, 1),
                      curve: AppMotion.arrive.toCurve,
                      duration: 300.ms,
                    ),
                    const SizedBox(height: 28),
                    Text(
                      widget.request.summary,
                      textAlign: TextAlign.center,
                      style: text.labelMedium,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      _headline,
                      textAlign: TextAlign.center,
                      style: text.headlineMedium?.copyWith(fontSize: 22),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      _detail,
                      textAlign: TextAlign.center,
                      style: text.bodyMedium?.copyWith(color: palette.slate),
                    ),
                    const SizedBox(height: 36),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: palette.mintWash,
                        borderRadius: BorderRadius.circular(
                          AppTheme.radiusChip,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.verified_rounded,
                            size: 18,
                            color: palette.deepTeal,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Booking confirmed · #${widget.booking.id}',
                            style: text.labelLarge?.copyWith(
                              color: palette.deepTeal,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ).animate().fadeIn().slideY(
                      begin: 0.1,
                      end: 0,
                      duration: 300.ms,
                      delay: 200.ms,
                    ),
                    const SizedBox(height: 40),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: () => widget.store.advanceStatus(
                          widget.booking.id,
                        ),
                        style: FilledButton.styleFrom(
                          backgroundColor: palette.deepTeal,
                          foregroundColor: Colors.white,
                        ),
                        child: Text(
                          widget.booking.status == BookingStatus.booked
                              ? 'Mark as in progress'
                              : 'Mark as completed',
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextButton(
                      onPressed: () => Navigator.of(context).popUntil(
                        (route) => route.isFirst,
                      ),
                      style: TextButton.styleFrom(
                        foregroundColor: palette.slate,
                      ),
                      child: const Text('Back to home'),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
