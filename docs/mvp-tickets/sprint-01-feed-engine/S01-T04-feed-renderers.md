# S01-T04: Feed Renderers

Sprint: 01 - Feed Engine Core

## Objective

Create XML, JSON, and CSV serialization for normalized feeds and items.

## Exact Scope

- Render valid RSS 2.0 XML from normalized feed data.
- Render JSON output using the same normalized fields.
- Render CSV output with spreadsheet-safe escaping.
- Add cache metadata helper for public output routes.
- Do not create public HTTP routes in this ticket.

## Files/modules to create or modify

- Create `src/lib/feed/render-rss.mjs`
- Create `src/lib/feed/render-json.mjs`
- Create `src/lib/feed/render-csv.mjs`
- Create `src/lib/feed/render-cache.mjs`
- Create `src/test/feed-renderers.test.mjs`
- Create `src/test/csv-safety.test.mjs`

## Database changes

None.

## API changes

None visible. Later public output endpoints will use these content types:

- RSS: `application/rss+xml; charset=utf-8`
- JSON: `application/json; charset=utf-8`
- CSV: `text/csv; charset=utf-8`

## Frontend changes

None.

## Backend changes

- Export `renderRssFeed({ feed, items, selfUrl })`.
- Export `renderJsonFeed({ feed, items })`.
- Export `renderCsvFeed({ items })`.
- Escape XML entities.
- Sanitize CSV cells that start with `=`, `+`, `-`, or `@` by prefixing a single quote.
- Keep output deterministic for tests.

## Tests required

- RSS output includes channel title, item title, link, guid, pubDate.
- RSS output escapes `&`, `<`, and `>`.
- JSON output includes feed metadata and items.
- CSV output includes header row and stable column order.
- CSV injection values are prefixed.
- Empty item arrays render valid RSS, JSON, and CSV.

## Acceptance criteria

- Renderer tests pass without database access.
- RSS output validates structurally enough for a standard reader to consume.
- CSV output is safe for spreadsheet import.
- `bun run test` passes.
- `bun run check` passes.

## Dependencies

- `S01-T03-native-feed-parser-and-fingerprints.md`

