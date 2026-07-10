# S03-T04: Help, Empty States, and Error States

Sprint: 03 - User Dashboard

## Objective

Add MVP help pages and consistent empty/error states so users understand the product limits without support intervention.

## Exact Scope

- Add a basic help center for MVP workflows.
- Add reusable empty, error, and loading components.
- Wire these states into dashboard, feed creation, and feed detail screens.
- Do not build a searchable help CMS.

## Files/modules to create or modify

- Create `src/app/help/page.jsx`
- Create `src/app/help/create-a-feed/page.jsx`
- Create `src/app/help/output-formats/page.jsx`
- Create `src/app/help/troubleshooting/page.jsx`
- Create `src/components/empty-state.jsx`
- Create `src/components/error-state.jsx`
- Create `src/components/loading-state.jsx`
- Modify `src/app/dashboard/page.jsx`
- Modify `src/app/dashboard/feeds/new/page.jsx`
- Modify `src/app/dashboard/feeds/[feedId]/page.jsx`
- Create `src/test/help-and-states.test.mjs`

## Database changes

None.

## API changes

None.

## Frontend changes

- Help pages explain:
  - how to create a feed
  - native feed vs webpage extraction
  - RSS, JSON, and CSV outputs
  - common errors: unsafe URL, no feed found, blocked source, empty feed
- Empty states link to the next useful action.
- Error states show the API error message and request ID.

## Backend changes

None.

## Tests required

- Help index links to all MVP help pages.
- Feed creation error state displays request ID.
- Dashboard empty state links to `/dashboard/feeds/new`.
- Feed detail empty item state links to troubleshooting help.

## Acceptance criteria

- First-time users can understand the MVP workflow from in-app help.
- API failures are visible and actionable.
- No help page describes advanced features as currently available.
- `bun run test` passes.
- `bun run check` passes.

## Dependencies

- `S03-T01-dashboard-shell.md`
- `S03-T02-feed-creation-ui.md`
- `S03-T03-feed-detail-ui.md`

