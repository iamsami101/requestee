import 'package:flutter/foundation.dart';

import '../models/booking.dart';
import '../models/category.dart';
import '../models/service_request.dart';
import '../models/shop.dart';
import 'mock_catalog.dart';

/// In-memory store for bookings and shop reputation. Stands in for the
/// backend + Reputation Agent (agents.md §3.4) in the MVP.
///
/// Plain [ChangeNotifier] so the UI can react via [ListenableBuilder]
/// without pulling in a state-management dependency.
class AppStore extends ChangeNotifier {
  /// Simulated search latency for the Discovery agent. Shortened in tests.
  Duration matchingDelay = const Duration(milliseconds: 1600);

  final List<Booking> _bookings = [];

  /// Mirrors of catalog shops so post-job ratings can feed back live.
  final List<Shop> _liveShops = MockCatalog.shops.map((s) => s).toList();

  List<Booking> get bookings => List.unmodifiable(_bookings);

  Shop shopById(String id) =>
      _liveShops.firstWhere((s) => s.id == id, orElse: () => _liveShops.first);

  /// Adds a new booking (appointment or on-site dispatch).
  Booking addBooking({
    required ServiceRequest request,
    required Shop shop,
    required FulfilmentMode mode,
    required String slot,
  }) {
    final booking = Booking(
      id: 'b${_bookings.length + 1}',
      request: request,
      shop: shop,
      mode: mode,
      slot: slot,
    );
    _bookings.add(booking);
    notifyListeners();
    return booking;
  }

  /// Advances a booking status (provider side: booked → in progress → done).
  void advanceStatus(String bookingId) {
    final index = _bookings.indexWhere((b) => b.id == bookingId);
    if (index < 0) return;
    final booking = _bookings[index];
    booking.status = switch (booking.status) {
      BookingStatus.booked => BookingStatus.inProgress,
      BookingStatus.inProgress => BookingStatus.completed,
      BookingStatus.completed => BookingStatus.completed,
    };
    notifyListeners();
  }

  /// Post-job rating that feeds back into the shop's reputation (agents.md §3.4).
  void rateBooking(String bookingId, int stars) {
    final index = _bookings.indexWhere((b) => b.id == bookingId);
    if (index < 0) return;
    final booking = _bookings[index];
    booking.rating = stars;

    final shopIndex = _liveShops.indexWhere((s) => s.id == booking.shop.id);
    if (shopIndex >= 0) {
      final shop = _liveShops[shopIndex];
      final newCount = shop.ratingCount + 1;
      final newAvg = ((shop.avgRating * shop.ratingCount) + stars) / newCount;
      _liveShops[shopIndex] = shop.copyWith(
        avgRating: double.parse(newAvg.toStringAsFixed(1)),
        ratingCount: newCount,
      );
    }
    notifyListeners();
  }

  Shop get liveShopReference => _liveShops.first;
}
