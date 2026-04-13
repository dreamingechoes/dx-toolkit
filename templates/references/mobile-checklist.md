# Mobile Checklist Reference

Quick-reference for mobile app quality across platforms. Skills reference this checklist when needed.

## App Store Quality

### iOS (App Store)

- [ ] App icon: 1024x1024 with no alpha/transparency
- [ ] Launch screen configured (no static images showing stale UI)
- [ ] Privacy manifest (`PrivacyInfo.xcprivacy`) declares all required reasons APIs
- [ ] `NSUserTrackingUsageDescription` if using IDFA
- [ ] App Transport Security: HTTPS for all network requests
- [ ] Universal links configured for deep linking
- [ ] iPad layout works if app runs on iPad (even if iPhone-only)
- [ ] No private API usage
- [ ] In-app purchases use StoreKit — no external payment links
- [ ] Export compliance: encryption declarations up to date

### Android (Play Store)

- [ ] Target SDK is current year's requirement (targetSdk 34+ for 2024)
- [ ] Adaptive icon configured (foreground + background layers)
- [ ] Data safety section completed in Play Console
- [ ] Permissions are requested in context (not all at launch)
- [ ] ProGuard/R8 rules don't strip required classes
- [ ] 64-bit support for all native libraries
- [ ] App Bundle (AAB) format — not APK
- [ ] Content rating questionnaire completed

## Offline Support

- [ ] App handles no-network gracefully (show cached data, not crash)
- [ ] Network requests have timeouts configured
- [ ] Retry logic with exponential backoff for failed requests
- [ ] Optimistic UI updates where appropriate
- [ ] Sync conflicts are handled (last-write-wins, merge, or prompt user)
- [ ] Downloaded content is stored in appropriate directory (cache vs persistent)

## Deep Linking

- [ ] Universal Links (iOS) / App Links (Android) configured and verified
- [ ] Fallback to web for uninstalled app users
- [ ] Deep link handler validates and sanitizes all parameters
- [ ] Analytics tracks deep link sources
- [ ] Deferred deep linking for new install flows (optional)

## Push Notifications

- [ ] Permission requested at a meaningful moment (not on first launch)
- [ ] Notification payload is small (< 4KB)
- [ ] Silent push for background data sync
- [ ] Notification channels configured (Android) with appropriate importance
- [ ] Badge count management (increment/clear)
- [ ] Deep link in notification opens correct screen
- [ ] Handle notification when app is: foreground, background, killed

## Performance

- [ ] Cold start time < 2 seconds
- [ ] Smooth scrolling: 60fps in lists (no frame drops)
- [ ] Images are properly sized and cached (not loading full-res for thumbnails)
- [ ] Memory usage stays within platform guidance
- [ ] No battery drain from background tasks or location tracking
- [ ] Bundle size: monitor growth, use code splitting where possible
- [ ] Network requests are batched and use compression

## Accessibility

- [ ] VoiceOver (iOS) / TalkBack (Android) reads all interactive elements
- [ ] Touch targets are at least 44×44pt (iOS) / 48×48dp (Android)
- [ ] Dynamic type / font scaling is supported
- [ ] Color is not the only way to convey information
- [ ] Animations respect reduced motion settings
- [ ] Screen reader navigation order is logical

## Security

- [ ] Sensitive data uses Keychain (iOS) / Keystore (Android), not UserDefaults/SharedPreferences
- [ ] Certificate pinning for critical API endpoints
- [ ] Jailbreak/root detection for sensitive apps (financial, health)
- [ ] No sensitive data in logs or crash reports
- [ ] Biometric authentication for sensitive operations
- [ ] App data excluded from backups if it contains sensitive information
- [ ] WebView only loads trusted domains

## Testing

- [ ] Unit tests cover business logic
- [ ] UI tests cover critical user paths (login, purchase, core feature)
- [ ] Tested on physical devices (not just simulators)
- [ ] Tested on oldest supported OS version
- [ ] Tested on smallest supported screen size
- [ ] Tested in airplane mode / poor network (Charles Proxy, Network Link Conditioner)
- [ ] Screenshot tests for critical UI states
- [ ] Tested with system dark mode and light mode
