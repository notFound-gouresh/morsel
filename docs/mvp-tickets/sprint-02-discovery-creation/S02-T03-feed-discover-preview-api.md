# S02-T03: Feed Discover Preview API

Sprint: 02 - Discovery and Creation APIs

## Objective

Create the API endpoint that accepts a URL, discovers the best source mode, and returns a feed preview before saving.

## Exact Scope

- Add `POST /api/feeds/discover`.
- Authenticate the user and workspace.
- Run native discovery first.
- Parse native feed candidates when found.
- Fall back to static HTML extraction.
- Return preview items and source metadata.
- Do not save feeds in this ticket.

## Files/modules to create or modify

- Create `src/app/api/feeds/discover/route.js`
- Create `src/lib/feed/feed-discovery-service.mjs`
- Create `src/test/feed-discover-api.test.mjs`
- Modify `src/lib/db/repositories/feeds.mjs`

## Database changes

None required. This endpoint is preview-only.

## API changes

Create:

- `POST /api/feeds/discover`
  - Auth: session required.
  - Body: `{ "workspaceId": "...", "url": "https://example.com/blog" }`
  - Success response:
    - `sourceUrl`
    - `sourceType`: `native` or `webpage`
    - `sourceFormat`: `rss`, `atom`, or `html`
    - `feedTitle`
    - `feedDescription`
    - `previewItems`
    - `warnings`
  - Error codes:
    - `UNAUTHORIZED`
    - `FORBIDDEN`
    - `INVALID_URL`
    - `UNSAFE_URL`
    - `NO_FEED_CANDIDATE`
    - `FETCH_FAILED`

## Frontend changes

None.

## Backend changes

- Use `createRequestContext`.
- Use `discoverNativeFeeds`.
- Use `parseNativeFeed` for native candidates.
- Use `fetchDocument` and `extractItemsFromHtml` for webpage fallback.
- Limit preview to 10 items.
- Do not write feed, source, or item rows.

## Tests required

- Rejects unauthenticated request.
- Rejects user without workspace access.
- Returns native preview for fixture page with RSS alternate link.
- Returns HTML preview when no native feed exists.
- Returns stable error envelope for unsafe URL.
- Does not create feed rows during preview.

## Acceptance criteria

- API response is enough for the UI to show preview and save choice.
- Native feed discovery is preferred over HTML extraction.
- No database writes occur except audit/error logging if already implemented.
- `bun run test` passes.
- `bun run check` passes.

## Dependencies

- `S00-T04-authorization-and-audit-logs.md`
- `S02-T01-native-feed-discovery.md`
- `S02-T02-static-html-extractor.md`

