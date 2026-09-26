import '../domain/entities/agent_document.dart';

/// Demo onboarding documents (no backend yet).
const List<AgentDocument> sampleDocuments = [
  AgentDocument(
    ext: 'PDF',
    name: 'National ID',
    meta: 'Uploaded 4 Sep',
    status: DocumentStatus.verified,
  ),
  AgentDocument(
    ext: 'PDF',
    name: 'Driving licence',
    meta: 'Uploaded 4 Sep',
    status: DocumentStatus.verified,
  ),
  AgentDocument(
    ext: 'JPG',
    name: 'Bike logbook',
    meta: 'Under review · 1 day left',
    status: DocumentStatus.inReview,
  ),
  AgentDocument(
    ext: '+',
    name: 'Good conduct certificate',
    meta: 'Tap to upload a photo',
    status: DocumentStatus.required,
  ),
];
