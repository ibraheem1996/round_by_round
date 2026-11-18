# Round by Round — Agent Instructions

## 1. Mandatory Self-Maintenance
- On every task, check whether this file still reflects the project. **Correct stale or missing facts before writing a plan.**
- After a task, update it for verified changes that matter to future work: architecture, shared systems/patterns, verification workflows, implemented or approved upcoming features, or project status.
- Keep updates short; replace outdated statements rather than accumulating a changelog. Do not record unapproved decisions as facts.
- **Every response must state the file's status:** `AGENTS.md: Up to date`, `AGENTS.md: Updated`, or `AGENTS.md: Update required` (with reason if an update could not be made).

## 2. Sources of Truth
- `Project docs/GYM_TRACKER_V1_PRODUCT_CONTRACT.md`: product requirements and behavior.
- `Project docs/GYM_TRACKER_V1_TECHNICAL_CONTRACT (1).md`: approved technical decisions.
- These files are available locally. Read only the relevant sections and affected dependencies. Do not duplicate their rules here, guess pending decisions, or silently override them. Record approved changes in the appropriate contract first.

## 3. Architecture & Quality
- Follow the technical contract: FVM, feature-first pragmatic clean architecture, Cubit, `get_it` + `injectable`, and `go_router`.
- Avoid unused boilerplate and speculative abstractions. Keep feature logic independent of Firebase implementation details.
- Use `fvm flutter` / `fvm dart`; run relevant formatting, analysis, and tests, and report actual results. Do not manually edit generated code.

## 4. Workflow & Plans
- Inspect the relevant code, Git status, and existing patterns before editing. Respect task scope and preserve unrelated changes.
- **Save every written implementation plan under `Project docs/plans/`** (create the directory if needed). Do not generate a plan for trivial work unless requested.
- After implementation, review the diff, verify what changed, and apply the self-maintenance rule above.

- All foundation work before the first feature belongs on `chore/project-setup`, created from `main`; keep this file tracked on that branch. Do not edit or push on `main`. Merge later through a reviewed Pull Request. This is a workflow policy, not a server-side branch protection rule.

## 5. Current Project State
- Flutter Android/iOS project; Flutter **3.50.0** pinned via `.fvmrc`.
- **Foundation setup** on `chore/project-setup`; foundation packages are installed and iOS minimum is 15.0. Core, features, and Firebase initialization are not implemented.
- `build_runner` is pinned to 2.16.1: newer releases conflict with injectable_generator (build/lean_builder/analyzer); 2.17.0 is retracted. Dart minimum is 3.13 for Freezed 4.
- Current validation: pub get/outdated pass; existing main.dart has a deprecated Material import and formatting drift. No test/ directory exists yet; CI flutter test requires real tests when application code is implemented.
- GitHub Actions CI exists for pull requests; Firebase/Firestore offline cache remains provisional pending the contract's proof of concept.
