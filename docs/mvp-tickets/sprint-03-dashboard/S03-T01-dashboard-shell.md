# S03-T01: Authenticated Dashboard Shell

Sprint: 03 - User Dashboard

## Objective

Create the authenticated dashboard shell for the MVP feed workflow.

## Exact Scope

- Add protected `/dashboard` route.
- Add workspace-aware page layout.
- Add navigation for feeds, create feed, settings, and help.
- Replace the current marketing/demo-only homepage flow with links into the authenticated product.
- Do not build feed creation UI or feed detail UI in this ticket.

## Files/modules to create or modify

- Create `src/app/dashboard/layout.jsx`
- Create `src/app/dashboard/page.jsx`
- Create `src/app/dashboard/loading.jsx`
- Create `src/components/app-shell.jsx`
- Create `src/components/workspace-switcher.jsx`
- Modify `src/app/page.jsx`
- Modify `src/app/globals.css`
- Create `src/test/dashboard-shell.test.mjs`

## Database changes

None.

## API changes

Uses existing `GET /api/me`.

## Frontend changes

- Protected dashboard shell checks session.
- Dashboard index shows:
  - empty-state create feed action
  - recent feeds placeholder driven by API response
  - account/workspace identity
- Navigation uses real links:
  - `/dashboard`
  - `/dashboard/feeds/new`
  - `/dashboard/settings`
  - `/help`

## Backend changes

- Add server-side redirect to `/login` when unauthenticated.
- No new backend routes.

## Tests required

- Unauthenticated dashboard request redirects to `/login`.
- Authenticated dashboard renders workspace name.
- Homepage includes links to signup and login.
- App shell renders navigation labels and links.

## Acceptance criteria

- Authenticated users can land in a real app surface after login/signup.
- Unauthenticated users cannot access dashboard pages.
- Existing demo page no longer implies unsupported MVP features.
- `bun run test` passes.
- `bun run check` passes.

## Dependencies

- `S00-T03-auth-and-default-workspace.md`

