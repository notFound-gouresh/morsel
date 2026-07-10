# S04-T02: Refresh Worker Pipeline

Sprint: 04 - Refresh Jobs

## Objective

Implement the background pipeline that refreshes native and webpage feeds and upserts new or changed items.

## Exact Scope

- Process one queued refresh job.
- Fetch the saved feed source.
- Parse native feeds or extract HTML webpage items.
- Upsert items with exact deduplication.
- Update feed health fields.
- Record error logs on failure.
- Do not add manual refresh API or scheduler enqueueing in this ticket.

## Files/modules to create or modify

- Create `src/lib/feed/refresh-feed.mjs`
- Modify `src/workers/refresh-worker.mjs`
- Modify `src/lib/db/repositories/feeds.mjs`
- Modify `src/lib/db/repositories/jobs.mjs`
- Create `src/test/refresh-feed.test.mjs`
- Create `src/test/refresh-worker.test.mjs`

## Database changes

- Use `feeds.last_refreshed_at`, `feeds.last_success_at`, `feeds.last_failure_at`, `feeds.failure_count`, `feeds.status`.
- Use `feed_sources.last_http_status`, `feed_sources.last_fetch_duration_ms`, `feed_sources.etag`, `feed_sources.last_modified`.
- Add these fields if absent.

## API changes

None.

## Frontend changes

None.

## Backend changes

- Export `refreshFeed({ feedId, trigger })`.
- For `source_type=native`, fetch source URL and parse with `parseNativeFeed`.
- For `source_type=webpage`, fetch source URL and extract with `extractItemsFromHtml`.
- Upsert items by fingerprint.
- Mark feed `active` after success.
- Mark feed `degraded` after recoverable extraction warnings.
- Mark feed `failed` after unrecoverable failures.
- Return `{ itemsFound, itemsNew, itemsChanged }`.

## Tests required

- Native feed refresh inserts new items.
- Second refresh with same feed inserts zero new items.
- Changed item content updates existing row.
- Webpage feed refresh uses HTML extractor.
- Failed fetch increments `failure_count` and writes `error_logs`.
- Successful refresh resets `failure_count`.

## Acceptance criteria

- Refresh pipeline can run outside HTTP request/response.
- Duplicate items do not produce duplicate rows.
- Failed refresh does not delete previous items.
- `bun run test` passes.
- `bun run check` passes.

## Dependencies

- `S01-T02-http-fetcher-and-robots.md`
- `S01-T03-native-feed-parser-and-fingerprints.md`
- `S02-T02-static-html-extractor.md`
- `S04-T01-refresh-queue-and-worker-shell.md`

