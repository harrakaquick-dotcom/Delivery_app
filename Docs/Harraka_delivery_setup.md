# Harraka Agent — Flutter Project Structure & Theme Reference

## 1. Tech Stack

- **Framework:** Flutter (Dart, SDK ^3.10)
- **Architecture:** Feature-first + Clean Architecture layering (data / domain / presentation)
- **State Management:** Riverpod (`flutter_riverpod ^2.6.1`) — `StateNotifier` + `StateNotifierProvider`
- **Networking:** Dio (`dio ^5.7.0`) — `api_client.dart` + interceptors
- **Local storage:** `shared_preferences` (no Hive, no codegen / build_runner)
- **Routing:** plain `MaterialApp.onGenerateRoute` + `RouteNames` constants (no go_router / auto_route)
- **Formatting:** `intl`
- **Dev tools:** `flutter_lints`, `flutter_launcher_icons`, `flutter_native_splash`
- **Backend:** <PostgreSQL / Firebase / REST — fill in>

---

## 2. Folder Structure

```
<app_name>/
├── android/
├── ios/
├── assets/
│   ├── images/
│   ├── icons/
│   ├── fonts/
│   └── lottie/
├── lib/
│   ├── main.dart                       # ProviderScope(child: <AppName>App())
│   ├── app.dart                        # MaterialApp root, theme injection, routing
│   │
│   ├── core/
│   │   ├── constants/
│   │   │   ├── app_colors.dart         # <-- theme color tokens (see section 3)
│   │   │   ├── app_text_styles.dart
│   │   │   ├── app_spacing.dart
│   │   │   └── app_strings.dart
│   │   ├── theme/
│   │   │   ├── app_theme.dart          # ThemeData built from tokens
│   │   │   └── theme_extension.dart
│   │   ├── network/
│   │   │   ├── api_client.dart
│   │   │   ├── api_endpoints.dart
│   │   │   └── interceptors/
│   │   │       └── auth_interceptor.dart
│   │   ├── error/
│   │   │   ├── failures.dart
│   │   │   └── exceptions.dart
│   │   ├── utils/
│   │   │   ├── validator/              # name, number, email validators
│   │   │   ├── formatters.dart         # currency, date, distance
│   │   │   └── extensions/
│   │   ├── routing/
│   │   │   ├── app_router.dart
│   │   │   └── route_names.dart
│   │   └── widgets/                    # shared/reusable dumb widgets
│   │       ├── app_button.dart
│   │       ├── app_text_field.dart
│   │       ├── app_bottom_sheet.dart
│   │       ├── shimmer_loader.dart
│   │       └── empty_state.dart
│   │
│   ├── features/
│   │   ├── splash/
│   │   ├── onboarding/
│   │   ├── auth/
│   │   │   ├── data/
│   │   │   │   ├── models/
│   │   │   │   └── repositories/
│   │   │   ├── domain/
│   │   │   │   ├── entities/
│   │   │   │   └── usecases/
│   │   │   └── presentation/
│   │   │       ├── screens/            # login, signup, otp
│   │   │       ├── widgets/
│   │   │       └── providers/
│   │   ├── <feature_1>/                # <list your features here>
│   │   ├── <feature_2>/
│   │   └── <feature_3>/
│   │
│   ├── l10n/                           # localization (if multi-language)
│   └── config/
│       ├── env/
│       │   ├── dev.dart
│       │   ├── staging.dart
│       │   └── prod.dart
│       └── app_config.dart
│
├── test/
│   ├── features/
│   └── core/
├── pubspec.yaml
└── README.md
```

**Rules for the agent:**
- Every `feature/` folder follows the same 3-layer pattern: `data/`, `domain/`, `presentation/`.
- No feature imports another feature's internals directly — share via `core/` only.
- All colors, text styles, and spacing must be pulled from `core/constants/`, never hardcoded inside widgets.
- Every new screen lives in `features/<name>/presentation/screens/`, gets a constant in `RouteNames`, and a case in `AppRouter.onGenerateRoute`.
- Screen-specific widgets go in that feature's `presentation/widgets/`; widgets used by 2+ features go in `core/widgets/`.
- Demo phase: no real backend — use static `sample_*.dart` data in `features/<x>/data/` + a Riverpod provider. Keep `domain/entities/` separate so a repository can replace it later.
- Add a short `///` doc comment above every class. Utility classes use a private constructor (`Xyz._()`).
- Use `const` constructors wherever possible. Files are `snake_case`, classes are `PascalCase`.

---

## 3. Theme Data (Design Tokens)

**Brand direction:** fast, confident, rider-friendly — Harraka red primary on a warm off-white base, soft rounded cards, green reserved for delivered/verified states, ink (`#1A1A1A`) for the offline duty card and chat bubbles.

### Color Palette

| Token | Hex | Usage |
|---|---|---|
| `primary` | `#EC3013` | Brand color, CTAs, order-request screen, online duty card |
| `primaryDark` | `#B8301A` | Pressed states, active tab icon/label, text on `primaryLight` |
| `primaryLight` | `#FDEDE9` | Active tab bg, step chips, streak card, badges |
| `secondary` (success) | `#157A41` | Delivered, verified, call button, checked count |
| `secondaryLight` | `#E6F7ED` | Verified chips, delivered time chips, rating pill |
| `warning` | `#F5A623` | Low stock, delay notices |
| `warningText` | `#8A5A06` | Text on `warningLight` ("In review") |
| `warningLight` | `#FDF3E0` | In-review document chips |
| `error` | `#D93A3A` | Form errors, failures |
| `ink` | `#1A1A1A` | Offline duty card, completed header, agent chat bubble |
| `textPrimary` | `#1A1A1A` | Headings, primary body text |
| `textSecondary` | `#6B6B6B` | Subtext, captions, timestamps |
| `textTertiary` | `#8A8683` | Timestamps on warm surfaces |
| `textDisabled` | `#B0B0B0` | Disabled labels |
| `background` | `#FAF9F8` | Screen background (warm off-white) |
| `card` | `#FFFFFF` | Cards, list rows, inputs |
| `surface` | `#F4F2F1` | Keypad keys, summary strips, secondary panels |
| `surfaceMuted` | `#EFEDEC` | Disabled CTA bg, segmented control track |
| `border` | `#EEEBE9` | Card outlines |
| `borderStrong` | `#E8E5E3` | Buttons, inputs, OTP boxes |
| `overlay` | `#000000` @ 40% opacity | Bottom sheet / modal scrim |

### `app_colors.dart` (reference implementation)

```dart
import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color primary = Color(0xFFEC3013);
  static const Color primaryDark = Color(0xFFB8301A);
  static const Color primaryLight = Color(0xFFFDEDE9);

  static const Color secondary = Color(0xFF157A41);
  static const Color secondaryLight = Color(0xFFE6F7ED);

  static const Color warning = Color(0xFFF5A623);
  static const Color warningText = Color(0xFF8A5A06);
  static const Color warningLight = Color(0xFFFDF3E0);
  static const Color error = Color(0xFFD93A3A);

  static const Color ink = Color(0xFF1A1A1A);
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF6B6B6B);
  static const Color textTertiary = Color(0xFF8A8683);
  static const Color textDisabled = Color(0xFFB0B0B0);

  static const Color background = Color(0xFFFAF9F8);
  static const Color card = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFFF4F2F1);
  static const Color surfaceMuted = Color(0xFFEFEDEC);
  static const Color border = Color(0xFFEEEBE9);
  static const Color borderStrong = Color(0xFFE8E5E3);

  /// Soft red glow under primary CTAs (26% primary).
  static const Color primaryShadow = Color(0x42EC3013);

  static const Color overlayScrim = Color(0x66000000); // 40% black
}
```

### Typography

| Style | Size | Weight | Usage |
|---|---|---|---|
| `displayLarge` | 44 | SemiBold | Big amounts (KES 1,240), countdown |
| `displayMedium` | 27 | SemiBold | Onboarding / screen headlines |
| `headingLarge` | 22 | SemiBold | Screen titles |
| `headingMedium` | 16 | SemiBold | Card titles, instructions |
| `label` | 11 | SemiBold, +0.1em, uppercase | Section labels |
| `bodyLarge` | 15 | Regular | Primary text |
| `bodyMedium` | 14 | Regular | Descriptions, secondary text |
| `caption` | 12 | Regular | Timestamps, labels |
| `button` | 16 | SemiBold | Button labels |

Font: **Archivo** (Google Fonts) — same as the demo. Weights: 400 Regular (body), 600 SemiBold (headings, labels, buttons). Headings use tight tracking (−0.02em); uppercase section labels use 11px / 600 / +0.1em tracking in `textSecondary`.

```yaml
# pubspec.yaml
fonts:
  - family: Archivo
    fonts:
      - asset: assets/fonts/Archivo-Regular.ttf
      - asset: assets/fonts/Archivo-SemiBold.ttf
        weight: 600
```

### Spacing Scale (`app_spacing.dart`)

```dart
class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;
}
```

### Radius & Elevation

| Token | Value | Usage |
|---|---|---|
| `radiusSmall` | 14 | Icon tiles, small buttons |
| `radiusMedium` | 18 | Primary CTAs, inputs, keypad keys |
| `radiusLarge` | 22 | Cards, bottom sheets |
| `radiusXL` | 26 | Duty card, hero cards |
| `radiusPill` | 999 | Chips, segmented controls, toggles |
| `elevationCard` | 2 | Cards |
| `elevationModal` | 8 | Bottom sheets |

### ThemeData Assembly (`app_theme.dart` sketch)

```dart
ThemeData lightTheme = ThemeData(
  primaryColor: AppColors.primary,
  scaffoldBackgroundColor: AppColors.background,
  colorScheme: ColorScheme.light(
    primary: AppColors.primary,
    secondary: AppColors.secondary,
    error: AppColors.error,
    surface: AppColors.surface,
  ),
  fontFamily: 'Archivo',
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.background,
    foregroundColor: AppColors.textPrimary,
    elevation: 0,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
    ),
  ),
);
```

---

## 4. Branding & Assets

| Asset | Path |
|---|---|
| App icon | `assets/icons/<app>_app_icon.png` |
| Splash logo | `assets/icons/<app>_app_splash.png` |
| Branding text | `assets/icons/<app>_text.png` |

- `flutter_launcher_icons`: `android: true`, `ios: true`, `adaptive_icon_background` = primary hex.
- `flutter_native_splash`: `color` = primary hex, `fullscreen: true`, `branding_mode: bottom`, `branding_bottom_padding: 48`.
- Declare `assets/images/`, `assets/icons/`, `assets/lottie/` in `pubspec.yaml`.

---

## 5. Notes for the Agent

1. Scaffold the folder tree exactly as in Section 2 before writing any screen code.
2. Create `app_colors.dart`, `app_text_styles.dart`, `app_spacing.dart` first — every subsequent widget references these, never raw hex/values.
3. Use `secondary` exclusively for positive/success states so it doesn't compete with the primary brand color.
4. Keep `primary` reserved for CTAs and brand moments — don't overuse it across large surfaces.
5. Only a placeholder `SplashScreen` at first (needed as `initialRoute`); build other screens one feature at a time, only when asked.
6. If the doc leaves a choice open, pick the simplest option and mention it in one line.
7. Keep `flutter analyze` and `flutter test` green at every step.
8. Work on a separate feature branch (`features/<name>`); commit only when asked.
