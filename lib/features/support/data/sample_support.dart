import '../domain/entities/chat_message.dart';

/// Quick-pick issue chips.
const List<String> sampleIssues = [
  'Customer not reachable',
  'Wrong address',
  'Item damaged',
  'Store delay',
  'Payment problem',
  'Accident / SOS',
];

/// Demo opening thread.
const List<ChatMessage> sampleThread = [
  ChatMessage(
    text:
        'Gate B is locked and the customer is not picking up. What should I do?',
    fromAgent: true,
    stamp: 'Fleet desk · 9:47 AM',
  ),
  ChatMessage(
    text:
        'Wait 3 minutes, then take a photo at the gate and mark it undelivered. Your payout is protected.',
    fromAgent: false,
    stamp: 'Fleet desk · 9:48 AM',
  ),
];
