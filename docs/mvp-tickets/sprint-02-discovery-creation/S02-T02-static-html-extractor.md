# S02-T02: Static HTML Extractor

Sprint: 02 - Discovery and Creation APIs

## Objective

Extract simple feed items from public static HTML listing pages when no native RSS or Atom feed is found.

## Exact Scope

- Detect repeated article/card links in static HTML.
- Extract title, URL, description, image, and date when available.
- Produce confidence scores and extraction warnings.
- Do not use browser automation, visual selector recipes, or authenticated pages.

## Files/modules to create or modify

- Modify `package.json`
- Create `src/lib/feed/html-extractor.mjs`
- Create `src/lib/feed/html-cleanup.mjs`
- Create `src/test/html-extractor.test.mjs`
- Create `src/test/fixtures/html-article-list.html`
- Create `src/test/fixtures/html-card-grid.html`
- Create `src/test/fixtures/html-no-items.html`

## Database changes

None.

## API changes

None visible.

## Frontend changes

None.

## Backend changes

- Add `cheerio` or equivalent HTML parser.
- Export `extractItemsFromHtml({ pageUrl, bodyText })`.
- Consider these selectors and structures:
  - `article`
  - elements with repeated anchors inside `main`
  - cards with `h1`, `h2`, or `h3`
  - `time[datetime]`
  - `img[src]`
  - `meta[property="og:image"]` as feed fallback image
- Resolve relative URLs.
- Strip scripts/styles from descriptions.
- Return at most 25 preview items for MVP.
- Return `NO_ITEMS_EXTRACTED` when confidence is too low.

## Tests required

- Extracts at least three items from an article list fixture.
- Extracts title and absolute URL.
- Extracts image URL from relative `img`.
- Extracts ISO date from `time[datetime]`.
- Deduplicates repeated navigation links.
- Rejects fixture with no repeated items.

## Acceptance criteria

- Static extractor works without network access.
- Extracted items can be passed to the fingerprint module.
- Low-confidence extraction returns a clear warning/error.
- `bun run test` passes.
- `bun run check` passes.

## Dependencies

- `S01-T03-native-feed-parser-and-fingerprints.md`

