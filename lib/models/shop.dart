import 'category.dart';

/// A verified local shop/centre that can be matched against a request.
class Shop {
  const Shop({
    required this.id,
    required this.name,
    required this.category,
    required this.distanceKm,
    required this.avgRating,
    required this.ratingCount,
    required this.completionRate,
    required this.responseMins,
    required this.disputeRate,
    required this.priceBand,
    required this.openNow,
    required this.verified,
    required this.offersOnSite,
  });

  final String id;
  final String name;
  final ServiceCategory category;

  /// Straight-line distance from the requester, km.
  final double distanceKm;

  /// Mean rating across all completed jobs.
  final double avgRating;
  final int ratingCount;

  /// Fraction of booked jobs that were actually completed (0–100).
  final double completionRate;

  /// Median minutes to reply to a new request.
  final int responseMins;

  /// Fraction of jobs that ended in a dispute (0–1).
  final double disputeRate;

  /// e.g. '$$', '$$$'.
  final String priceBand;

  final bool openNow;
  final bool verified;

  /// Whether the shop could fulfil an on-site dispatch.
  final bool offersOnSite;

  Shop copyWith({double? avgRating, int? ratingCount}) => Shop(
    id: id,
    name: name,
    category: category,
    distanceKm: distanceKm,
    avgRating: avgRating ?? this.avgRating,
    ratingCount: ratingCount ?? this.ratingCount,
    completionRate: completionRate,
    responseMins: responseMins,
    disputeRate: disputeRate,
    priceBand: priceBand,
    openNow: openNow,
    verified: verified,
    offersOnSite: offersOnSite,
  );
}

/// Reliability signals visualised on the shop detail screen.
class ShopReputation {
  const ShopReputation({
    required this.completionRate,
    required this.responseMins,
    required this.ratingConsistency,
    required this.disputeRate,
  });

  /// Historical completion rate (0–100).
  final double completionRate;

  /// Median response time in minutes.
  final int responseMins;

  /// Std-dev-like spread of ratings over time; lower is more consistent (0–1).
  final double ratingConsistency;

  /// Dispute rate (0–1).
  final double disputeRate;

  /// Derived trust score 0–100 used for ranking (agents.md §4).
  double get score {
    final base = 100.0;
    return (base * completionRate / 100 * 0.55) +
        ((1 - disputeRate) * 25) +
        ((1 - ratingConsistency) * 10) +
        (responseMins <= 30 ? 10 : 5);
  }
}
