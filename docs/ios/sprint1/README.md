# Sprint 1 - Foundation Reset

Sprint 1 turns the iOS plan into implementation guardrails before feature work starts.

## Jira Scope

- `MOBILE-23`: Approve iOS native restart plan and implementation guardrails
- `MOBILE-24`: Preserve stale app reference and define reset branch strategy
- `MOBILE-25`: Define native MVVM layer and folder/package ownership
- `MOBILE-26`: Create staging and production build configuration plan
- `MOBILE-27`: Add native-only dependency governance checklist
- `MOBILE-63`: Configure SwiftLint explicit self and no-singleton standards

## Artifacts

- `reset_strategy.md`: how to restart inside the existing repo without losing useful history.
- `ownership_map.md`: MVVM, layers, dependency direction, and implementation ownership.
- `build_configurations.md`: local/staging/production configuration plan.
- `dependency_governance.md`: native-only dependency rules and review checklist.
- `.swiftlint.yml`: lint configuration for explicit `self.` and singleton avoidance.

## Sprint 1 Exit Criteria

- Restart approach is documented and reviewable.
- Old code remains preserved through Git history.
- Layer ownership and dependency direction are clear enough to start shell implementation.
- Build configuration inputs are identified before secrets or environments are added.
- SwiftLint standards are checked in.
- No external runtime libraries are introduced.

## Validation

Run during Sprint 1:

```bash
git diff --check
swiftlint lint --config .swiftlint.yml --quiet --lenient
```

Use `--lenient` only while the stale app remains in the repository as reference code. After the reset removes or replaces stale implementation files, CI should run SwiftLint without `--lenient` and should add `swiftlint analyze` for `explicit_self`.
