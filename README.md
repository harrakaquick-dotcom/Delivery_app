# Harraka Agent

Flutter app for Harraka delivery agents (riders). Currently a **UI-only build on dummy data** — no backend yet.

## Quick start

```bash
flutter pub get
flutter run -t lib/main_dev.dart      # or main_staging.dart / main_prod.dart
flutter analyze && flutter test
```

Sign in with any 9 digits and any 4-digit code, go online on the Duty tab, then press **SIMULATE** to run a full delivery.

## Docs

- **[`Docs/Harraka_project_guide.md`](Docs/Harraka_project_guide.md)** — for developers: folder structure, screens and routes, providers, environments (dev / staging / prod), app icon and splash, testing notes, and a checklist for adding a screen.
- **[`Docs/Harraka_delivery_setup.md`](Docs/Harraka_delivery_setup.md)** — for AI coding agents: stack choices, coding rules and design tokens.
