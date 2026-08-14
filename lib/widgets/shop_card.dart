import 'package:flutter/material.dart';

import '../models/shop.dart';
import '../theme/adaptive_palette.dart';
import '../theme/app_theme.dart';
import 'verified_badge.dart';

/// A shop match rendered as a card (design.md §7): icon, name, rating,
/// distance, urgency-fit tag, price band, and two distinct CTAs.
class ShopCard extends StatelessWidget {
  const ShopCard({
    super.key,
    required this.shop,
    required this.urgencyTag,
    required this.onBook,
    required this.onSite,
    this.onTap,
  });

  final Shop shop;

  /// Urgency-fit tag shown on the card, e.g. 'Same-day available'.
  final String urgencyTag;

  final VoidCallback onBook;
  final VoidCallback onSite;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final text = theme.textTheme;
    final palette = context.palette;

    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTheme.radiusCard),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShopAvatar(icon: shop.category.icon, size: 52),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                shop.name,
                                style: text.titleLarge?.copyWith(
                                  fontSize: 17,
                                  height: 1.15,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (shop.verified) ...[
                              const SizedBox(width: 6),
                              const VerifiedBadge(size: 20, show: true),
                            ],
                          ],
                        ),
                        const SizedBox(height: 6),
                        Wrap(
                          spacing: 8,
                          runSpacing: 4,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            _MetaPill(
                              icon: Icons.star_rounded,
                              color: palette.deepTeal,
                              text:
                                  AppTheme.tabular(
                                    text.labelMedium!,
                                  ).copyWith(
                                    color: palette.deepTeal,
                                    fontWeight: FontWeight.w700,
                                  ),
                              value: '${shop.avgRating}',
                            ),
                            _MetaText(text, '${shop.ratingCount} reviews'),
                            _MetaPill(
                              icon: Icons.near_me_rounded,
                              color: palette.slate,
                              text: text.labelMedium!,
                              value: '${shop.distanceKm.toStringAsFixed(1)} km',
                            ),
                            _MetaText(text, shop.priceBand),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: palette.amber.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      urgencyTag,
                      style: text.labelSmall?.copyWith(
                        color: palette.charcoal,
                        fontWeight: FontWeight.w600,
                        fontSize: 11,
                      ),
                    ),
                  ),
                  const Spacer(),
                  if (!shop.openNow) ...[
                    Icon(
                      Icons.schedule,
                      size: 14,
                      color: palette.slate.withValues(alpha: 0.8),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Closed now',
                      style: text.labelSmall?.copyWith(fontSize: 11),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: onBook,
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(0, 44),
                        textStyle: theme.textTheme.labelLarge?.copyWith(
                          fontSize: 13,
                        ),
                      ),
                      child: const Text('Book appointment'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: FilledButton(
                      onPressed: onSite,
                      style: FilledButton.styleFrom(
                        minimumSize: const Size(0, 44),
                        textStyle: theme.textTheme.labelLarge?.copyWith(
                          fontSize: 13,
                        ),
                      ),
                      child: const Text('Request on-site'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MetaPill extends StatelessWidget {
  const _MetaPill({
    required this.icon,
    required this.color,
    required this.text,
    required this.value,
  });

  final IconData icon;
  final Color color;
  final TextStyle text;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 15, color: color),
        const SizedBox(width: 3),
        Text(value, style: text),
      ],
    );
  }
}

class _MetaText extends StatelessWidget {
  const _MetaText(this.text, this.value);

  final TextTheme text;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Text(
      value,
      style: text.labelMedium?.copyWith(color: context.palette.slate),
    );
  }
}
