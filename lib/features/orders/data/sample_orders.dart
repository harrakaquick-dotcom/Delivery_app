import '../domain/entities/order_history_item.dart';

/// Demo order history for today.
const String sampleOrdersSummary = '13 today · 0 cancelled';

const List<OrderHistoryItem> sampleOrderHistory = [
  OrderHistoryItem(
    time: '9:49',
    id: '#48213',
    drop: 'Riverside Dr',
    meta: '8 min · 2.5 km · cash',
    pay: 'KES 230',
    outcome: OrderOutcome.delivered,
  ),
  OrderHistoryItem(
    time: '9:21',
    id: '#48190',
    drop: 'Kileleshwa',
    meta: '11 min · 3.1 km · M-Pesa',
    pay: 'KES 210',
    outcome: OrderOutcome.delivered,
  ),
  OrderHistoryItem(
    time: '8:58',
    id: '#48166',
    drop: 'Yaya Centre',
    meta: '7 min · 1.8 km · M-Pesa',
    pay: 'KES 165',
    outcome: OrderOutcome.delivered,
  ),
  OrderHistoryItem(
    time: '8:34',
    id: '#48141',
    drop: 'Hurlingham',
    meta: 'Customer not reachable',
    pay: 'KES 90',
    outcome: OrderOutcome.returned,
  ),
  OrderHistoryItem(
    time: '8:12',
    id: '#48119',
    drop: 'Lavington',
    meta: '9 min · 2.9 km · cash',
    pay: 'KES 205',
    outcome: OrderOutcome.delivered,
  ),
  OrderHistoryItem(
    time: '7:44',
    id: '#48092',
    drop: 'Kilimani',
    meta: '6 min · 1.2 km · M-Pesa',
    pay: 'KES 150',
    outcome: OrderOutcome.delivered,
  ),
];
