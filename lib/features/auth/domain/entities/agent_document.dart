/// Review state of an onboarding document.
enum DocumentStatus { verified, inReview, required }

/// A document the agent must have verified before going online.
class AgentDocument {
  const AgentDocument({
    required this.ext,
    required this.name,
    required this.meta,
    required this.status,
  });

  /// File-type tile label, e.g. `PDF` or `+` when nothing is uploaded yet.
  final String ext;
  final String name;
  final String meta;
  final DocumentStatus status;
}
