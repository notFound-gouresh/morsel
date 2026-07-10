# S05-T05: MVP Production Readiness Gate

Sprint: 05 - Filters and Production Hardening

## Objective

Make the completed MVP deployable, documented, testable, and ready for a production beta without advanced feature scope creep.

## Exact Scope

- Add deployment documentation.
- Add health check endpoint.
- Add environment validation command.
- Add smoke tests for the full MVP flow.
- Add legal/help placeholders for Terms, Privacy, Acceptable Use, and takedown flow as static pages.
- Add production checklist documentation.
- Do not implement billing, widgets, webhooks, visual builder, or social adapters.

## Files/modules to create or modify

- Create `src/app/api/health/route.js`
- Create `src/app/legal/terms/page.jsx`
- Create `src/app/legal/privacy/page.jsx`
- Create `src/app/legal/acceptable-use/page.jsx`
- Create `src/app/legal/takedown/page.jsx`
- Create `src/test/mvp-smoke.test.mjs`
- Create `src/test/health-route.test.mjs`
- Create `scripts/validate-env.mjs`
- Create `docs/mvp-production-readiness.md`
- Modify `package.json`
- Modify `README.md`

## Database changes

None.

## API changes

Create:

- `GET /api/health`
  - Returns database connectivity, app version, and worker configuration status without exposing secrets.

## Frontend changes

- Add static legal pages linked from the footer or help page.
- Ensure the dashboard and help pages link to legal pages where relevant.

## Backend changes

- Add `bun run validate-env`.
- Add smoke test that exercises:
  - signup
  - feed discovery using fixtures or mocked fetcher
  - feed save
  - item list
  - public RSS
  - manual refresh enqueue
  - filter creation
- Add health route database ping with short timeout.

## Tests required

- Health route returns ok when database is reachable.
- Env validation fails for missing required env vars.
- Smoke test proves MVP happy path.
- Static legal pages render.
- `bun run check` includes unit tests and Next production build.

## Acceptance criteria

- README explains how to run app, database, worker, scheduler, tests, and build.
- `docs/mvp-production-readiness.md` lists completed and remaining operational checks.
- `bun run validate-env` passes with `.env.example` values adapted for local development.
- `bun run check` passes.
- No advanced feature routes are required for the MVP smoke test.

## Dependencies

- `S05-T03-filter-ui.md`
- `S05-T04-rate-limits-and-observability.md`

