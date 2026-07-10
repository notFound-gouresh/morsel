# S04-T03: Manual Refresh API and Throttle

Sprint: 04 - Refresh Jobs

## Objective

Let users manually enqueue a refresh from the feed detail screen while preventing abuse.

## Exact Scope

- Add manual refresh API.
- Enforce workspace authorization.
- Enforce per-feed cooldown.
- Add manual refresh button to feed detail UI.
- Do not run refresh synchronously in the HTTP request.

## Files/modules to create or modify

- Create `src/app/api/feeds/[feedId]/refresh/route.js`
- Create `src/lib/feed/manual-refresh-service.mjs`
- Modify `src/app/dashboard/feeds/[feedId]/page.jsx`
- Create `src/components/manual-refresh-button.jsx`
- Create `src/test/manual-refresh-api.test.mjs`
- Create `src/test/manual-refresh-ui.test.mjs`

## Database changes

- Use `feed_refresh_jobs`.
- Use `usage_limits` only if already available for counting manual refreshes.
- Add `feeds.last_manual_refresh_at` if not present.

## API changes

Create:

- `POST /api/feeds/{feedId}/refresh`
  - Body: `{ "workspaceId": "..." }`
  - Success: queued refresh job and current cooldown state.
  - Errors:
    - `UNAUTHORIZED`
    - `FORBIDDEN`
    - `FEED_NOT_FOUND`
    - `REFRESH_THROTTLED`
    - `FEED_PAUSED`

## Frontend changes

- Add manual refresh button to feed detail page.
- Show queued state after click.
- Show cooldown message with seconds remaining when throttled.
- Hide or disable button for paused feeds with explanatory text.

## Backend changes

- Use `MANUAL_REFRESH_COOLDOWN_SECONDS` from env.
- Check the last manual queued/running job for the feed.
- Enqueue job with `trigger=manual` and higher priority than scheduled jobs.
- Write audit log action `feed.manual_refresh_requested`.

## Tests required

- Authorized editor can enqueue manual refresh.
- Viewer cannot enqueue manual refresh.
- Paused feed rejects manual refresh.
- Second request within cooldown returns `REFRESH_THROTTLED`.
- UI displays queued state.
- UI displays throttle message.

## Acceptance criteria

- Manual refresh never blocks while fetching the source.
- Abuse cooldown is enforced server-side.
- User receives clear feedback after clicking refresh.
- `bun run test` passes.
- `bun run check` passes.

## Dependencies

- `S04-T01-refresh-queue-and-worker-shell.md`
- `S04-T02-refresh-worker-pipeline.md`
- `S03-T03-feed-detail-ui.md`

