# Harraka Agent — Flutter Project Guide

Delivery-agent (rider) app for Harraka's 10-minute dark-store delivery. **Right now this is a UI-only build running on dummy data — there is no backend.**

**This guide is for developers:** what is built, where it lives, how to run it and how to extend it.
[`Harraka_delivery_setup.md`](Harraka_delivery_setup.md) is the separate instruction file for AI coding agents (stack choices, coding rules, design tokens). It is not repeated here — read it for the rules and the colour/type/spacing tokens.

---

## 1. Tech Stack

Flutter (Dart `^3.10.4`), Riverpod state, plain `onGenerateRoute` routing, `intl` for KES formatting, `flutter_svg`, plus `flutter_launcher_icons` and `flutter_native_splash`. The full planned stack is in the setup file. **Not added yet** because there is no backend: Dio (networking) and `shared_preferences` (storage).

---

## 2. Getting Started

```bash
flutter pub get
flutter analyze          # must stay clean
flutter test             # must stay green
dart format lib test     # run before every commit
```

Run an environment (see section 6):

```bash
flutter run -t lib/main_dev.dart
flutter run -t lib/main_staging.dart
flutter run -t lib/main_prod.dart --release
```

Plain `flutter run` uses `lib/main.dart`, which starts the **dev** environment. VS Code has three matching launch entries in `.vscode/launch.json`.

**Try the app:** sign in with any 9 digits, enter any 4-digit code, continue through verification, flip the duty toggle to go online, then press **SIMULATE** to receive an order and walk the whole delivery.

---

## 3. Folder Structure (as built)

```
delivery/
├── android/  ios/  web/
├── assets/
│   ├── images/            # harraka_logo.svg
│   ├── icons/             # launcher + splash artwork (section 8)
│   ├── fonts/             # empty — Archivo .ttf files not added yet
│   └── lottie/
├── Docs/                  # this file
├── lib/
│   ├── main.dart          # default entry = dev
│   ├── main_dev.dart      # entry per environment
│   ├── main_staging.dart
│   ├── main_prod.dart
│   ├── bootstrap.dart     # runApp + ProviderScope with the chosen AppConfig
│   ├── app.dart           # MaterialApp: theme, routes, env ribbon
│   │
│   ├── config/
│   │   ├── app_config.dart        # Environment enum, AppConfig, appConfigProvider
│   │   └── env/                   # dev.dart, staging.dart, prod.dart
│   │
│   ├── core/
│   │   ├── constants/     # app_colors, app_text_styles, app_spacing, app_strings
│   │   ├── theme/         # app_theme.dart
│   │   ├── models/        # agent_profile.dart (shared signed-in agent)
│   │   ├── providers/     # session_providers.dart (online flag, tab index, agent)
│   │   ├── routing/       # route_names.dart, app_router.dart
│   │   ├── utils/         # formatters.dart (KES, km)
│   │   └── widgets/       # shared UI (section 5)
│   │
│   └── features/
│       ├── auth/          # login, otp, docs (verification)
│       ├── shell/         # MainShell: 5-tab bottom bar
│       ├── duty/          # duty home tab
│       ├── orders/        # orders tab
│       ├── earnings/      # earnings tab
│       ├── notifications/ # alerts tab
│       ├── profile/       # profile tab
│       ├── delivery/      # order request → pickup → ride → hand over → payment → completed
│       └── support/       # support chat
│           (each: data/ + domain/entities/ + presentation/{screens,providers,widgets})
│
└── test/                  # one test file per screen/feature
```

`lib/core/network/`, `lib/core/error/`, `lib/l10n/` and `lib/core/utils/{validator,extensions}` exist as empty placeholders (`.gitkeep`) for when they are needed.

### Project-specific rules

The general coding rules (3-layer features, tokens only, route + router per screen, `///` doc comments, `const`, naming) are in the setup file. On top of those:

- **No feature imports another feature's internals.** Share through `core/` (models, providers, widgets, utils) or pass data via route arguments. Exception: `features/shell` composes the tab screens because it is the composition root.
- Widgets used by 2+ features go in `core/widgets/`; screen-only widgets in that feature's `presentation/widgets/`.
- Run `dart format lib test`, `flutter analyze` and `flutter test` before every commit.
- All work so far is on branch `features/auth`, one commit per screen. Commit only when asked.

---

## 4. Screens, Routes and Flow

| # | Screen | Route | File |
|---|---|---|---|
| 1 | Sign in (first screen) | `/login` | `features/auth/.../login_screen.dart` |
| 2 | OTP | `/otp` (arg: 9-digit phone `String`) | `otp_screen.dart` |
| 3 | Verification | `/docs` | `docs_screen.dart` |
| 4–5, 11–14 | Main shell + tabs | `/main` | `features/shell/.../main_shell.dart` |
| 5 | Order request | `/request` | `features/delivery/.../order_request_screen.dart` |
| 6 | Store pickup | `/pickup` | `store_pickup_screen.dart` |
| 7 | Ride | `/ride` | `ride_screen.dart` |
| 8 | Hand over | `/deliver` | `hand_over_screen.dart` |
| 9 | Collect payment | `/cash` | `collect_payment_screen.dart` |
| 10 | Completed | `/done` | `order_completed_screen.dart` |
| 15 | Support | `/support` (arg: optional order id `String`) | `features/support/.../support_screen.dart` |

**Tabs inside `/main`** (index constants in `MainTab`): Duty (`DutyHomeScreen`), Orders (`OrdersScreen`), Earn (`EarningsScreen`), Alerts (`NotificationsScreen`), Me (`ProfileScreen`).

**Main flow:**

```
Native splash → Login → OTP → Verification → Main shell (Duty)
   Duty: go online → SIMULATE → Order request (30 s countdown, Accept / Decline)
   → Store pickup (tick all 4 lines) → Ride → Hand over (4-digit code)
   → Collect payment (M-Pesa / Cash) → Completed → Back online (Duty) or Orders
```

Entry points into Support: the message button on Ride, the "Support" shift tool on Duty, and "Help & safety" on Profile. "Cash in bag" and "Incentives" shift tools open the payment and completed screens directly. Sign out on Profile returns to Login.

Navigation between flow screens uses `pushReplacementNamed` (the shell stays underneath); finishing the flow uses `pushNamedAndRemoveUntil(RouteNames.main, …)`.

### Buttons that are still UI-only (do nothing)

Call store, Call customer, Report a missing item, "Customer unreachable — take a photo", Download statement, and the Language row on Profile. Wire them when real features exist.

---

## 5. State and Shared Building Blocks

### Providers

| Provider | Where | Purpose |
|---|---|---|
| `appConfigProvider` | `config/app_config.dart` | Active environment config |
| `onlineProvider` (`StateProvider<bool>`) | `core/providers/session_providers.dart` | Agent on/off duty |
| `mainTabProvider` (`StateProvider<int>`) | same | Selected bottom tab; use `MainTab.*` |
| `agentProvider` | same | Signed-in agent (`sampleAgent` for now) |
| `activeOrderProvider` | `features/delivery/.../delivery_providers.dart` | The order being delivered |
| `pickupChecklistProvider` | same | Which order lines are ticked |
| `dropCodeProvider` | same | 4-digit customer code |
| `paymentModeProvider`, `cashInBagProvider` | same | M-Pesa/cash choice and cash balance |
| `earningsRangeProvider` | `features/earnings/...` | Today / This week / Month |

### Shared widgets (`lib/core/widgets/`)

`AppButton` (primary CTA, inert when `onPressed == null`), `SecondaryButton`, `AppCard`, `PillChip`, `PillTabs` (segmented control), `SectionLabel` (11px uppercase), `CodeBoxes` + `NumericKeypad` (OTP and hand-over code), `TwoColumnGrid` (content-sized 2-column grid), `PulseDot`.

Use these before writing new one-off widgets. `Formatters.kes(1240)` → `KES 1,240`; `Formatters.km(2.5)` → `2.5 km`.

### Dummy data → backend

Each feature keeps its demo data in `data/sample_*.dart` (const objects) exposed through a provider or read by the screen; the shapes are the classes in `domain/entities/`. When the backend exists: keep the entities, delete the `sample_*.dart` files, add a repository, and change the providers to load from it. A few values are still hardcoded inside screens (ride ETA and instruction live in `sample_ride.dart`; some strings such as "Resend code in 0:24" are literals) — move them into entities at that point.

---

## 6. Environments (dev / staging / prod)

`lib/config/`:

| File | Environment | App name | Logging | Ribbon |
|---|---|---|---|---|
| `env/dev.dart` → `devConfig` | Dev | Harraka Agent Dev | on | green DEV |
| `env/staging.dart` → `stagingConfig` | Staging | Harraka Agent Staging | on | orange STAGING |
| `env/prod.dart` → `prodConfig` | Production | Harraka Agent | off | none |

`AppConfig` fields: `environment`, `appName`, `baseUrl`, `enableLogging`, plus `isProd`. `baseUrl` values are **placeholders** (`https://…harraka.example`) — replace them when the API exists. Read the config anywhere with `ref.watch(appConfigProvider)`.

Each `lib/main_<env>.dart` calls `bootstrap(<env>Config)`, which overrides `appConfigProvider` in the root `ProviderScope`. Tests that don't override it get the dev config.

**Adding a setting** (e.g. a feature flag): add the field to `AppConfig`, then set it in all three env files.
**Adding an environment:** add a value to `Environment`, create `env/<name>.dart` and `main_<name>.dart`, add a `.vscode/launch.json` entry.

These are Dart-level environments: all three install with the same Android/iOS app ID. If testers need dev, staging and prod installed side by side with different names and icons, add Android product flavors and iOS schemes (not done yet).

---

## 7. Theme and Design Tokens

Brand direction, the colour palette, typography scale, spacing and radius are defined in section 3 of [`Harraka_delivery_setup.md`](Harraka_delivery_setup.md). **The code is the source of truth:** `lib/core/constants/app_colors.dart`, `app_text_styles.dart`, `app_spacing.dart` and `lib/core/theme/app_theme.dart`. The design source is the claude.ai Design project "Delivery agent app design".

Added while building the screens (not in the setup file):

| Addition | Value | Usage |
|---|---|---|
| `AppColors.primaryTint` | `#FFFAF8` | Selected rows, unread alerts |
| `AppColors.primarySoft` / `primaryBorder` | `#F6D5CC` / `#F2C8BF` | Unfilled streak bars, tinted borders |
| `AppColors.mintOnInk` / `mintOnInkBg` | `#8FF0BB` / 20% green | "Delivered" pill on the ink header card |
| `AppTextStyles.title` / `titleSmall` | 14 / 13, weight 600 | Row and card titles |
| `AppTextStyles.chip` | 10, weight 600, +0.09em | Chips and small uppercase kickers |
| `AppSpacing.radius*`, `elevation*` | 14 / 18 / 22 / 26 / pill; 2 / 8 | Radii and elevations |

> The Archivo `.ttf` files are **not bundled yet**, so text falls back to the system font. Put `Archivo-Regular.ttf` and `Archivo-SemiBold.ttf` in `assets/fonts/` and add the `fonts:` block from the setup file to `pubspec.yaml`.

---

## 8. App Icon and Splash Screen

Artwork lives in `assets/icons/`:

| File | Used for |
|---|---|
| `delivery_app_logo.jpg` (1024×1024) | Launcher icon source (Android + iOS) |
| `delivery_app_splash.png` | Splash centre image (edges feathered so it blends into the red) |
| `delivery_app_splash_android12.png` (1152×1152) | Android 12+ splash icon (art kept inside the centre circle) |
| `delivery_text.png` (800×320, white) | Splash branding text, bottom |
| `delivery_text_dark.png` (800×320) | Same wordmark for light backgrounds |

Both tools are configured in `pubspec.yaml` (`flutter_launcher_icons:` and `flutter_native_splash:` blocks). After changing any artwork or config, regenerate:

```bash
dart run flutter_launcher_icons -f pubspec.yaml
dart run flutter_native_splash:create
```

- Launcher: Android + iOS, adaptive icon background `#E5301F`, foreground inset 15, iOS alpha removed.
- Splash: colour `#E53421`, fullscreen, branding at the bottom with 48 padding, separate Android 12 block. Keep the splash colour equal to the artwork's edge colour, or a visible box appears around the image.
- There is **no Flutter-side splash screen**: after the native splash the app opens directly on `/login` (`initialRoute`). Do not add one — use `flutter_native_splash` only.
- Android 12 branding images must be 800×320.

There is no `flutter_launcher_icons.yaml` file — the config is in `pubspec.yaml`; if a stray template file appears in the project root it takes priority and breaks generation, so delete it.

---

## 9. Testing Notes

Run `flutter test`. Existing tests cover login, OTP, verification, duty toggle, order request, pickup, ride, hand over, payment, completed, orders, earnings, alerts, profile, support and environments. Follow the same pattern for new screens:

- Set a phone-sized surface, otherwise the 800×600 default overflows:
  ```dart
  tester.view.physicalSize = const Size(390, 900);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  ```
- Wrap screens that read providers in `ProviderScope`. Override `appConfigProvider` to test an environment.
- Tests render with the wide "Ahem" test font, so long single-line `Row`s can overflow in tests even when fine on a device. Use `Expanded`/`Flexible` for text in rows.
- Avoid `pumpAndSettle()` on screens showing a `PulseDot` (online duty card) — it animates forever. Use `pump(const Duration(seconds: 1))` instead.
- Do not put a `GridView`/scrollable inside `IntrinsicHeight` (it throws). Use `TwoColumnGrid` or a `Column` of `Row`s, as `NumericKeypad` does.

---

## 10. Checklist: Adding a New Screen

1. Create `features/<name>/{data,domain/entities,presentation/screens}` (add `providers/` and `widgets/` if needed).
2. Model the data as an entity in `domain/entities/`; put dummy values in `data/sample_<name>.dart`.
3. Build the screen from `core/widgets/` and the tokens — no raw hex or spacing numbers.
4. Add a `RouteNames` constant and an `AppRouter._screenFor` case (or add a tab in `MainShell`).
5. Add a test in `test/` following section 9.
6. `dart format lib test`, `flutter analyze`, `flutter test`.
7. Update the screens table in section 4 of this doc.
