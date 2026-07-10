# S03-T03: Feed Detail UI

Sprint: 03 - User Dashboard

## Objective

Build the saved feed detail screen with item preview, output links, source metadata, and refresh status placeholders.

## Exact Scope

- Add `/dashboard/feeds/[feedId]`.
- Display feed settings, source URL, item list, output URLs, and latest refresh logs if available.
- Add copyable RSS, JSON, and CSV links.
- Add pause/resume/delete controls backed by existing feed update API.
- Do not add manual refresh button until Sprint 04.

## Files/modules to create or modify

- Create `src/app/dashboard/feeds/[feedId]/page.jsx`
- Create `src/components/feed-output-links.jsx`
- Create `src/components/feed-item-table.jsx`
- Create `src/components/feed-status-badge.jsx`
- Create `src/components/feed-settings-panel.jsx`
- Create `src/test/feed-detail-ui.test.mjs`

## Database changes

None.

## API changes

Consumes:

- `GET /api/feeds/{feedId}`
- `GET /api/feeds/{feedId}/items`
- `PATCH /api/feeds/{feedId}`
- `DELETE /api/feeds/{feedId}`

## Frontend changes

- Feed detail shows:
  - feed name and status
  - source URL
  - item count
  - latest items
  - RSS/JSON/CSV output links
  - last refresh and next refresh when data exists
  - pause/resume/delete actions
- Empty item list shows a diagnostic message and link back to create feed.

## Backend changes

- Existing feed detail API must include enough fields for this screen:
  - `id`
  - `name`
  - `status`
  - `sourceUrl`
  - `visibility`
  - `outputUrls`
  - `lastRefreshedAt`
  - `nextRefreshAt`
  - `failureCount`

## Tests required

- Renders output links from API response.
- Renders item rows with title, date, and URL.
- Shows empty state when no items exist.
- Pause action sends `PATCH status=paused`.
- Delete action sends `DELETE` and redirects to dashboard.

## Acceptance criteria

- User can inspect a saved feed and copy all output URLs.
- User can pause or delete a feed from UI.
- UI does not show unsupported advanced actions.
- `bun run test` passes.
- `bun run check` passes.

## Dependencies

- `S02-T04-feed-save-and-items-api.md`
- `S02-T05-public-output-endpoints.md`
- `S03-T01-dashboard-shell.md`

