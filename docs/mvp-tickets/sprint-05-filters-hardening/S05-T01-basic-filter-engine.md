# S05-T01: Basic Filter Engine

Sprint: 05 - Filters and Production Hardening

## Objective

Add MVP keyword whitelist and blacklist filtering for feed items.

## Exact Scope

- Implement filter rule evaluation for title, description, URL, and author fields.
- Support whitelist and blacklist keyword lists.
- Record filter reasons on excluded items.
- Integrate filtering into refresh pipeline.
- Do not build advanced boolean rules, similar-post deduplication, or missing-field filtering in this ticket.

## Files/modules to create or modify

- Create `src/lib/feed/filter-engine.mjs`
- Modify `src/lib/feed/refresh-feed.mjs`
- Modify `src/lib/db/repositories/feeds.mjs`
- Create `src/test/filter-engine.test.mjs`
- Create `src/test/refresh-with-filters.test.mjs`

## Database changes

- Use `feed_filters`.
- Use `feed_items.status`.
- Use `feed_items.filter_reason`.
- Add missing fields if absent.

## API changes

None in this ticket.

## Frontend changes

None.

## Backend changes

- Export `applyFilters({ item, filters })`.
- Rule behavior:
  - If no enabled filters exist, include item.
  - Blacklist match excludes item.
  - Whitelist filters require at least one whitelist keyword match when whitelist filters exist.
  - Matching is case-insensitive.
  - Matching checks normalized text fields.
- During refresh, store excluded items with `status=filtered` and `filter_reason`.
- Active output endpoints include only `status=active` items.

## Tests required

- Item passes with no filters.
- Blacklist keyword in title excludes item.
- Blacklist keyword in description excludes item.
- Whitelist keyword includes matching item.
- Whitelist keyword excludes non-matching item.
- Blacklist wins when whitelist and blacklist both match.
- Refresh stores filtered items with reason.
- Public output excludes filtered items.

## Acceptance criteria

- Filtering is deterministic and explainable.
- Existing feed refresh tests still pass.
- Output endpoints no longer expose filtered items.
- `bun run test` passes.
- `bun run check` passes.

## Dependencies

- `S04-T02-refresh-worker-pipeline.md`
- `S02-T05-public-output-endpoints.md`

