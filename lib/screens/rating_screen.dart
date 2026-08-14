import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../data/app_store.dart';
import '../models/booking.dart';
import '../theme/adaptive_palette.dart';

/// Post-job rating that feeds back into the shop's reliability score
/// (agents.md §3.1 → §3.4, MVP §5 "Post-job rating").
class RatingScreen extends StatefulWidget {
  const RatingScreen({super.key, required this.store, required this.booking});

  final AppStore store;
  final Booking booking;

  @override
  State<RatingScreen> createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  int _stars = 0;
  bool _submitting = false;

  Future<void> _submit() async {
    if (_stars == 0) return;
    setState(() => _submitting = true);
    await Future<void>.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    widget.store.rateBooking(widget.booking.id, _stars);
    Navigator.of(context).pop(true);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Thanks! Your rating helps others find reliable shops.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final palette = context.palette;
    final shop = widget.booking.shop;

    return Scaffold(
      backgroundColor: palette.paper,
      appBar: AppBar(
        title: const Text('Rate the job'),
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(28),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 84,
                  height: 84,
                  decoration: BoxDecoration(
                    color: palette.mintWash,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    shop.category.icon,
                    style: const TextStyle(fontSize: 42),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'How was the job with ${shop.name}?',
                  textAlign: TextAlign.center,
                  style: text.headlineSmall,
                ),
                const SizedBox(height: 6),
                Text(
                  'Your rating feeds straight into their reliability score.',
                  textAlign: TextAlign.center,
                  style: text.bodyMedium?.copyWith(color: palette.slate),
                ),
                const SizedBox(height: 28),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (i) {
                    final filled = i < _stars;
                    return IconButton(
                      onPressed: _submitting
                          ? null
                          : () => setState(() => _stars = i + 1),
                      iconSize: 42,
                      tooltip: '${i + 1} stars',
                      icon:
                          Icon(
                            filled
                                ? Icons.star_rounded
                                : Icons.star_outline_rounded,
                            color: filled ? palette.amber : palette.mist,
                          ).animate().scale(
                            begin: const Offset(0.7, 0.7),
                            end: const Offset(1, 1),
                            duration: 200.ms,
                            curve: Curves.easeOutBack,
                          ),
                    );
                  }),
                ),
                const SizedBox(height: 28),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: _stars == 0 || _submitting ? null : _submit,
                    style: FilledButton.styleFrom(
                      backgroundColor: palette.deepTeal,
                      foregroundColor: Colors.white,
                    ),
                    child: Text(_submitting ? 'Submitting…' : 'Submit rating'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
