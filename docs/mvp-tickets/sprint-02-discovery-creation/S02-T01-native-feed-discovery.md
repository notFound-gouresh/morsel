# S02-T01: Native Feed Discovery

Sprint: 02 - Discovery and Creation APIs

## Objective

Discover native RSS or Atom feeds from a user-submitted website URL before falling back to webpage extraction.

## Exact Scope

- Fetch a website page safely.
- Parse `<link rel="alternate">` RSS/Atom hints.
- Probe common feed paths on the same host.
- Return ranked discovery candidates.
- Do not save feeds or build UI in this ticket.

## Files/modules to create or modify

- Create `src/lib/feed/discover-native-feeds.mjs`
- Create `src/test/native-feed-discovery.test.mjs`
- Create `src/test/fixtures/html-with-rss-link.html`
- Create `src/test/fixtures/html-with-atom-link.html`
- Modify `src/lib/crawler/http-fetcher.mjs`

## Database changes

None.

## API changes

None visible.

## Frontend changes

None.

## Backend changes

- Export `discoverNativeFeeds({ sourceUrl })`.
- Return candidates:
  - `url`
  - `type`: `rss` or `atom`
  - `title`
  - `source`: `alternate_link` or `common_path`
  - `confidence`: number from 0 to 1
- Resolve relative feed URLs against the final page URL.
- Probe only same-origin common paths:
  - `/feed`
  - `/feed.xml`
  - `/rss`
  - `/rss.xml`
  - `/atom.xml`
- Use fetcher safety and robots policy.

## Tests required

- Finds RSS alternate link.
- Finds Atom alternate link.
- Resolves relative alternate links.
- Deduplicates identical candidate URLs.
- Probes common feed paths after no alternate link.
- Does not probe a different host.

## Acceptance criteria

- Native discovery never saves database records.
- Discovery returns candidates in confidence order.
- Unsafe URLs are rejected by the lower-level URL safety module.
- `bun run test` passes.
- `bun run check` passes.

## Dependencies

- `S01-T02-http-fetcher-and-robots.md`
- `S01-T03-native-feed-parser-and-fingerprints.md`

