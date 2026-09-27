/// What an alert is about.
enum NotificationKind { surge, verification, slot, payout, rule }

/// One alert in the stream (surge, verification, slots, payouts).
class AgentNotification {
  const AgentNotification({
    required this.kind,
    required this.title,
    required this.body,
    required this.time,
    this.isNew = false,
  });

  final NotificationKind kind;
  final String title;
  final String body;
  final String time;

  /// Unread alerts get a warm tint.
  final bool isNew;
}
