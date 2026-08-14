import '../models/category.dart';
import '../models/service_request.dart';

/// Naive rule-based stand-in for the Intake/Classification agent (agents.md §3.2).
///
/// Parses free text into a category, urgency tier, and fulfilment mode. A real
/// backend would replace this with an LLM/classifier; the interface stays the
/// same so the UI is not coupled to the implementation.
abstract final class Classifier {
  static const _urgencyKeywords = {
    'urgent',
    'emergency',
    'asap',
    'now',
    'burst',
    'flood',
    'leaking heavily',
    'fire',
    'smoke',
    'danger',
    'no power',
    'dead',
    'broken down',
  };

  static const _sameDayKeywords = {
    'today',
    'same day',
    'tomorrow',
    'soon',
    'quick',
    'asap-ish',
    'leak',
    'screen cracked',
  };

  /// Infers an urgency tier from free text.
  static UrgencyTier inferUrgency(String text) {
    final lower = text.toLowerCase();
    if (_urgencyKeywords.any(lower.contains)) return UrgencyTier.emergency;
    if (_sameDayKeywords.any(lower.contains)) return UrgencyTier.sameDay;
    if (lower.contains('week') || lower.contains('next week')) {
      return UrgencyTier.soon;
    }
    return UrgencyTier.standard;
  }

  /// Picks a fulfilment mode: on-site strongly implied by context words.
  static FulfilmentMode inferMode(String text) {
    final lower = text.toLowerCase();
    const onSiteHints = [
      'at my place',
      'on-site',
      'at home',
      'in my house',
      'my apartment',
      'here',
      'to my location',
      'water on the floor',
      'under sink',
      'sink',
      'ceiling',
      'wall',
      'burst',
      'flood',
    ];
    if (onSiteHints.any(lower.contains)) return FulfilmentMode.onSite;
    return FulfilmentMode.appointment;
  }

  /// Full classification of a user-submitted issue.
  static ServiceRequest classify(String text) => ServiceRequest(
    text: text.trim(),
    category: ServiceCategory.fromKeyword(text),
    urgency: inferUrgency(text),
    mode: inferMode(text),
  );
}
