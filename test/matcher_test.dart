import 'package:flutter_test/flutter_test.dart';
import 'package:requestee/data/matcher.dart' as discovery;
import 'package:requestee/models/category.dart';

void main() {
  group('Matcher (Discovery agent)', () {
    test('returns only shops of the requested category', () {
      final plumbing = discovery.Matcher.match(ServiceCategory.plumbing);
      expect(plumbing, isNotEmpty);
      expect(
        plumbing.every((s) => s.category == ServiceCategory.plumbing),
        isTrue,
      );
    });

    test('filters to on-site capable shops when requested', () {
      final onSite = discovery.Matcher.match(
        ServiceCategory.plumbing,
        onSiteOnly: true,
      );
      expect(onSite, isNotEmpty);
      expect(onSite.every((s) => s.offersOnSite), isTrue);
    });

    test('ranks higher-reliability shops above lower ones', () {
      final matches = discovery.Matcher.match(ServiceCategory.electronics);
      final ratings = matches.map((s) => s.avgRating).toList();
      // The top match should be a strongly-rated, verified shop.
      expect(matches.first.verified, isTrue);
      expect(matches.first.avgRating, greaterThanOrEqualTo(4.6));
      // Sort order sanity: reliability score desc.
      for (var i = 1; i < ratings.length; i++) {
        expect(
          ratings[i - 1],
          greaterThanOrEqualTo(ratings[i]),
          reason: 'ratings should be sorted descending',
        );
      }
    });

    test('respects category even when shops exist elsewhere', () {
      final auto = discovery.Matcher.match(ServiceCategory.auto);
      expect(
        auto.every((s) => s.category == ServiceCategory.auto),
        isTrue,
      );
    });
  });
}
