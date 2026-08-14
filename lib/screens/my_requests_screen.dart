import 'package:flutter/material.dart';

import '../data/app_store.dart';
import '../models/booking.dart';
import '../models/category.dart';
import '../theme/adaptive_palette.dart';
import 'rating_screen.dart';

/// History of the user's jobs (agents.md §3.1). Completed jobs can be rated,
/// feeding back into the shop's reliability score — closing the loop.
class MyRequestsScreen extends StatelessWidget {
  const MyRequestsScreen({super.key, required this.store});

  final AppStore store;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final palette = context.palette;

    return Scaffold(
      backgroundColor: palette.paper,
      appBar: AppBar(
        title: const Text('My requests'),
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListenableBuilder(
        listenable: store,
        builder: (context, _) {
          final bookings = store.bookings.reversed.toList();
          if (bookings.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.history_rounded,
                    size: 56,
                    color: palette.mist,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No requests yet',
                    style: text.titleMedium,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'When you post an issue it shows up here.',
                    style: text.bodyMedium?.copyWith(color: palette.slate),
                  ),
                ],
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: bookings.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final booking = bookings[index];
              return _BookingTile(
                store: store,
                booking: booking,
              );
            },
          );
        },
      ),
    );
  }
}

class _BookingTile extends StatelessWidget {
  const _BookingTile({required this.store, required this.booking});

  final AppStore store;
  final Booking booking;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final palette = context.palette;
    final isDone = booking.status == BookingStatus.completed;
    final rated = booking.rating != null;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: palette.mintWash,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    booking.shop.category.icon,
                    style: const TextStyle(fontSize: 22),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        booking.shop.name,
                        style: text.titleMedium?.copyWith(fontSize: 15),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        booking.request.summary,
                        style: text.labelMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                _StatusChip(status: booking.status),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  booking.mode == FulfilmentMode.onSite
                      ? Icons.near_me_rounded
                      : Icons.event_available_rounded,
                  size: 15,
                  color: palette.slate,
                ),
                const SizedBox(width: 6),
                Text(booking.slot, style: text.labelMedium),
                const Spacer(),
                if (isDone && !rated)
                  TextButton(
                    onPressed: () async {
                      await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => RatingScreen(
                            store: store,
                            booking: booking,
                          ),
                        ),
                      );
                    },
                    child: const Text('Rate job'),
                  )
                else if (rated)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.star_rounded,
                        size: 16,
                        color: palette.amber,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'You rated ${booking.rating}',
                        style: text.labelMedium?.copyWith(
                          color: palette.deepTeal,
                        ),
                      ),
                    ],
                  )
                else
                  TextButton(
                    onPressed: () => store.advanceStatus(booking.id),
                    child: Text(
                      booking.status == BookingStatus.booked
                          ? 'Start job'
                          : 'Complete',
                      style: TextStyle(color: palette.slate),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});

  final BookingStatus status;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final (bg, fg) = switch (status) {
      BookingStatus.booked => (palette.mintWash, palette.deepTeal),
      BookingStatus.inProgress => (
        palette.amber.withValues(alpha: 0.2),
        palette.charcoal,
      ),
      BookingStatus.completed => (
        palette.deepTeal.withValues(alpha: 0.15),
        palette.deepTeal,
      ),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        status.label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: fg,
          fontWeight: FontWeight.w700,
          fontSize: 11,
        ),
      ),
    );
  }
}
