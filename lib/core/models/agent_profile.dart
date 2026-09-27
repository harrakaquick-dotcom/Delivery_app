/// The signed-in delivery agent.
class AgentProfile {
  const AgentProfile({
    required this.name,
    required this.agentId,
    required this.bike,
    required this.zone,
    required this.store,
    required this.rating,
    required this.mpesa,
  });

  final String name;
  final String agentId;
  final String bike;
  final String zone;
  final String store;
  final double rating;
  final String mpesa;

  String get firstName => name.split(' ').first;

  String get initials => name
      .split(' ')
      .where((p) => p.isNotEmpty)
      .take(2)
      .map((p) => p[0].toUpperCase())
      .join();
}

/// Demo agent used until real auth exists.
const AgentProfile sampleAgent = AgentProfile(
  name: 'Brian Otieno',
  agentId: 'HRK-2291',
  bike: 'KDJ 442K',
  zone: 'KL-02',
  store: 'Kilimani dark store',
  rating: 4.9,
  mpesa: '0712 480 991',
);
