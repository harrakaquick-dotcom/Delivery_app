/// Final state of a past order.
enum OrderOutcome { delivered, returned }

/// One row in the agent's order history.
class OrderHistoryItem {
  const OrderHistoryItem({
    required this.time,
    required this.id,
    required this.drop,
    required this.meta,
    required this.pay,
    required this.outcome,
  });

  final String time;
  final String id;
  final String drop;
  final String meta;
  final String pay;
  final OrderOutcome outcome;
}
