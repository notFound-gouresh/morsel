# S03-T02: Feed Creation UI

Sprint: 03 - User Dashboard

## Objective

Build the user-facing flow for pasting a URL, previewing discovered feed items, and saving the feed.

## Exact Scope

- Add `/dashboard/feeds/new`.
- Wire UI to `POST /api/feeds/discover` and `POST /api/feeds`.
- Show loading, success, and error states.
- Redirect to feed detail after save.
- Do not implement visual builder, social-specific source forms, or widgets.

## Files/modules to create or modify

- Create `src/app/dashboard/feeds/new/page.jsx`
- Create `src/components/feed-create-form.jsx`
- Create `src/components/feed-preview-list.jsx`
- Create `src/lib/client/api-client.js`
- Modify `src/components/feed-console.jsx`
- Create `src/test/feed-create-ui.test.mjs`

## Database changes

None.

## API changes

Consumes existing endpoints:

- `POST /api/feeds/discover`
- `POST /api/feeds`

## Frontend changes

- Form fields:
  - source URL
  - feed name override after preview
- Preview states:
  - loading discovery
  - native feed found
  - webpage extraction used
  - warnings
  - no feed candidate
  - unsafe URL
- Save action disabled until preview returns at least one item.

## Backend changes

None, unless API tests reveal response shape gaps that must be fixed in earlier endpoints.

## Tests required

- Form rejects empty URL before network call.
- Discover button calls `/api/feeds/discover`.
- Preview renders returned item titles and source type.
- Save button posts preview payload to `/api/feeds`.
- API error envelope renders the user-facing message.
- Successful save redirects to `/dashboard/feeds/{feedId}`.

## Acceptance criteria

- User can create a feed without using browser dev tools.
- UI explains native vs webpage extraction path.
- Unsafe URLs show a clear non-technical error.
- `bun run test` passes.
- `bun run check` passes.

## Dependencies

- `S02-T03-feed-discover-preview-api.md`
- `S02-T04-feed-save-and-items-api.md`
- `S03-T01-dashboard-shell.md`

