import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../data/app_store.dart';
import '../models/category.dart';
import '../models/service_request.dart';
import '../models/shop.dart';
import '../theme/adaptive_palette.dart';
import '../widgets/shop_card.dart';
import '../widgets/sticky_request_bar.dart';
import 'booking_screen.dart';
import 'shop_detail_screen.dart';

/// Ranked list of matches (agents.md §3.3). Cards arrive with a staggered
/// fade+slide-up (design.md §6); a sticky summary keeps the user's request
/// in view (design.md §7).
class ResultsScreen extends StatelessWidget {
  const ResultsScreen({
    super.key,
    required this.store,
    required this.request,
    required this.matches,
  });

  final AppStore store;
  final ServiceRequest request;
  final List<Shop> matches;

  String _urgencyTag(Shop shop) {
    if (request.urgency == UrgencyTier.emergency ||
        request.urgency == UrgencyTier.sameDay) {
      return shop.openNow ? 'Same-day available' : 'Reopens soon';
    }
    return shop.openNow ? 'Open now' : 'Closed now';
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final palette = context.palette;

    return Scaffold(
      backgroundColor: palette.paper,
      appBar: AppBar(
        title: const Text('Matches'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          StickyRequestBar(request: request),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: matches.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8, left: 4),
                    child: Text(
                      'Ranked by reliability, not just distance',
                      style: text.labelMedium?.copyWith(
                        color: palette.deepTeal,
                      ),
                    ),
                  );
                }
                final shop = matches[index - 1];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child:
                      ShopCard(
                            shop: shop,
                            urgencyTag: _urgencyTag(shop),
                            onBook: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => BookingScreen(
                                  store: store,
                                  request: request,
                                  shop: shop,
                                  mode: FulfilmentMode.appointment,
                                ),
                              ),
                            ),
                            onSite: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => BookingScreen(
                                  store: store,
                                  request: request,
                                  shop: shop,
                                  mode: FulfilmentMode.onSite,
                                ),
                              ),
                            ),
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => ShopDetailScreen(
                                  store: store,
                                  request: request,
                                  shop: shop,
                                ),
                              ),
                            ),
                          )
                          .animate()
                          .fadeIn(
                            duration: 320.ms,
                            curve: Curves.easeOut,
                          )
                          .slideY(
                            begin: 0.04,
                            end: 0,
                            duration: 320.ms,
                            curve: Curves.easeOut,
                            delay: Duration(milliseconds: (index - 1) * 60),
                          ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
