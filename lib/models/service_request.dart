import 'category.dart';

/// A user's issue as submitted, plus what the intake agent inferred.
class ServiceRequest {
  const ServiceRequest({
    required this.text,
    required this.category,
    required this.urgency,
    required this.mode,
  });

  /// The plain-language problem the user described.
  final String text;

  /// Auto-classified category.
  final ServiceCategory category;

  /// Inferred urgency tier.
  final UrgencyTier urgency;

  /// Preferred fulfilment: in-shop appointment or on-site dispatch.
  final FulfilmentMode mode;

  /// Compact summary shown in the sticky context bar (design.md §7).
  String get summary => text.length > 48 ? '${text.substring(0, 48)}…' : text;
}
