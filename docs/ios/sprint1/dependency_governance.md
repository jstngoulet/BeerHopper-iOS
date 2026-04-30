# Dependency Governance

## Policy

BeerHopper iOS is native-only. Runtime app code should use Apple frameworks and first-party code.

Allowed:

- SwiftUI
- Foundation
- URLSession
- Observation and Combine where useful
- Security / Keychain APIs
- CryptoKit
- AuthenticationServices
- LocalAuthentication
- UserNotifications
- SwiftData or Core Data after explicit persistence approval
- XCTest and XCUITest
- SwiftLint as a development-time tool

Not allowed:

- Third-party runtime packages.
- Third-party networking clients.
- Third-party dependency injection frameworks.
- Third-party architecture/state-management frameworks.
- Third-party image loaders or caches.
- Third-party analytics SDKs.
- Third-party realtime/socket clients without explicit approved exception.

## Review Checklist

Every implementation PR must answer:

- Did this add a dependency?
- Is the dependency runtime code or development-time tooling?
- If development tooling, is it configured in repo and absent from app runtime?
- Could the same result be achieved with Apple frameworks or first-party code?
- Does the change preserve MVVM boundaries?
- Are dependencies injectable for tests/previews?
- Does touched Swift code use explicit `self.` where available?
- Does touched code avoid BeerHopper-owned singletons?

## SwiftLint Governance

SwiftLint is the only approved dependency exception in Sprint 1.

Rules:

- It is development-time tooling only.
- It must not be linked into app runtime targets.
- `.swiftlint.yml` is checked in.
- `explicit_self` is configured as an analyzer error and must be run with `swiftlint analyze` once the reset project has a clean build log/compiler database.
- Singleton-style `static let shared` is flagged for BeerHopper-owned services; after the reset branch removes stale implementation code, this warning should be promoted to an error.
- Sprint 1 lint validation may report warnings from the stale reference app. New/reset Swift code must be brought into compliance before it is merged.

## Exception Process

If an exception is needed:

1. Create a Jira issue documenting the dependency, license, runtime impact, maintenance risk, and native alternative considered.
2. Mark it as out of sprint scope unless explicitly approved.
3. Add rollback notes.
4. Update this governance document if accepted.
