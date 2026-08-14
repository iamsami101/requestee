import 'package:flutter_test/flutter_test.dart';
import 'package:requestee/data/app_store.dart';
import 'package:requestee/data/classifier.dart';
import 'package:requestee/models/booking.dart';
import 'package:requestee/models/category.dart';

void main() {
  group('AppStore (Reputation agent + job lifecycle)', () {
    test('adds a booking', () {
      final store = AppStore();
      final request = Classifier.classify('cracked phone screen');
      final shop = store.shopById('t1');

      final booking = store.addBooking(
        request: request,
        shop: shop,
        mode: FulfilmentMode.appointment,
        slot: 'Today, 4:30 PM',
      );

      expect(store.bookings, hasLength(1));
      expect(booking.shop.name, 'Al-Noor Electronics');
      expect(booking.status, BookingStatus.booked);
    });

    test('advances booking status', () {
      final store = AppStore();
      final request = Classifier.classify('leaking pipe');
      final booking = store.addBooking(
        request: request,
        shop: store.shopById('p1'),
        mode: FulfilmentMode.onSite,
        slot: 'Dispatch window: 1:30 PM',
      );

      store.advanceStatus(booking.id);
      expect(booking.status, BookingStatus.inProgress);
      store.advanceStatus(booking.id);
      expect(booking.status, BookingStatus.completed);
    });

    test('rating feeds back into shop reputation', () {
      final store = AppStore();
      final request = Classifier.classify('screen repair');
      final before = store.shopById('t1');

      final booking = store.addBooking(
        request: request,
        shop: before,
        mode: FulfilmentMode.appointment,
        slot: 'Today, 4:30 PM',
      );
      store.rateBooking(booking.id, 5);

      final after = store.shopById('t1');
      expect(after.ratingCount, before.ratingCount + 1);
      expect(booking.rating, 5);
    });
  });
}
