# S05-T02: Filter API

Sprint: 05 - Filters and Production Hardening

## Objective

Add authenticated APIs for creating, listing, updating, deleting, and previewing basic feed filters.

## Exact Scope

- Add CRUD endpoints for feed filters.
- Add filter preview endpoint.
- Enforce editor authorization for mutations.
- Enforce viewer authorization for reads.
- Do not add advanced rules or workspace-global filters.

## Files/modules to create or modify

- Create `src/app/api/feeds/[feedId]/filters/route.js`
- Create `src/app/api/feeds/[feedId]/filters/[filterId]/route.js`
- Create `src/app/api/feeds/[feedId]/filters/preview/route.js`
- Create `src/lib/feed/filter-service.mjs`
- Create `src/test/filter-api.test.mjs`
- Create `src/test/filter-preview-api.test.mjs`

## Database changes

- Use `feed_filters`.
- Ensure fields exist:
  - `id`
  - `workspace_id`
  - `feed_id`
  - `type`
  - `field`
  - `operator`
  - `value`
  - `is_enabled`
  - `order_index`

## API changes

Create:

- `GET /api/feeds/{feedId}/filters?workspaceId=...`
- `POST /api/feeds/{feedId}/filters`
- `PATCH /api/feeds/{feedId}/filters/{filterId}`
- `DELETE /api/feeds/{feedId}/filters/{filterId}`
- `POST /api/feeds/{feedId}/filters/preview`

Accepted filter payload:

- `{ "type": "blacklist", "field": "any", "keywords": ["sponsored"], "isEnabled": true }`
- `{ "type": "whitelist", "field": "any", "keywords": ["security"], "isEnabled": true }`

## Frontend changes

None.

## Backend changes

- Validate filter type is `whitelist` or `blacklist`.
- Validate keywords are non-empty strings capped at 80 characters.
- Store keywords in `value.keywords`.
- Preview endpoint returns:
  - `includedCount`
  - `excludedCount`
  - sample included items
  - sample excluded items with reasons

## Tests required

- Editor can create whitelist filter.
- Editor can create blacklist filter.
- Viewer cannot create filter.
- User from another workspace cannot read filters.
- Invalid empty keyword is rejected.
- Preview returns excluded reason for matching item.
- Delete disables or removes filter as specified by implementation and tests.

## Acceptance criteria

- UI can manage filters using documented endpoints.
- Mutations are tenant-safe and role-safe.
- Preview does not persist item status changes.
- `bun run test` passes.
- `bun run check` passes.

## Dependencies

- `S05-T01-basic-filter-engine.md`

