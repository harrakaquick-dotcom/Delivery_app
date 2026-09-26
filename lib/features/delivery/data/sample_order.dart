import '../domain/entities/delivery_order.dart';

/// The demo order pushed by SIMULATE.
const DeliveryOrder sampleOrder = DeliveryOrder(
  id: '#HRK-48213',
  payout: 180,
  tip: 50,
  baseFare: 120,
  distancePay: 60,
  totalKm: 2.5,
  storeName: 'Harraka Dark Store — Kilimani',
  storeAddress: 'Ring Rd, bay 3',
  pickupKm: 0.4,
  pickupRideMinutes: 2,
  customerName: 'Wanjiru M.',
  dropAddress: 'Riverside Drive, Apt 12B',
  dropDetail: 'gate B',
  dropKm: 2.1,
  orderValue: 1240,
  lines: [
    OrderLine(name: 'Brookside Fresh Milk 1L', meta: 'Chiller · aisle A2', qty: 2),
    OrderLine(name: 'Tusker Malt 500ml', meta: 'Crate · aisle D1', qty: 4),
    OrderLine(name: 'Sukuma wiki bunch', meta: 'Fresh · aisle B4', qty: 1),
    OrderLine(name: 'Weetabix 700g', meta: 'Dry · aisle C3', qty: 1),
  ],
);
