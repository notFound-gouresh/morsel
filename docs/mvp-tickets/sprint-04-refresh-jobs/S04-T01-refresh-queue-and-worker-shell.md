# S04-T01: Refresh Queue and Worker Shell

Sprint: 04 - Refresh Jobs

## Objective

Add the MVP background job infrastructure for feed refreshes.

## Exact Scope

- Add a queue abstraction for refresh jobs.
- Add a worker entrypoint script.
- Add a scheduler entrypoint placeholder that will enqueue due feeds in S04-T04.
- Add package scripts to run worker and scheduler.
- Do not implement the refresh pipeline in this ticket.

## Files/modules to create or modify

- Modify `package.json`
- Create `src/lib/jobs/refresh-queue.mjs`
- Create `src/lib/jobs/job-locks.mjs`
- Create `src/workers/refresh-worker.mjs`
- Create `src/workers/scheduler.mjs`
- Create `src/test/refresh-queue.test.mjs`
- Modify `README.md`

## Database changes

- Use `feed_refresh_jobs`.
- Add fields if absent:
  - `locked_at`
  - `locked_by`
  - `next_retry_at`
  - `attempt`

## API changes

None.

## Frontend changes

None.

## Backend changes

- Implement `enqueueRefreshJob({ workspaceId, feedId, trigger, priority })`.
- Implement `claimNextRefreshJob({ workerId })`.
- Implement `completeRefreshJob({ jobId, result })`.
- Implement `failRefreshJob({ jobId, error, retryAt })`.
- Add scripts:
  - `bun run worker:refresh`
  - `bun run scheduler`
- Use database-backed queue semantics for MVP to avoid requiring Redis before product-market validation.

## Tests required

- Enqueue creates a queued job.
- Claim returns oldest highest-priority queued job.
- Claim skips jobs locked by another worker.
- Complete marks job succeeded with timestamps.
- Fail marks job failed and records error code/message.

## Acceptance criteria

- Worker can start and exit cleanly with no jobs.
- Queue functions are deterministic under tests.
- README documents running web app, worker, and scheduler locally.
- `bun run test` passes.
- `bun run check` passes.

## Dependencies

- `S00-T02-database-schema-and-client.md`

