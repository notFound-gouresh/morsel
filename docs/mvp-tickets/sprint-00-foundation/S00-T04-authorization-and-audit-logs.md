# S00-T04: Authorization and Audit Logs

Sprint: 00 - Foundation

## Objective

Add workspace authorization helpers and audit logging so all later feed APIs enforce tenant boundaries.

## Exact Scope

- Add role checks for owner, editor, and viewer access.
- Add an audit log helper.
- Add request context creation for API routes.
- Protect future route handlers from cross-workspace access mistakes.
- Do not build team invitations or multi-member UI in this ticket.

## Files/modules to create or modify

- Create `src/lib/auth/workspace-access.mjs`
- Create `src/lib/api/request-context.mjs`
- Create `src/lib/audit/audit-log.mjs`
- Create `src/test/workspace-access.test.mjs`
- Create `src/test/audit-log.test.mjs`
- Modify `src/lib/db/repositories/workspaces.mjs`
- Modify `src/lib/db/repositories/users.mjs`

## Database changes

- Use `workspace_members` and `audit_logs` from S00-T02.
- Add indexes only if absent:
  - `(workspace_id, created_at)` on `audit_logs`
  - `(actor_user_id, created_at)` on `audit_logs`

## API changes

None visible to users. Future API handlers should call:

- `requireUser(request)`
- `requireWorkspaceRole({ userId, workspaceId, roles })`
- `createRequestContext(request)`

## Frontend changes

None.

## Backend changes

- Implement role hierarchy:
  - `owner` can read and write all MVP workspace resources.
  - `editor` can create and modify feeds, filters, and refresh jobs.
  - `viewer` can read feeds and items but cannot mutate.
- Implement `writeAuditLog({ workspaceId, actorUserId, action, targetType, targetId, metadata })`.
- Log these actions from existing auth code:
  - `auth.signup`
  - `auth.login`
  - `auth.logout`

## Tests required

- Owner is authorized for owner/editor/viewer checks.
- Editor is authorized for editor/viewer checks and rejected for owner checks.
- Viewer is authorized for viewer checks and rejected for editor checks.
- A user from another workspace is rejected.
- Audit helper writes the expected action and metadata.

## Acceptance criteria

- Any route can call one helper to establish user and workspace context.
- Cross-workspace reads and writes are rejected in tests.
- Auth actions write audit log rows.
- `bun run test` passes.
- `bun run check` passes.

## Dependencies

- `S00-T02-database-schema-and-client.md`
- `S00-T03-auth-and-default-workspace.md`

