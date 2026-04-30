# BeerHopper iOS Planning

This folder is the review packet for making BeerHopper a first-class SwiftUI app that shares the web product model while feeling native on iPhone.

## Documents

- `product_plan.md`: app goals, scope, release phases, and feature parity strategy.
- `design_language.md`: native Apple design direction mapped to BeerHopper brand tokens.
- `architecture.md`: module boundaries, state management, networking, auth, offline, realtime, and security.
- `roadmap.md`: implementation phases and acceptance criteria.
- `validation_plan.md`: test strategy, review checklist, and launch readiness gates.

## Core Positioning

BeerHopper iOS should be the mobile companion for discovery, brew-day execution, community, and brewery operations. The app should use the same API, permissions, analytics vocabulary, and deep-link semantics as web, but should not be a web layout port.

Native iOS priorities:

- Restart the stale implementation in the existing repo with clean SwiftUI/MVVM boundaries.
- Use no external libraries; build the API, data, secure, design, analytics, and realtime layers with Apple frameworks and first-party code.
- Keep non-UI domain/API/data/security abstractions portable in pure Swift where practical so future Swift-for-Android work can reuse the core.
- Fast launch into current activity, search, and brew-day context.
- Tab-based primary navigation with stack-based detail flows.
- Sheets for focused actions, forms for structured editing, and lists for scan-heavy content.
- Apple-native accessibility, notification, share, and passkey behaviors.
- Offline-tolerant read views and explicit sync states for brew day and notes.
