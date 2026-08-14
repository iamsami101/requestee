import '../models/category.dart';
import '../models/shop.dart';
import 'mock_catalog.dart';

/// Discovery/Matching agent (agents.md §3.3).
///
/// Filters nearby shops by category and ranks them by a reliability score —
/// not just proximity or star rating (agents.md §4).
abstract final class Matcher {
  /// Returns shops able to fulfil [category], ranked best-first.
  static List<Shop> match(ServiceCategory category, {bool onSiteOnly = false}) {
    final candidates = MockCatalog.forCategory(
      category,
    ).where((s) => !onSiteOnly || s.offersOnSite).toList();

    candidates.sort((a, b) => _score(b).compareTo(_score(a)));
    return candidates;
  }

  /// Reliability-weighted score in 0–100 (agents.md §4).
  static double _score(Shop shop) {
    final reputation = ShopReputation(
      completionRate: shop.completionRate,
      responseMins: shop.responseMins,
      ratingConsistency: _consistency(shop),
      disputeRate: shop.disputeRate,
    );
    // Blend the reliability signal with a small distance factor so the
    // ranking still feels location-aware, but reliability dominates.
    final reliability = reputation.score;
    final distanceFactor = (10.0 - shop.distanceKm).clamp(0, 10) * 0.5;
    return reliability + distanceFactor;
  }

  /// Proxy for rating variance over time; we derive it from rating volume so
  /// fewer-rated shops look slightly less consistent.
  static double _consistency(Shop shop) {
    if (shop.ratingCount >= 250) return 0.10;
    if (shop.ratingCount >= 120) return 0.20;
    return 0.35;
  }
}
