/// One line to verify at the dark store.
class OrderLine {
  const OrderLine({required this.name, required this.meta, required this.qty});

  final String name;
  final String meta;
  final int qty;
}

/// How the customer settles the order.
enum PaymentMode { mpesa, cash }

/// A single delivery job: pick up at the store, drop at the customer.
class DeliveryOrder {
  const DeliveryOrder({
    required this.id,
    required this.payout,
    required this.tip,
    required this.baseFare,
    required this.distancePay,
    required this.totalKm,
    required this.storeName,
    required this.storeAddress,
    required this.pickupKm,
    required this.pickupRideMinutes,
    required this.customerName,
    required this.dropAddress,
    required this.dropDetail,
    required this.dropKm,
    required this.orderValue,
    required this.lines,
  });

  final String id;

  /// What the agent is offered on the request screen (before tip).
  final int payout;
  final int tip;
  final int baseFare;
  final int distancePay;
  final double totalKm;
  final String storeName;
  final String storeAddress;
  final double pickupKm;
  final int pickupRideMinutes;
  final String customerName;
  final String dropAddress;
  final String dropDetail;
  final double dropKm;

  /// Amount due from the customer.
  final int orderValue;
  final List<OrderLine> lines;

  int get itemCount => lines.fold(0, (sum, l) => sum + l.qty);
  int get totalEarned => baseFare + distancePay + tip;

  /// Reference without the leading hash, e.g. `HRK-48213`.
  String get reference => id.replaceFirst('#', '');

  /// Order number without the `HRK-` prefix, e.g. `48213`.
  String get shortId => id.replaceFirst('#HRK-', '');
}
