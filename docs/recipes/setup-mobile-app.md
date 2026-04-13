# Setup a Mobile App

Build a React Native (Expo) or Flutter mobile app with the DX Toolkit.

## Two Paths

|                      | React Native + Expo                                                       | Flutter                                       |
| -------------------- | ------------------------------------------------------------------------- | --------------------------------------------- |
| Language             | TypeScript                                                                | Dart                                          |
| Toolkit agents       | `react-native-expert`, `expo-expert`, `react-expert`, `typescript-expert` | `flutter-expert`                              |
| Toolkit instructions | `typescript.instructions.md`, `react.instructions.md`                     | (none auto-attached — Dart not yet covered)   |
| State management     | Zustand, Jotai, or React Query                                            | Riverpod or Bloc                              |
| Navigation           | Expo Router or React Navigation                                           | GoRouter                                      |
| Testing              | Jest + React Native Testing Library + Detox                               | `flutter_test` + `integration_test` + Maestro |

Pick the path that matches your team's skills and project needs.

---

## Path A: React Native with Expo

### Prerequisites

- **Node.js** 18+ and **pnpm** or npm
- **Expo CLI** (`npx expo --version` — comes with `npx`, no global install needed)
- **Xcode** 15+ (iOS) and/or **Android Studio** (Android)
- **Git** repository initialized

### Step 1: Create the Expo Project

```bash
npx create-expo-app@latest my-mobile-app --template default
cd my-mobile-app
git init && git add -A && git commit -m "chore: scaffold expo project"
```

### Step 2: Install the Toolkit

```bash
git clone https://github.com/dreamingechoes/dx-toolkit.git /tmp/dx-toolkit
/tmp/dx-toolkit/scripts/bootstrap.sh .
```

Select:

1. **Editor**: Your choice (VS Code with Copilot, Cursor, etc.)
2. **Project type**: **React Native / Expo**
3. **Extras**: CI/CD Workflows, GitHub Templates

This installs:

| Component    | What you get                                                                                             |
| ------------ | -------------------------------------------------------------------------------------------------------- |
| Agents       | `react-native-expert`, `expo-expert`, `react-expert`, `typescript-expert`, plus 9 general-purpose agents |
| Instructions | `typescript.instructions.md`, `react.instructions.md`                                                    |
| Skills       | All 33+ skills, including `mobile-release` and `mobile-testing`                                          |

Commit:

```bash
git add .github/ CLAUDE.md AGENTS.md
git commit -m "chore: install dx-toolkit for expo project"
```

### Step 3: Build Your First Screen

Use the lifecycle prompts to build a feature — say, a profile screen.

**Explore the idea:**

```
/explore Profile screen that shows user avatar, name, email,
and a settings list. Tapping settings items navigates to sub-screens.
Must look native on both iOS and Android.
```

**Outline the tasks:**

```
/outline Profile screen with: avatar image (with camera/gallery picker),
user info section, settings list with chevron navigation,
pull-to-refresh for updated data.
```

**Develop each slice:**

```
@react-native-expert Create the ProfileScreen component with a
ScrollView layout. Use SafeAreaView, follow platform conventions for
iOS/Android spacing.
```

```
@expo-expert Add image picking for the avatar using expo-image-picker.
Handle both camera and gallery sources with proper permissions.
```

The `react-native-expert` writes platform-aware code:

- `Pressable` instead of `TouchableOpacity`
- `StyleSheet.create()` for styles
- `Platform.select()` for iOS/Android differences
- `SafeAreaView` from `react-native-safe-area-context`

### Step 4: Set Up Mobile Testing

Use the `mobile-testing` skill for a testing strategy:

```
@test-writer Set up testing for the profile screen. I need unit tests
for the data logic, component tests for the UI, and an E2E test for
the full flow.
```

The toolkit's `mobile-testing` skill covers:

- **Unit tests**: Jest for business logic and hooks
- **Component tests**: React Native Testing Library for UI
- **E2E tests**: Detox or Maestro for full device flows
- **Screenshot tests**: Visual regression on key screens

### Step 5: Set Up CI Workflows

```bash
cp templates/workflows/pr-size-checker.yml .github/workflows/
cp templates/workflows/pr-code-reviewer.yml .github/workflows/
cp templates/workflows/conventional-commit-checker.yml .github/workflows/
cp templates/workflows/security-scanner.yml .github/workflows/
```

For Expo-specific CI (builds + tests), add:

```yaml
# .github/workflows/mobile-ci.yml
name: Mobile CI

on:
  pull_request:

jobs:
  test:
    runs-on: ubuntu-latest
    timeout-minutes: 20
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: 20
          cache: 'npm'
      - run: npm ci
      - run: npx expo lint
      - run: npm test -- --coverage
```

### Step 6: App Store Submission

When you're ready to ship, use the `mobile-release` skill:

```
/launch Prepare the app for App Store and Play Store submission.
We're at version 1.0.0.
```

The skill walks you through:

1. Version bumping in `app.json`
2. Build configuration for production (`eas build --platform all`)
3. App Store metadata (screenshots, description, keywords)
4. Play Store listing setup
5. Review guideline checklist (common rejection reasons)
6. Staged rollout plan

---

## Path B: Flutter

### Prerequisites

- **Flutter** 3.22+ (`flutter --version`)
- **Dart** 3.4+ (comes with Flutter)
- **Xcode** 15+ (iOS) and/or **Android Studio** (Android)
- **Git** repository initialized

### Step 1: Create the Flutter Project

```bash
flutter create my_flutter_app
cd my_flutter_app
git init && git add -A && git commit -m "chore: scaffold flutter project"
```

### Step 2: Install the Toolkit

```bash
git clone https://github.com/dreamingechoes/dx-toolkit.git /tmp/dx-toolkit
/tmp/dx-toolkit/scripts/bootstrap.sh .
```

Select:

1. **Editor**: Your choice
2. **Project type**: **Other / Generic** (Flutter isn't a dedicated type yet)
3. **Extras**: CI/CD Workflows, GitHub Templates

Then manually add the Flutter agent:

```bash
cp /tmp/dx-toolkit/templates/agents/flutter-expert.agent.md .github/agents/
git add .github/agents/flutter-expert.agent.md
git commit -m "chore: add flutter-expert agent"
```

### Step 3: Build Your First Screen

```
@flutter-expert Create a ProfileScreen widget with: user avatar (circular),
name and email text, and a ListView of settings items. Use Riverpod
for state management. Follow Material 3 guidelines.
```

The `flutter-expert` writes:

- Small, focused widget classes (no deep nesting in `build()`)
- `const` constructors where possible
- `Riverpod` providers for state
- `GoRouter` for navigation
- Dart 3 patterns (records, sealed classes, pattern matching)

**Add state management:**

```
@flutter-expert Set up Riverpod for the profile feature. Create a
UserProfileNotifier that fetches user data from the API and handles
loading/error/success states.
```

### Step 4: Set Up Flutter Testing

```
@test-writer Write tests for the ProfileScreen. Include widget tests
with flutter_test, a unit test for UserProfileNotifier, and set up
golden tests for visual regression.
```

The `mobile-testing` skill covers Flutter's testing layers:

- **Unit tests**: `test` package for pure logic
- **Widget tests**: `flutter_test` with `pumpWidget`, `find`, `expect`
- **Integration tests**: `integration_test/` for E2E flows
- **Golden tests**: Visual regression on key screens

### Step 5: Set Up CI Workflows

```bash
cp templates/workflows/pr-size-checker.yml .github/workflows/
cp templates/workflows/pr-code-reviewer.yml .github/workflows/
cp templates/workflows/security-scanner.yml .github/workflows/
```

Add Flutter-specific CI:

```yaml
# .github/workflows/flutter-ci.yml
name: Flutter CI

on:
  pull_request:

jobs:
  test:
    runs-on: ubuntu-latest
    timeout-minutes: 15
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.22.0'
          channel: 'stable'
          cache: true

      - run: flutter pub get
      - run: dart analyze
      - run: dart format --set-exit-if-changed .
      - run: flutter test --coverage
```

### Step 6: App Store Submission

Same as React Native — use the `mobile-release` skill:

```
/launch Prepare the Flutter app for store submission at version 1.0.0.
```

The skill covers:

1. Version bumping in `pubspec.yaml`
2. Build configuration (`flutter build appbundle`, `flutter build ipa`)
3. App signing (keystore for Android, provisioning profiles for iOS)
4. Store metadata and screenshots
5. Review guideline compliance
6. Staged rollout plan

---

## What's Installed (Quick Reference)

### React Native / Expo

| Component              | Purpose                                                |
| ---------------------- | ------------------------------------------------------ |
| `react-native-expert`  | RN 0.77+, New Architecture, platform-specific patterns |
| `expo-expert`          | Expo SDK, EAS Build, Expo Router                       |
| `react-expert`         | React patterns, hooks, composition                     |
| `typescript-expert`    | Type safety across the codebase                        |
| `mobile-release` skill | App Store / Play Store submission process              |
| `mobile-testing` skill | Unit, component, E2E, screenshot testing               |

### Flutter

| Component              | Purpose                                           |
| ---------------------- | ------------------------------------------------- |
| `flutter-expert`       | Flutter 3.22+, Dart 3.4+, Riverpod/Bloc, GoRouter |
| `mobile-release` skill | Store submission process                          |
| `mobile-testing` skill | Widget tests, integration tests, golden tests     |

## Troubleshooting

**Expo agent doesn't understand my config?** Make sure `app.json` or `app.config.ts` exists at the project root. The agent reads this for SDK version and configuration.

**Flutter agent suggests old patterns?** The `flutter-expert` targets Flutter 3.22+ and Dart 3.4+. If you're on an older version, mention it explicitly.

**E2E tests flaky on CI?** Mobile E2E tests need emulators/simulators. Use `macos-latest` runners for iOS simulators, `ubuntu-latest` with Android emulator action for Android. Increase timeout to 30+ minutes.

**EAS Build failing?** Check that your `eas.json` configuration matches your Apple/Google credentials. Run `eas build --platform ios --local` first to debug locally.
