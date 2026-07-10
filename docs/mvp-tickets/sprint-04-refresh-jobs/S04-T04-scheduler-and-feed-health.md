# S04-T04: Scheduler and Feed Health

Sprint: 04 - Refresh Jobs

## Objective

Automatically enqueue due feeds and expose feed health in the dashboard.

## Exact Scope

- Implement scheduler process that finds active feeds due for refresh.
- Calculate `next_refresh_at`.
- Add feed health summary to feed list and detail APIs.
- Add dashboard health badges.
- Do not add email alerts or admin dashboard.

## Files/modules to create or modify

- Modify `src/workers/scheduler.mjs`
- Create `src/lib/feed/refresh-schedule.mjs`
- Create `src/lib/feed/feed-health.mjs`
- Modify `src/app/api/feeds/route.js`
- Modify `src/app/api/feeds/[feedId]/route.js`
- Modify `src/components/feed-status-badge.jsx`
- Modify `src/app/dashboard/page.jsx`
- Create `src/test/refresh-scheduler.test.mjs`
- Create `src/test/feed-health.test.mjs`

## Database changes

- Use `feeds.refresh_interval_minutes`.
- Use `feeds.next_refresh_at`.
- Use `feeds.last_success_at`.
- Use `feeds.last_failure_at`.
- Use `feeds.failure_count`.
- Add missing fields if absent.

## API changes

Extend feed list/detail responses with:

- `healthStatus`: `healthy`, `stale`, `degraded`, `failed`, or `paused`
- `healthMessage`
- `lastSuccessAt`
- `lastFailureAt`
- `nextRefreshAt`
- `failureCount`

## Frontend changes

- Dashboard feed list shows status badge.
- Feed detail shows health message and last/next refresh timestamps.
- Empty dashboard still points to feed creation.

## Backend changes

- Scheduler enqueues active feeds where `next_refresh_at <= now`.
- Scheduler skips paused, deleted, and failed feeds that are cooling down.
- Successful refresh sets next refresh to `now + refresh_interval_minutes`.
- Failed refresh applies exponential backoff capped at 24 hours.

## Tests required

- Scheduler enqueues only due active feeds.
- Scheduler does not enqueue paused feeds.
- Scheduler does not enqueue duplicate queued jobs for the same feed.
- Health helper returns `healthy` after recent success.
- Health helper returns `failed` after repeated failures.
- Dashboard renders health badge text.

## Acceptance criteria

- Feeds refresh automatically without user action.
- Feed health is visible in API and UI.
- Scheduler can run repeatedly without duplicate job storms.
- `bun run test` passes.
- `bun run check` passes.

## Dependencies

- `S04-T02-refresh-worker-pipeline.md`
- `S04-T03-manual-refresh-api-and-throttle.md`

