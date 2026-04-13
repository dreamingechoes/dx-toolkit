---
name: mobile-release
description: 'App Store and Play Store submission process. Covers versioning, build configuration, metadata, screenshots, review guidelines, and OTA updates.'
---

# Mobile Release

## Overview

Shipping a mobile app is not like shipping a web app. You don't control the deployment pipeline — Apple and Google do. A bad release means waiting days for review, or worse, getting rejected and starting over. This skill covers the end-to-end process: version bumping, build configuration, store metadata, screenshot generation, submission, review monitoring, and over-the-air (OTA) updates for when you need to ship a fix without going through the store again.

The goal is a repeatable, automated release process where cutting a release is a one-command operation, not a two-day manual checklist.

## When to Use

- Preparing a new version for App Store or Play Store submission
- Setting up release automation for the first time (Fastlane, EAS)
- Configuring OTA updates (CodePush, EAS Updates)
- Dealing with a store rejection and planning resubmission
- Planning a phased rollout or beta distribution

**When NOT to use:** Internal-only builds that never touch the stores, or web-only projects. For CI/CD pipeline setup without store submission, use the `ci-cd-and-automation` skill instead.

## Process

### Step 1 — Version Bump

Mobile apps have two version identifiers. Confusing them is the most common release mistake.

**Version identifiers:**

| Platform | User-Visible Version         | Build Number                              |
| -------- | ---------------------------- | ----------------------------------------- |
| iOS      | `CFBundleShortVersionString` | `CFBundleVersion`                         |
| Android  | `versionName`                | `versionCode`                             |
| RN/Expo  | `version` in app.json        | `ios.buildNumber` / `android.versionCode` |

**Rules:**

- **Version** follows semver: `MAJOR.MINOR.PATCH` (e.g., `2.4.1`)
  - MAJOR: breaking changes or major redesigns
  - MINOR: new features
  - PATCH: bug fixes
- **Build number** is monotonically increasing (never reuse, never decrease)
  - iOS: can be any string, but integers are simplest (`142`, `143`)
  - Android: must be an integer, and each upload must be strictly greater than the last

**Version bump script example:**

```bash
#!/bin/bash
# bump-version.sh <major|minor|patch>
CURRENT=$(jq -r '.version' app.json)
NEXT=$(npx semver $CURRENT -i $1)
BUILD=$(($(jq -r '.expo.ios.buildNumber' app.json | tr -d '"') + 1))

jq --arg v "$NEXT" --arg b "$BUILD" \
  '.version = $v | .expo.ios.buildNumber = ($b|tostring) | .expo.android.versionCode = ($b|tonumber)' \
  app.json > tmp.json && mv tmp.json app.json

echo "Bumped to $NEXT (build $BUILD)"
```

### Step 2 — Configure Build

Separate build configuration from code. Never hardcode API URLs or feature flags.

**Environment configuration:**

```
Build Variants:
  development → dev API, debug logging, dev signing
  staging     → staging API, analytics enabled, ad-hoc signing
  production  → prod API, analytics + crash reporting, store signing
```

**EAS Build (Expo/React Native):**

```json
// eas.json
{
  "build": {
    "development": {
      "distribution": "internal",
      "env": { "API_URL": "https://api.dev.example.com" }
    },
    "staging": {
      "distribution": "internal",
      "env": { "API_URL": "https://api.staging.example.com" }
    },
    "production": {
      "distribution": "store",
      "env": { "API_URL": "https://api.example.com" },
      "autoIncrement": true
    }
  }
}
```

**Fastlane (native iOS/Android):**

```ruby
# fastlane/Fastfile
platform :ios do
  lane :release do
    increment_build_number
    build_app(scheme: "MyApp", export_method: "app-store")
    upload_to_app_store(skip_metadata: false, skip_screenshots: false)
  end
end

platform :android do
  lane :release do
    gradle(task: "bundleRelease")
    upload_to_play_store(track: "internal")
  end
end
```

**Signing checklist:**

- [ ] iOS: distribution certificate and provisioning profile are valid and not expiring soon
- [ ] Android: upload key is stored securely (not in git), Google Play signing is enabled
- [ ] Credentials are in CI secrets, not on developer machines

### Step 3 — Generate Screenshots

Store screenshots are marketing — they determine whether someone downloads your app.

**Screenshot requirements:**

| Store      | Required Sizes                                 | Min Count                  |
| ---------- | ---------------------------------------------- | -------------------------- |
| App Store  | 6.7" (iPhone 15 Pro Max), 6.5", 5.5", iPad Pro | 1 per size (3 recommended) |
| Play Store | Phone (16:9), 7" tablet, 10" tablet            | 2 minimum (8 recommended)  |

**Automated screenshot generation (Fastlane Snapshot / Screengrab):**

```ruby
# fastlane/Snapfile (iOS)
devices([
  "iPhone 15 Pro Max",
  "iPhone 15",
  "iPad Pro (12.9-inch) (6th generation)"
])
languages(["en-US", "es-ES", "ja"])
scheme("MyAppUITests")
output_directory("./screenshots")
```

**Tips:**

- Automate screenshots in CI — regenerate on every release
- Use real data, not "Lorem ipsum" — fake data makes apps look unfinished
- Put the most compelling screen first — most users only see the first 2-3
- Add marketing text overlays with Fastlane Frameit

### Step 4 — Write Metadata

Metadata is the store listing content: title, description, keywords, what's new.

**App Store metadata:**

```
Name: [30 chars max]
Subtitle: [30 chars max]
Description: [4000 chars max — first 3 lines visible without expand]
Keywords: [100 chars, comma-separated — research competitors]
What's New: [specific changes, not "bug fixes and improvements"]
Category: [primary + secondary]
```

**Play Store metadata:**

```
Title: [30 chars max]
Short description: [80 chars max]
Full description: [4000 chars max]
What's new: [500 chars max]
Category + tags
```

**"What's New" rules:**

- Be specific: "Fixed crash when opening photos on iPad" not "Bug fixes"
- Lead with the most interesting change
- Keep it under 10 lines — nobody reads a novel
- Use plain language — no jargon

### Step 5 — Submit to Store

**App Store Connect submission:**

```bash
# Fastlane
fastlane ios release

# EAS Submit
eas submit --platform ios --profile production

# Manual: Xcode → Product → Archive → Distribute App → App Store Connect
```

**Common rejection reasons (Apple):**

- Incomplete metadata or placeholder screenshots
- Crashes or bugs discovered during review
- Missing privacy policy or data collection disclosures
- Requesting permissions without justifying why (camera, location, contacts)
- In-app purchases that bypass Apple's payment (use StoreKit)

**Google Play Console submission:**

```bash
# Fastlane
fastlane android release

# EAS Submit
eas submit --platform android --profile production
```

**Common rejection reasons (Google):**

- Targeting outdated API level (must target latest or latest-1)
- Missing data safety section declarations
- Deceptive behavior or misleading descriptions
- Violation of Families Policy (if targeting children)

### Step 6 — Monitor Review

**Typical review timelines:**

- App Store: 24-48 hours (can be longer for first submission or after rejection)
- Play Store: hours to 3 days (automated review + occasional manual)

**If rejected:**

1. Read the rejection reason carefully — Apple provides specific guideline numbers
2. Fix the exact issue cited — don't change other things
3. Reply to the reviewer in Resolution Center (App Store) explaining the fix
4. Resubmit — don't submit a new version, update the existing one

**Expedited review (Apple):**

- Available for critical bug fixes
- Request at https://developer.apple.com/contact/app-store/?topic=expedite
- Don't abuse it — Apple tracks frequency

### Step 7 — Plan OTA Updates

OTA (over-the-air) updates push JavaScript/asset changes without a store review. Use them for bug fixes — not for new native features.

**OTA update options:**

| Tool        | Platform     | Scope                    |
| ----------- | ------------ | ------------------------ |
| EAS Updates | Expo/RN      | JS + assets              |
| CodePush    | React Native | JS + assets (deprecated) |
| Shorebird   | Flutter      | Dart code                |

**EAS Updates setup:**

```bash
# Configure update channels matching build profiles
eas update:configure

# Publish an update
eas update --branch production --message "Fix checkout crash on Android"
```

**OTA update rules:**

- Never push native code changes via OTA (will crash)
- Test OTA updates on staging before production
- Keep a rollback plan — publish a revert update
- Both Apple and Google allow OTA for JS bundle updates, but prohibit changing app behavior in ways that bypass review
- Version your update channels to match your build versions

**Phased rollout strategy:**

```
Day 1: 1% of users (canary)
Day 2: 10% (if no crash spike)
Day 3: 25%
Day 5: 50%
Day 7: 100%
```

Both App Store and Play Store support phased rollouts natively. Use them for every major release.

## Common Rationalizations

| Rationalization                                 | Reality                                                                                                |
| ----------------------------------------------- | ------------------------------------------------------------------------------------------------------ |
| "We'll do screenshots manually — it's faster"   | It's faster once. You'll do it 50+ times over the app's life. Automate.                                |
| "What's New: Bug fixes and improvements"        | Users and reviewers both hate this. Be specific or don't ship release notes.                           |
| "We'll just push an OTA update if it's broken"  | OTA only works for JS changes. Native crashes need a full store release.                               |
| "We don't need phased rollout for a small fix"  | Small fixes have caused big outages. Rolling out to 1% first costs nothing.                            |
| "We can skip the staging build"                 | The staging build is where you catch the "works on my machine" bugs before Apple catches them for you. |
| "Build numbers don't matter — they're internal" | Reusing or decrementing a build number will get your upload rejected instantly.                        |

## Red Flags

- Version and build number bumped by hand instead of scripts
- Signing keys stored in the git repository
- No staging build — going straight from development to production
- "Bug fixes and improvements" as the only release notes
- OTA updates pushed to production without staging verification
- Skipping phased rollout for major releases
- No automated screenshot generation (manual screenshots get stale)
- App Store privacy declarations don't match actual data collection

## Verification

- [ ] Version follows semver and build number is monotonically increasing
- [ ] Build is created from CI/CD, not from a developer's machine
- [ ] Signing credentials are in CI secrets, not in the repository
- [ ] Screenshots are generated automatically for all required device sizes
- [ ] Store metadata is complete with specific "What's New" text
- [ ] Privacy declarations match actual data collection
- [ ] Submission targets the correct track (internal/beta/production)
- [ ] Phased rollout is configured for production releases
- [ ] OTA update channel matches the production build version
- [ ] Rollback plan exists (either store rollback or OTA revert)
