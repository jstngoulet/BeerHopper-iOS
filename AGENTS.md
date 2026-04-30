# AGENTS.md - BeerHopper iOS

Purpose: keep iOS changes aligned with the BeerHopper product, API, and web design language while still feeling native to Apple platforms.

## Source Of Truth

- iOS planning docs: `docs/ios/`
- Web product requirements: sibling repo `../BeerHopper - Web/docs/wiki/product/requirements_overview.md`
- Web domain requirements: sibling repo `../BeerHopper - Web/docs/wiki/requirements/README.md`
- Web architecture: sibling repo `../BeerHopper - Web/docs/wiki/architecture/system_overview.md`
- Web analytics contract: sibling repo `../BeerHopper - Web/docs/wiki/analytics/events.md`
- API implementation and contracts: sibling repo `../BeerHopper - API`

If iOS behavior conflicts with product requirements, align the app to product docs or update the docs in the same change.

## Product Rules

- Server remains the source of truth for auth, permissions, brewery membership, plan gates, and private content.
- Public views are read-only and must not expose member controls.
- Private breweries, private recipes, and private brew sessions must not leak data through previews, caches, widgets, push payloads, or deep links.
- New user-facing features must be planned behind a feature flag or server capability check before implementation.
- Keep web and iOS routes semantically aligned so shared links can open on web or deep link into the app.

## Design Rules

- Target iOS 26+ and make the app Liquid Glass compatible.
- Use SwiftUI and native Apple navigation, sheets, lists, forms, menus, swipe actions, haptics, Dynamic Type, SF Symbols, and system materials.
- Prefer platform Liquid Glass/system material behavior over custom glass effects, with solid fallbacks for dense data and accessibility.
- Use columnar layouts for iOS 26+ responsive surfaces where content benefits from side-by-side structure, especially iPad, large iPhone landscape, dashboards, brew-day metrics, and management screens.
- Mirror BeerHopper brand tokens and domain vocabulary, but do not copy web layouts directly.
- Prefer dense, scan-friendly operational screens for brew sessions, recipes, and brewery management.
- Use the design system package for colors, typography, spacing, components, and state styles.
- Support light, dark, high contrast, Dynamic Type, reduced motion, and VoiceOver from the first implementation.

## Architecture Rules

- Restart stale implementation work in the existing repo when approved; do not preserve old app structure by default.
- No external libraries. Use Apple frameworks and first-party code only.
- SwiftLint is allowed as a development-time linting tool exception and should be configured in-repo.
- Use `self.` whenever it is available; the lint configuration should require explicit self and not warn it away.
- Use MVVM throughout: SwiftUI views, observable view models, domain/API models, repositories/services for IO.
- Avoid singletons. Dependencies must be injected through initializers, environment values, protocol abstractions, or app composition roots.
- Use dependency injection wherever practical for API, data, secure storage, analytics, realtime, feature flags, notification, clock, and cache dependencies.
- Keep non-UI domain, API, data, validation, and analytics code pure Swift where practical so future Swift-for-Android work can reuse it.
- Isolate Apple-specific APIs behind protocols and adapters; do not compromise native SwiftUI UX for portability.
- Keep app targets thin. Shared domain, API, data, secure storage, design, analytics, realtime, and feature modules should have explicit ownership boundaries.
- Prefer Swift concurrency (`async`/`await`, `actor`, `AsyncSequence`) for networking and realtime coordination.
- Use dependency injection through protocols and environment values so previews and tests do not hit production services.
- Persist secrets only in Keychain. Do not store JWTs, refresh tokens, API tokens, or passkey state in `UserDefaults`.
- Add tests for reducers/view models, API decoding, auth/session state, and critical deep-link routes.

## Validation

- Before opening an implementation PR, run the relevant Xcode test plan or package tests.
- For docs-only planning PRs, run `git diff --check`.
- Do not commit `.DS_Store`, derived data, local credentials, provisioning profiles, or generated build products.
