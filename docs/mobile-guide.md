# 📱 Mobile Development Guide

How to use the toolkit for mobile app development across React Native, Flutter, Swift, Kotlin, and Expo.

## Supported Stacks

| Stack            | Agent                 | Instruction                                           | Use When                      |
| ---------------- | --------------------- | ----------------------------------------------------- | ----------------------------- |
| React Native     | `react-native-expert` | `react.instructions.md`, `typescript.instructions.md` | Cross-platform JS/TS apps     |
| Expo             | `expo-expert`         | `react.instructions.md`, `typescript.instructions.md` | Managed React Native workflow |
| Flutter          | `flutter-expert`      | —                                                     | Cross-platform Dart apps      |
| Swift / iOS      | `swift-expert`        | `swift.instructions.md`                               | Native iOS/macOS apps         |
| Kotlin / Android | `kotlin-expert`       | `kotlin.instructions.md`                              | Native Android apps           |

## Relevant Agents

### react-native-expert

Knows React Native internals, navigation (React Navigation, Expo Router), state management, native modules, and platform-specific code.

```
@react-native-expert Set up deep linking for our app
@react-native-expert Fix the FlatList performance issue on Android
```

### expo-expert

Specializes in Expo's managed workflow: EAS Build, EAS Update, Expo Router, Expo modules, and configuration.

```
@expo-expert Configure EAS Build for production
@expo-expert Migrate from Expo Go to a development build
```

### flutter-expert

Covers Dart, Flutter widgets, state management (Riverpod, Bloc, Provider), platform channels, and Flutter-specific testing.

```
@flutter-expert Implement a responsive layout with Riverpod state management
@flutter-expert Add platform channel for native camera access
```

### swift-expert

Handles SwiftUI, UIKit, iOS/macOS, Combine, Swift Concurrency (async/await, actors), and App Store guidelines.

```
@swift-expert Convert this UIKit view controller to SwiftUI
@swift-expert Add Core Data persistence with CloudKit sync
```

### kotlin-expert

Covers Jetpack Compose, Kotlin Coroutines, Android architecture (MVVM, MVI), Room, and Kotlin Multiplatform.

```
@kotlin-expert Refactor this Activity to use Jetpack Compose
@kotlin-expert Set up Kotlin Multiplatform for shared business logic
```

## Relevant Skills

### mobile-release

Walks you through the store submission process:

1. Version bumping and build number management
2. Build configuration (signing, provisioning, keystore)
3. Store metadata preparation (screenshots, descriptions, keywords)
4. Submission and review process
5. OTA update setup (Expo Updates, CodePush)
6. Post-release monitoring

Invoke it:

```
@react-native-expert Use the mobile-release skill to prepare our app for the App Store
```

### mobile-testing

Guides you through mobile testing strategy:

1. Unit testing (Jest, XCTest, JUnit)
2. Component/widget testing
3. Integration testing
4. E2E testing with Detox or Maestro
5. Screenshot/snapshot testing
6. Device farm testing (AWS Device Farm, Firebase Test Lab)

Invoke it:

```
@expo-expert Use the mobile-testing skill to set up our test suite
```

## Relevant References

### mobile-checklist

A quality checklist for mobile apps covering:

- **App Store readiness** — Icons, splash screens, store listing metadata
- **Offline support** — Network state handling, data persistence, queue management
- **Deep linking** — URL schemes, universal links, deferred deep links
- **Push notifications** — Token management, permission handling, rich notifications
- **Performance** — Startup time, frame rate, memory usage, battery impact
- **Accessibility** — VoiceOver/TalkBack, dynamic type, touch targets

Reference this checklist before any release:

```
@react-native-expert Review our app against the mobile-checklist reference
```

## Example: React Native Feature Workflow

Here's how to use agents and skills together to build a feature in a React Native app.

### Scenario: Add a User Profile Screen

#### Step 1: Explore

```
@react-native-expert /explore

I need to add a user profile screen that shows:
- Avatar, name, email
- Edit profile button
- Settings list (notifications, privacy, theme)
- Sign out button

We use Expo Router for navigation, Zustand for state, and NativeWind for styling.
```

The agent explores the codebase, identifies existing patterns, and proposes an approach.

#### Step 2: Outline

```
@react-native-expert /outline

Break the profile screen feature into tasks based on the exploration above.
```

You get ordered tasks like:

1. Create profile screen component
2. Add navigation route
3. Add profile data hook
4. Build the settings list
5. Wire up edit profile flow
6. Add tests

#### Step 3: Develop

```
@react-native-expert /develop

Implement task 1: Create the profile screen component.
Follow the existing component patterns in our codebase.
```

The agent implements each task as a thin vertical slice — code, tests, commit.

#### Step 4: Check

```
@react-native-expert /check

The profile screen crashes on Android when the user has no avatar URL set.
```

The agent diagnoses, fixes, and adds a regression test.

#### Step 5: Polish

```
@react-native-expert /polish

Review the profile screen for performance and accessibility:
- Check FlatList rendering for the settings list
- Verify VoiceOver/TalkBack labels
- Check for unnecessary re-renders
```

#### Step 6: Launch

```
@react-native-expert /launch

Prepare the profile screen for release:
- Write the PR description
- Update any relevant documentation
- Check the mobile-checklist reference
```

## App Store Deployment Summary

When you're ready to submit to the App Store or Google Play, use the `mobile-release` skill:

```
@expo-expert Use the mobile-release skill to prepare our v2.1.0 release
```

### iOS App Store Checklist

- [ ] Version and build number incremented
- [ ] Signing certificate and provisioning profile configured
- [ ] App icons (1024x1024 + all required sizes)
- [ ] Launch screen configured
- [ ] Privacy manifest (`PrivacyInfo.xcprivacy`) updated
- [ ] App Store Connect metadata (description, keywords, screenshots)
- [ ] App Review information filled out
- [ ] Export compliance (encryption usage declared)

### Google Play Console Checklist

- [ ] Version code incremented
- [ ] Signing key configured (Play App Signing recommended)
- [ ] App icon (512x512 adaptive icon)
- [ ] Feature graphic (1024x500)
- [ ] Store listing (description, screenshots for phone + tablet)
- [ ] Content rating questionnaire completed
- [ ] Data safety section filled out
- [ ] Target API level meets Google Play requirements

### Shared

- [ ] Release notes written for both stores
- [ ] Crash-free rate from previous release above threshold
- [ ] Analytics events verified in staging
- [ ] Push notification tokens migrated (if changing providers)
- [ ] Deep links tested end-to-end
- [ ] Forced update logic configured (if needed)

## Tips

- **Use platform-specific agents** when you need deep native knowledge. Use `react-native-expert` or `expo-expert` for cross-platform issues.
- **The mobile-testing skill** helps you set up the right test pyramid — don't skip E2E tests for critical flows.
- **Check the mobile-checklist** reference before every release, not just the first one.
- **For Expo projects**, prefer `expo-expert` over `react-native-expert` — it understands Expo's managed workflow and won't suggest ejecting unnecessarily.
- **Kotlin Multiplatform and Flutter** can share business logic across platforms. The `kotlin-expert` and `flutter-expert` agents understand these patterns.
