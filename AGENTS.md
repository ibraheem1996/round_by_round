# Round by Round — Agent Instructions

## 1. Mandatory Maintenance
- These are **binding project-wide rules**, not a progress log. Before planning or editing, check this file against approved decisions and actual project conventions. Correct outdated or missing rules immediately when permitted; otherwise report what needs updating and why.
- After a task, update this file **only** when an approved, durable rule affecting future agents has been added or changed (e.g., a shared responsive system, theming convention, architecture boundary, or verification policy). Record the decision in the appropriate contract first.
- **Replace, don't accumulate:** revise existing rules instead of appending task notes. Never store current phases, blockers, completed/pending features, transient issues, or facts that belong in `PROJECT_STATUS.md` or implementation files.
- End **every response** with exactly one file status: `AGENTS.md: Up to date`, `AGENTS.md: Updated`, or `AGENTS.md: Update required` (include the reason if not updated). Do not claim `Updated` unless the file was actually edited.

## 2. Sources of Truth
- `Project docs/GYM_TRACKER_V1_PRODUCT_CONTRACT.md` — approved product behavior and scope.
- `Project docs/GYM_TRACKER_V1_TECHNICAL_CONTRACT (1).md` — approved technical decisions.
- `Project docs/PROJECT_STATUS.md` — concise snapshot of current progress, active work, and blockers; **not** a source of new requirements. Read it when present and keep it accurate after material progress or a verified status change. Replace stale entries, never append a changelog; if absent, report it rather than inventing facts.
- Read only task-relevant contract sections and dependencies. Never turn pending choices into decisions or silently override contracts. Update the appropriate contract before reflecting newly approved, cross-cutting rules here.

## 3. Engineering Rules
- Use FVM and the approved stack: feature-first pragmatic clean architecture, Cubit, `get_it` + `injectable`, and `go_router`. Respect dependency boundaries; keep business logic independent of Firebase details.
- Use approved Stitch designs for colors, visual identity, composition, and imagery. Treat HTML measurements as guidance and adapt semantic typography and layout to locale, text scaling, and local content constraints.
- Use the central responsive policy for window-based values. Keep feature-specific values in their feature and use parent constraints when a component needs to measure its own available space.
- Keep `main()` to one line that starts the app. Put logic, initialization, and callbacks outside it.
- Use built-in widget accessibility. Do not add explicit `Semantics` wrappers.
- Do not use `debugPrint` or direct console printing in application code.
- Keep UI components in their owning feature. Extract them to Shared only when actual reuse across features or a clear cross-feature responsibility warrants it.
- Add only needed files, packages, and abstractions. Do not hand-edit generated code.
- Use `fvm flutter` / `fvm dart`; run relevant formatting, analysis, and tests. Report actual verification results and limitations.

## 4. Workflow
- Inspect relevant code, Git status, and existing patterns before changes; preserve unrelated work and stay within the task scope.
- Save written implementation plans under `Project docs/plans/`. Do not create a plan for trivial work unless requested.
- Do not edit or push directly to `main`; use a working branch and a reviewed Pull Request. This rule does not replace GitHub branch protection.
- Review the diff and verification results after changes; then maintain the contracts, `PROJECT_STATUS.md`, and this file **only where their respective responsibilities require it**.
