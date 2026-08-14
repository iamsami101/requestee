import 'package:flutter_test/flutter_test.dart';
import 'package:requestee/data/classifier.dart';
import 'package:requestee/models/category.dart';

void main() {
  group('Classifier (Intake agent)', () {
    test('classifies a leaking pipe as urgent plumbing, on-site', () {
      final req = Classifier.classify('leaking pipe under kitchen sink');
      expect(req.category, ServiceCategory.plumbing);
      expect(req.urgency, isNot(UrgencyTier.standard));
      expect(req.mode, FulfilmentMode.onSite);
    });

    test('classifies a phone screen as electronics appointment', () {
      final req = Classifier.classify('cracked phone screen needs repair');
      expect(req.category, ServiceCategory.electronics);
      expect(req.mode, FulfilmentMode.appointment);
    });

    test('detects an emergency (no power)', () {
      final req = Classifier.classify('no power in the house, urgent');
      expect(req.urgency, UrgencyTier.emergency);
    });

    test('falls back to general when unknown', () {
      final req = Classifier.classify('need help with something random');
      expect(req.category, ServiceCategory.other);
    });

    test('trims input text', () {
      final req = Classifier.classify('  tailor my suit  ');
      expect(req.text, 'tailor my suit');
    });

    test('infers on-site for "at my place" requests', () {
      final req = Classifier.classify('fix the AC at my place tomorrow');
      expect(req.mode, FulfilmentMode.onSite);
    });
  });
}
