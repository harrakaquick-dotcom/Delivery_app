import '../domain/entities/agent_notification.dart';

/// Demo alert stream.
const String sampleNotificationsHeadline = '3 new';

const List<AgentNotification> sampleNotifications = [
  AgentNotification(
    kind: NotificationKind.surge,
    title: 'Peak surge in KL-02',
    body: 'KES 40 extra per order until 1:00 PM.',
    time: '9:30 AM',
    isNew: true,
  ),
  AgentNotification(
    kind: NotificationKind.verification,
    title: 'Bike logbook under review',
    body: 'Verification usually takes one working day.',
    time: '8:05 AM',
    isNew: true,
  ),
  AgentNotification(
    kind: NotificationKind.slot,
    title: 'Tomorrow’s slot confirmed',
    body: '7:00 AM – 3:00 PM, Kilimani dark store.',
    time: 'Yesterday',
  ),
  AgentNotification(
    kind: NotificationKind.payout,
    title: 'Payout sent',
    body: 'KES 8,760 to M-Pesa 0712 480 991.',
    time: 'Mon',
  ),
  AgentNotification(
    kind: NotificationKind.rule,
    title: 'New rule: helmet photo check',
    body: 'Take a helmet selfie at the start of each shift.',
    time: '12 Sep',
  ),
];
