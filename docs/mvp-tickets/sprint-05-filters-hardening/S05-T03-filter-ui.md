# S05-T03: Filter UI

Sprint: 05 - Filters and Production Hardening

## Objective

Add feed filter management to the feed detail page.

## Exact Scope

- Display existing whitelist and blacklist filters.
- Add forms to create keyword filters.
- Allow enabling, disabling, and deleting filters.
- Add preview of filter impact.
- Do not add advanced rule builder UI.

## Files/modules to create or modify

- Create `src/components/feed-filter-panel.jsx`
- Create `src/components/filter-preview.jsx`
- Modify `src/app/dashboard/feeds/[feedId]/page.jsx`
- Modify `src/lib/client/api-client.js`
- Create `src/test/filter-ui.test.mjs`

## Database changes

None.

## API changes

Consumes:

- `GET /api/feeds/{feedId}/filters`
- `POST /api/feeds/{feedId}/filters`
- `PATCH /api/feeds/{feedId}/filters/{filterId}`
- `DELETE /api/feeds/{feedId}/filters/{filterId}`
- `POST /api/feeds/{feedId}/filters/preview`

## Frontend changes

- Feed detail includes a "Filters" section.
- Users can enter comma-separated keywords.
- Users choose whitelist or blacklist.
- UI shows enabled/disabled state.
- Preview displays included and excluded counts before save.
- UI explains that filters apply on the next refresh and output endpoints show active items only.

## Backend changes

None unless API response shape needs a bug fix.

## Tests required

- Filter panel renders existing filters.
- Creating blacklist filter calls the correct API.
- Creating whitelist filter calls the correct API.
- Disable toggle calls `PATCH isEnabled=false`.
- Delete button calls `DELETE`.
- Preview renders included/excluded counts and sample reason.

## Acceptance criteria

- Non-technical user can add basic keyword filters from feed detail.
- UI does not expose unsupported advanced filtering.
- API errors display with request ID.
- `bun run test` passes.
- `bun run check` passes.

## Dependencies

- `S05-T02-filter-api.md`
- `S03-T03-feed-detail-ui.md`

