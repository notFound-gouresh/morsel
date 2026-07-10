# S02-T05: Public RSS, JSON, and CSV Output Endpoints

Sprint: 02 - Discovery and Creation APIs

## Objective

Expose saved feed items through stable RSS, JSON, and CSV URLs.

## Exact Scope

- Add public output routes for saved feeds.
- Support private token access for MVP.
- Use renderers from Sprint 01.
- Add cache headers.
- Do not add widgets, webhooks, API keys, or OPML in this ticket.

## Files/modules to create or modify

- Create `src/app/f/[slug]/rss/route.js`
- Create `src/app/f/[slug]/json/route.js`
- Create `src/app/f/[slug]/csv/route.js`
- Create `src/lib/feed/public-feed-access.mjs`
- Modify `src/lib/db/repositories/feeds.mjs`
- Create `src/test/public-output-routes.test.mjs`

## Database changes

- Add `feeds.public_token_hash` if not present.
- Add `feeds.visibility` if not present.
- Add `feeds.output_slug` if `feeds.slug` is not already globally resolvable.

## API changes

Create public endpoints:

- `GET /f/{slug}/rss`
- `GET /f/{slug}/json`
- `GET /f/{slug}/csv`

Private feeds require query token:

- `GET /f/{slug}/rss?token=...`

## Frontend changes

None in this ticket. Dashboard will link these URLs in Sprint 03.

## Backend changes

- Lookup feed by public slug.
- Enforce visibility:
  - `public`: no token required.
  - `private`: valid token required.
  - `unlisted`: no listing API exposure but direct URL allowed if configured.
- Return 404 instead of leaking private feed existence.
- Limit items to the feed's configured post limit or 50 by default.
- Set `Cache-Control: public, max-age=60, stale-while-revalidate=300` for public feeds.
- Set `Cache-Control: private, no-store` for tokenized private feeds.

## Tests required

- Public RSS endpoint returns RSS content type and XML.
- Public JSON endpoint returns JSON content type and normalized items.
- Public CSV endpoint returns CSV content type and safe CSV.
- Private feed without token returns 404.
- Private feed with valid token returns content.
- Deleted feed returns 404.

## Acceptance criteria

- Saved feeds have stable output URLs.
- Feed readers can consume the RSS route.
- JSON and CSV routes return the same active item set.
- `bun run test` passes.
- `bun run check` passes.

## Dependencies

- `S01-T04-feed-renderers.md`
- `S02-T04-feed-save-and-items-api.md`

