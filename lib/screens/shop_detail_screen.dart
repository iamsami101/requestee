import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../data/app_store.dart';
import '../models/category.dart';
import '../models/service_request.dart';
import '../models/shop.dart';
import '../theme/adaptive_palette.dart';
import '../theme/app_theme.dart';
import '../widgets/verified_badge.dart';
import 'booking_screen.dart';

/// Shop reputation detail (agents.md §3.4). The verified badge draws on as a
/// quick teal checkmark reveal when the page opens (design.md §6).
class ShopDetailScreen extends StatefulWidget {
  const ShopDetailScreen({
    super.key,
    required this.store,
    required this.request,
    required this.shop,
  });

  final AppStore store;
  final ServiceRequest request;
  final Shop shop;

  @override
  State<ShopDetailScreen> createState() => _ShopDetailScreenState();
}

class _ShopDetailScreenState extends State<ShopDetailScreen> {
  bool _revealBadge = false;

  @override
  void initState() {
    super.initState();
    Future<void>.delayed(const Duration(milliseconds: 300), () {
      if (mounted) setState(() => _revealBadge = widget.shop.verified);
    });
  }

  @override
  Widget build(BuildContext context) {
    final shop = widget.shop;
    final text = Theme.of(context).textTheme;
    final reputation = ShopReputation(
      completionRate: shop.completionRate,
      responseMins: shop.responseMins,
      ratingConsistency: _consistency(shop),
      disputeRate: shop.disputeRate,
    );

    return Scaffold(
      backgroundColor: context.palette.paper,
      appBar: AppBar(title: const Text('Shop details')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _Avatar(shop: shop, size: 64),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(shop.name, style: text.titleLarge),
                            const SizedBox(height: 4),
                            Text(
                              '${shop.category.label} · ${shop.distanceKm.toStringAsFixed(1)} km · ${shop.priceBand}',
                              style: text.labelMedium,
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(
                                  Icons.star_rounded,
                                  size: 18,
                                  color: context.palette.deepTeal,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  shop.avgRating.toStringAsFixed(1),
                                  style: AppTheme.tabular(
                                    text.titleMedium!,
                                  ).copyWith(color: context.palette.deepTeal),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  '(${shop.ratingCount} reviews)',
                                  style: text.labelMedium,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  AnimatedSwitcher(
                    duration: 300.ms,
                    child: _revealBadge
                        ? const VerifiedLabel().animate().fadeIn()
                        : const SizedBox.shrink(),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text('Reputation', style: text.titleMedium),
          const SizedBox(height: 8),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _ReputationRow(
                    label: 'Completion rate',
                    value: '${shop.completionRate}%',
                    color: context.palette.deepTeal,
                  ),
                  const SizedBox(height: 12),
                  _ReputationRow(
                    label: 'Typical response',
                    value: shop.responseMins <= 30
                        ? '${shop.responseMins} min'
                        : '${shop.responseMins} min',
                    color: context.palette.deepTeal,
                  ),
                  const SizedBox(height: 12),
                  _ReputationRow(
                    label: 'Rating consistency',
                    value: reputation.ratingConsistency <= 0.15
                        ? 'Very consistent'
                        : 'Moderately consistent',
                    color: context.palette.deepTeal,
                  ),
                  const SizedBox(height: 12),
                  _ReputationRow(
                    label: 'Dispute rate',
                    value:
                        '${(reputation.disputeRate * 100).toStringAsFixed(0)}%',
                    color: context.palette.deepTeal,
                  ),
                  const Divider(height: 24),
                  Row(
                    children: [
                      Text('Reliability score', style: text.titleMedium),
                      const Spacer(),
                      Text(
                        reputation.score.toStringAsFixed(0),
                        style: AppTheme.tabular(
                          text.titleLarge!.copyWith(
                            color: context.palette.deepTeal,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Text(
                        '/100',
                        style: text.labelMedium,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text('How do you want to use them?', style: text.titleMedium),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => BookingScreen(
                        store: widget.store,
                        request: widget.request,
                        shop: shop,
                        mode: FulfilmentMode.appointment,
                      ),
                    ),
                  ),
                  icon: const Icon(Icons.event_available_rounded, size: 18),
                  label: const Text('Book\nappointment'),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(0, 56),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton.icon(
                  onPressed: shop.offersOnSite
                      ? () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => BookingScreen(
                              store: widget.store,
                              request: widget.request,
                              shop: shop,
                              mode: FulfilmentMode.onSite,
                            ),
                          ),
                        )
                      : null,
                  icon: const Icon(Icons.near_me_rounded, size: 18),
                  label: const Text('Request\non-site'),
                  style: FilledButton.styleFrom(
                    minimumSize: const Size(0, 56),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  double _consistency(Shop shop) {
    if (shop.ratingCount >= 250) return 0.10;
    if (shop.ratingCount >= 120) return 0.20;
    return 0.35;
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.shop, required this.size});

  final Shop shop;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: context.palette.mintWash,
        borderRadius: BorderRadius.circular(size * 0.28),
      ),
      alignment: Alignment.center,
      child: Text(
        shop.category.icon,
        style: TextStyle(fontSize: size * 0.5),
      ),
    );
  }
}

class _ReputationRow extends StatelessWidget {
  const _ReputationRow({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Row(
      children: [
        Icon(Icons.check_rounded, size: 16, color: color),
        const SizedBox(width: 10),
        Expanded(child: Text(label, style: text.bodyMedium)),
        Text(
          value,
          style: text.labelLarge?.copyWith(color: color),
        ),
      ],
    );
  }
}
