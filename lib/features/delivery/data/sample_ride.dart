/// Demo turn-by-turn state for the ride screen (swap for the live map SDK).
class RideInfo {
  const RideInfo({
    required this.eta,
    required this.stepLabel,
    required this.instruction,
    required this.instructionDetail,
  });

  final String eta;
  final String stepLabel;
  final String instruction;
  final String instructionDetail;
}

const RideInfo sampleRide = RideInfo(
  eta: 'ETA 9:51 · 6 min',
  stepLabel: 'Step 2 of 3 · in transit · 1.4 km left',
  instruction: 'Turn right onto Riverside Drive',
  instructionDetail: 'then 300 m to Apt 12B, gate B',
);
