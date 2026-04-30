# BeerHopper iOS Validation Plan

## Review Checklist For This Planning PR

- The app direction is SwiftUI-first and Apple-native.
- The app targets iOS 26+ and is Liquid Glass compatible.
- The existing repo is reused, but the stale project is restarted rather than patched incrementally.
- The plan forbids external libraries and uses Apple frameworks only.
- SwiftLint is accepted as a development-only quality tool and must enforce explicit `self.`.
- The app architecture is MVVM.
- BeerHopper-owned service singletons are avoided in favor of dependency injection.
- API, data, secure, analytics, realtime, feature flag, clock, and notification dependencies are injectable where practical.
- Responsive columnar layouts are part of the design system.
- The plan notes Swift-for-Android as a long-term goal while keeping iOS UI fully native.
- The design language matches BeerHopper brand tokens without copying web layout.
- Architecture separates app shell, design, API, data, secure, analytics, realtime, and feature layers.
- MVP scope is narrow enough to ship.
- Privacy, auth, permissions, and feature flags are represented early.
- Deep links align with web routes.
- Analytics aligns with the web event contract.

## Implementation PR Gates

Every implementation PR should document:

- Scope and affected modules.
- Screens or flows changed.
- API endpoints touched.
- Confirmation that no external libraries were added.
- SwiftLint results and any rule suppressions.
- Confirmation that `self.` is used where available in touched Swift code.
- Confirmation that touched dependencies are injected rather than singleton accessed.
- Confirmation that previews/tests can substitute fakes for touched IO boundaries.
- MVVM boundaries touched.
- Shared-core versus iOS-only boundary impact.
- Liquid Glass/material surface impact and solid fallback behavior.
- Feature flags or server capability checks.
- Analytics events added or changed.
- Accessibility checks performed.
- Tests run.
- Screenshots or screen recordings for UI changes.

## Test Matrix

### Unit Tests

- Request construction and headers.
- Response decoding.
- Domain mapping.
- View model state transitions.
- Route/deep-link resolution.
- Feature flag defaults.
- Analytics consent gate.

### Integration Tests

- Session restore with Keychain test double.
- Auth refresh after expired token.
- Search pagination.
- Forum create/comment/react.
- Brew session realtime patch application.
- API error taxonomy.

### UI Tests

- Launch signed out.
- Browse public content.
- Search and open result.
- Sign in and restore session.
- Open forum post and react.
- Open active brew session.
- Navigate to privacy settings.

### Accessibility Checks

- Dynamic Type from XS through accessibility sizes.
- VoiceOver labels on rows, metric tiles, timers, and destructive controls.
- High contrast light and dark.
- Liquid Glass/material surfaces with bright, dark, and image-heavy content behind them.
- Columnar layout behavior across compact, regular, and expanded widths.
- Reduce motion.
- Color-blind safe status indicators.

### Device Coverage

- Current small iPhone.
- Current standard iPhone.
- Current Pro Max size.
- iPad compatibility decision: either intentionally supported or explicitly excluded in project settings.

## Release Readiness

Before TestFlight:

- Remove sample credentials and debug-only login paths.
- Confirm staging and production build configurations.
- Confirm universal links and associated domains.
- Confirm privacy nutrition label inputs.
- Confirm analytics and crash reporting consent behavior.
- Confirm API rate limits and mobile user agent observability.
- Confirm app icon, launch screen, display name, and bundle IDs.
- Confirm support URL, privacy URL, and terms URL.

Before App Store:

- TestFlight feedback triaged.
- No known P0/P1 crashes.
- Auth/session restore verified across app upgrade.
- Private data cache behavior reviewed.
- Push notification copy and payload privacy reviewed if enabled.
- Legal and policy review for alcohol-related content and age expectations.
