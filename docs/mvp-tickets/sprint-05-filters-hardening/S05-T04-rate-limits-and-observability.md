# S05-T04: Rate Limits and Observability

Sprint: 05 - Filters and Production Hardening

## Objective

Add the minimum rate limiting, structured logging, and support diagnostics needed to run the MVP safely.

## Exact Scope

- Add lightweight rate limits for auth, feed discovery, manual refresh, and public output endpoints.
- Add structured logs with request ID.
- Add database error logging for feed discovery and refresh failures.
- Add a support-only diagnostics API for a single feed.
- Do not build a full admin panel.

## Files/modules to create or modify

- Create `src/lib/security/rate-limit.mjs`
- Create `src/lib/logging/logger.mjs`
- Create `src/lib/logging/error-log.mjs`
- Create `src/app/api/support/feeds/[feedId]/diagnostics/route.js`
- Modify `src/app/api/auth/login/route.js`
- Modify `src/app/api/auth/signup/route.js`
- Modify `src/app/api/feeds/discover/route.js`
- Modify `src/app/api/feeds/[feedId]/refresh/route.js`
- Modify `src/app/f/[slug]/rss/route.js`
- Modify `src/app/f/[slug]/json/route.js`
- Modify `src/app/f/[slug]/csv/route.js`
- Create `src/test/rate-limit.test.mjs`
- Create `src/test/feed-diagnostics-api.test.mjs`

## Database changes

- Use `error_logs`.
- Add `users.is_support_admin` only if no better admin flag exists.

## API changes

Create:

- `GET /api/support/feeds/{feedId}/diagnostics?workspaceId=...`

Extend existing APIs to return `RATE_LIMITED` with `Retry-After` when limits are exceeded.

## Frontend changes

None required. Existing error components should show rate-limit messages.

## Backend changes

- Rate limit buckets:
  - login: by IP + email
  - signup: by IP
  - feed discovery: by user + workspace
  - manual refresh: by feed + workspace
  - public output: by IP + feed slug
- Use in-memory limiter for MVP local deployment with a documented path to Redis-backed limiter before multi-instance scale.
- Diagnostics API returns:
  - feed status
  - source URL
  - last refresh job
  - recent error logs
  - item counts by status
  - latest public output URLs

## Tests required

- Exceeding login limit returns `RATE_LIMITED`.
- Exceeding feed discovery limit returns `RATE_LIMITED`.
- Public output limiter returns retry header.
- Refresh failure writes error log.
- Non-support user cannot access diagnostics.
- Support admin can access diagnostics for a feed.

## Acceptance criteria

- MVP has abuse controls on the highest-risk endpoints.
- Feed failures can be diagnosed without direct database access.
- Logs include request ID and error code.
- `bun run test` passes.
- `bun run check` passes.

## Dependencies

- `S00-T04-authorization-and-audit-logs.md`
- `S02-T03-feed-discover-preview-api.md`
- `S04-T03-manual-refresh-api-and-throttle.md`

