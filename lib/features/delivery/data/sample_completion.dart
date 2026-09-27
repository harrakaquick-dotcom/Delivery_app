/// Demo summary shown after an order is completed.
class CompletionSummary {
  const CompletionSummary({
    required this.deliveredAt,
    required this.doneToday,
    required this.doorToDoorMinutes,
    required this.streakDone,
    required this.streakTotal,
    required this.streakMessage,
  });

  final String deliveredAt;
  final int doneToday;
  final int doorToDoorMinutes;
  final int streakDone;
  final int streakTotal;
  final String streakMessage;
}

const CompletionSummary sampleCompletion = CompletionSummary(
  deliveredAt: '9:49 am',
  doneToday: 13,
  doorToDoorMinutes: 8,
  streakDone: 3,
  streakTotal: 5,
  streakMessage: '2 more on-time drops for the KES 300 bonus',
);
