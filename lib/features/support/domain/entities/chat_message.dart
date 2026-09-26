/// One message in the support thread.
class ChatMessage {
  const ChatMessage({
    required this.text,
    required this.fromAgent,
    required this.stamp,
  });

  final String text;

  /// True for the rider's own bubbles, false for the fleet desk.
  final bool fromAgent;

  /// Caption under the bubble, e.g. `Fleet desk · 9:47 AM`.
  final String stamp;
}
