# S00-T02: Database Schema and Client

Sprint: 00 - Foundation

## Objective

Add the MVP relational database foundation for users, workspaces, feeds, sources, items, refresh jobs, filters, audit logs, error logs, and usage counters.

## Exact Scope

- Add Prisma as the MVP ORM.
- Add the MVP schema and migrations.
- Add a reusable database client module.
- Add seed data for a development user/workspace/feed fixture.
- Add schema-level uniqueness and indexes needed by later tickets.
- Do not implement auth, feed parsing, refresh workers, or UI in this ticket.

## Files/modules to create or modify

- Modify `package.json`
- Create `prisma/schema.prisma`
- Create `prisma/seed.mjs`
- Create `src/lib/db/client.mjs`
- Create `src/lib/db/repositories/users.mjs`
- Create `src/lib/db/repositories/workspaces.mjs`
- Create `src/lib/db/repositories/feeds.mjs`
- Create `src/lib/db/repositories/jobs.mjs`
- Create `src/test/db-schema.test.mjs`
- Modify `.env.example`
- Modify `README.md`

## Database changes

Create these tables through Prisma migrations:

- `users`
- `workspaces`
- `workspace_members`
- `feeds`
- `feed_sources`
- `feed_items`
- `feed_filters`
- `feed_refresh_jobs`
- `audit_logs`
- `error_logs`
- `usage_limits`

Required constraints:

- Unique `users.email`.
- Unique `(workspaces.slug)`.
- Unique `(workspace_members.workspace_id, workspace_members.user_id)`.
- Unique `(feeds.workspace_id, feeds.slug)`.
- Unique `(feed_items.feed_id, feed_items.fingerprint)`.
- Index `feeds.next_refresh_at`.
- Index `feed_refresh_jobs.feed_id, created_at`.
- Index `error_logs.feed_id, created_at`.

## API changes

None.

## Frontend changes

None.

## Backend changes

- Add `getDb()` that returns a single Prisma client in development and a fresh-safe client in production.
- Add repository helpers:
  - `createUser({ email, passwordHash, name })`
  - `createWorkspaceWithOwner({ userId, name, slug })`
  - `createFeed({ workspaceId, createdByUserId, name, slug, sourceType, sourceUrl, refreshIntervalMinutes })`
  - `upsertFeedItem({ workspaceId, feedId, item })`
  - `createRefreshJob({ workspaceId, feedId, trigger, status })`
- Store flexible extraction and rendering settings in JSON columns only where the PRD calls for configuration.

## Tests required

- `src/test/db-schema.test.mjs`
  - Creates a user and workspace.
  - Rejects duplicate user email.
  - Rejects duplicate feed slug inside the same workspace.
  - Allows the same feed slug in a different workspace.
  - Rejects duplicate item fingerprint inside the same feed.

## Acceptance criteria

- `bunx prisma generate` succeeds.
- `bunx prisma migrate dev` creates the MVP schema locally.
- `bun run test` passes against a local test database.
- `bun run check` passes.
- Later tickets can import `getDb()` and repository helpers without touching Prisma setup.

## Dependencies

- `S00-T01-runtime-config-and-errors.md`

