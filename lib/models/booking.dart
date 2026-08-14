import 'category.dart';
import 'service_request.dart';
import 'shop.dart';

/// Lifecycle of a job (agents.md §3.5 / §3.6).
enum BookingStatus {
  booked('Booked'),
  inProgress('In progress'),
  completed('Completed');

  const BookingStatus(this.label);

  final String label;
}

/// A fulfilled request — an appointment or on-site dispatch.
class Booking {
  Booking({
    required this.id,
    required this.request,
    required this.shop,
    required this.mode,
    required this.slot,
    this.status = BookingStatus.booked,
    this.rating,
  });

  final String id;
  final ServiceRequest request;
  final Shop shop;
  final FulfilmentMode mode;

  /// Human display of the chosen slot, e.g. 'Today, 4:30 PM'.
  final String slot;

  BookingStatus status;

  /// 1–5 post-job rating; null until rated.
  int? rating;
}
