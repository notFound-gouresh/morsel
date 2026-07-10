# S02-T04: Feed Save and Items API

Sprint: 02 - Discovery and Creation APIs

## Objective

Persist a discovered feed, its source configuration, and its initial normalized items.

## Exact Scope

- Add feed creation API.
- Add feed list, feed detail, and feed items APIs.
- Save initial items using exact fingerprint deduplication.
- Store source metadata for native or webpage feeds.
- Do not add refresh jobs, filters, or public output routes in this ticket.

## Files/modules to create or modify

- Create `src/app/api/feeds/route.js`
- Create `src/app/api/feeds/[feedId]/route.js`
- Create `src/app/api/feeds/[feedId]/items/route.js`
- Create `src/lib/feed/feed-save-service.mjs`
- Modify `src/lib/db/repositories/feeds.mjs`
- Create `src/test/feed-save-api.test.mjs`
- Create `src/test/feed-items-api.test.mjs`

## Database changes

- Use `feeds`, `feed_sources`, and `feed_items`.
- Add migration only if source metadata fields are missing:
  - `feed_sources.kind`
  - `feed_sources.url`
  - `feed_sources.etag`
  - `feed_sources.last_modified`
  - `feed_sources.last_http_status`

## API changes

Create:

- `POST /api/feeds`
  - Body: `{ "workspaceId": "...", "sourceUrl": "...", "sourceType": "...", "feedTitle": "...", "previewItems": [...] }`
- `GET /api/feeds?workspaceId=...`
- `GET /api/feeds/{feedId}?workspaceId=...`
- `PATCH /api/feeds/{feedId}`
  - Supports name, description, visibility, status.
- `DELETE /api/feeds/{feedId}`
  - Soft delete.
- `GET /api/feeds/{feedId}/items?workspaceId=...&limit=25&cursor=...`

## Frontend changes

None.

## Backend changes

- Generate unique feed slug from title or host path.
- Set default status `active`.
- Set default visibility `private`.
- Set default refresh interval to 1440 minutes until scheduler limits exist.
- Upsert items by `(feed_id, fingerprint)`.
- Enforce workspace ownership on every query.

## Tests required

- Saves a native feed preview into feed/source/item rows.
- Saves webpage extraction preview into feed/source/item rows.
- Rejects feed creation for a workspace the user cannot access.
- Lists only feeds in the requested workspace.
- Item endpoint paginates newest first.
- Soft delete removes feed from normal list but keeps rows.

## Acceptance criteria

- A preview returned by S02-T03 can be saved without reformatting.
- Saved feed detail includes source metadata and item count.
- Cross-workspace access is rejected.
- `bun run test` passes.
- `bun run check` passes.

## Dependencies

- `S02-T03-feed-discover-preview-api.md`

