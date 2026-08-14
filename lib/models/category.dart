/// The domain models for requesT.
library;

/// Service categories recognised by the intake classifier.
enum ServiceCategory {
  plumbing('Plumbing', 'pipes, leaks, taps, drains'),
  electrical('Electrical', 'wiring, power, outlets, fixtures'),
  electronics('Electronics', 'phones, screens, repairs'),
  tailoring('Tailoring', 'alterations, stitching, mending'),
  auto('Auto Service', 'cars, tyres, oil, servicing'),
  hvac('HVAC', 'AC, heating, ventilation, cooling'),
  cleaning('Cleaning', 'cleaning, tidying, deep clean'),
  carpentry('Carpentry', 'woodwork, doors, furniture repair'),
  other('General', 'anything else that needs fixing');

  const ServiceCategory(this.label, this.keywords);

  /// Human-readable category name.
  final String label;

  /// Plain-language keywords used by the naive classifier.
  final String keywords;

  /// Icon used across category tiles and shop cards.
  String get icon {
    switch (this) {
      case plumbing:
        return '🔧';
      case electrical:
        return '⚡';
      case electronics:
        return '📱';
      case tailoring:
        return '🧵';
      case auto:
        return '🚗';
      case hvac:
        return '❄️';
      case cleaning:
        return '🧹';
      case carpentry:
        return '🪚';
      case other:
        return '🧰';
    }
  }

  static ServiceCategory fromKeyword(String text) {
    final lower = text.toLowerCase();
    final words = lower.split(RegExp(r'[^a-z]+')).where((w) => w.length > 2);
    for (final category in values) {
      for (final keyword in category.keywords.split(',')) {
        final kw = keyword.trim();
        if (kw.isEmpty) continue;
        // Direct containment (e.g. "leaking" → "leak" won't match, so also
        // match singular stems of both the keyword and the text words).
        if (lower.contains(kw)) return category;
        final stem = kw.endsWith('s') ? kw.substring(0, kw.length - 1) : kw;
        if (words.any((w) => w == stem || w.contains(stem))) return category;
      }
    }
    return other;
  }
}

/// Urgency tier inferred from the request text (design.md §3.2).
enum UrgencyTier {
  emergency('Emergency', 'Same-day'),
  sameDay('Same-day', 'Same-day'),
  soon('Within a few days', 'Within 2 days'),
  standard('Whenever', 'Flexible');

  const UrgencyTier(this.label, this.tag);

  final String label;

  /// Short chip text used on cards and tags.
  final String tag;
}

/// How the job is fulfilled (agents.md §3.6).
enum FulfilmentMode {
  appointment('Book appointment'),
  onSite('Request on-site');

  const FulfilmentMode(this.label);

  final String label;
}
