# S00-T03: Auth and Default Workspace

Sprint: 00 - Foundation

## Objective

Implement simple production-safe email/password auth with session cookies and automatic default workspace creation.

## Exact Scope

- Add password hashing and verification.
- Add signup, login, logout, and current-user APIs.
- Create a default workspace and owner membership when a user signs up.
- Add secure session cookie handling.
- Add minimal login/signup pages.
- Do not add OAuth, MFA, password reset email, team invitations, or billing.

## Files/modules to create or modify

- Create `src/lib/auth/password.mjs`
- Create `src/lib/auth/session.mjs`
- Create `src/lib/auth/current-user.mjs`
- Create `src/app/api/auth/signup/route.js`
- Create `src/app/api/auth/login/route.js`
- Create `src/app/api/auth/logout/route.js`
- Create `src/app/api/me/route.js`
- Create `src/app/login/page.jsx`
- Create `src/app/signup/page.jsx`
- Modify `src/app/layout.jsx`
- Create `src/test/auth-password.test.mjs`
- Create `src/test/auth-session.test.mjs`
- Create `src/test/auth-routes.test.mjs`

## Database changes

- Use existing `users`, `workspaces`, and `workspace_members` tables from S00-T02.
- Add a migration only if S00-T02 did not include `password_hash`, `last_login_at`, or session metadata fields.

## API changes

Create:

- `POST /api/auth/signup`
  - Body: `{ "email": "...", "password": "...", "name": "..." }`
  - Response: current user and default workspace.
- `POST /api/auth/login`
  - Body: `{ "email": "...", "password": "..." }`
  - Response: current user and active workspace.
- `POST /api/auth/logout`
  - Response: `{ "ok": true }`
- `GET /api/me`
  - Response: current user and workspaces.

## Frontend changes

- Add simple login and signup forms.
- Show validation errors using the shared API error envelope.
- Redirect authenticated users to `/dashboard`.
- Link unauthenticated homepage users to `/signup` and `/login`.

## Backend changes

- Use Argon2 or bcrypt with a cost appropriate for production.
- Store only password hashes.
- Set session cookies as `HttpOnly`, `Secure` in production, `SameSite=Lax`, and signed/encrypted using `SESSION_SECRET`.
- Normalize emails to lowercase before lookup.
- Create default workspace slug from email prefix with collision handling.

## Tests required

- Password hashing produces non-plain hashes and verifies valid passwords.
- Signup creates user, workspace, and owner membership.
- Duplicate signup returns `EMAIL_TAKEN`.
- Login rejects wrong password.
- Logout clears session cookie.
- `/api/me` rejects missing session and returns user/workspaces for valid session.

## Acceptance criteria

- A new user can sign up and land in a default workspace.
- A returning user can log in and access `/dashboard`.
- Session cookies use secure attributes.
- `bun run test` passes.
- `bun run check` passes.

## Dependencies

- `S00-T01-runtime-config-and-errors.md`
- `S00-T02-database-schema-and-client.md`

