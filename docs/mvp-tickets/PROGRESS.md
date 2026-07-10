# Morsel MVP Progress

Last updated: 2026-07-09

Use this file to help Codex agents understand the current implementation state without rereading the full PRD. Update it after every ticket.

## Current State

- Current sprint: Sprint 00 - Foundation
- Current ticket: `S00-T01-runtime-config-and-errors.md`
- Release stage: pre-alpha, internal development only
- User-facing release: not ready

## How to Update This File

After each ticket, update:

- Ticket status.
- Commit hash or branch if available.
- Commands run.
- Blockers or human inputs needed.
- Environment variables needed for the next ticket.
- Draft release notes for the sprint if user-visible behavior changed.

Status values:

- `Not Started`
- `In Progress`
- `Blocked`
- `Done`

## Environment Notes

Do not write real secrets in this file.

| Need | Required By | Status | Notes |
| --- | --- | --- | --- |
| `APP_URL` | S00-T01 | Needed | Local value can be `http://localhost:3000`. |
| `DATABASE_URL` | S00-T02 | Needed later | Use PostgreSQL. Store only in `.env.local`. |
| `SESSION_SECRET` | S00-T01, S00-T03 | Needed | Must be at least 32 characters. Store only in `.env.local`. |
| `CRAWLER_USER_AGENT` | S00-T01, S01-T02 | Needed | Use an identifiable product user agent. |
| `FETCH_TIMEOUT_MS` | S00-T01, S01-T02 | Needed | Suggested local value: `10000`. |
| `FETCH_MAX_BYTES` | S00-T01, S01-T02 | Needed | Suggested local value: `2000000`. |
| `MANUAL_REFRESH_COOLDOWN_SECONDS` | S00-T01, S04-T03 | Needed | Suggested local value: `300`. |
| External provider keys | Later advanced features | Not needed for MVP | No Stripe, Slack, Discord, Telegram, or email keys in strict MVP. |

## Ticket Status

| Ticket | Status | Branch/Commit | Commands Run | Notes |
| --- | --- | --- | --- | --- |
| S00-T01 Runtime Config and API Errors | Not Started |  |  | First implementation ticket. |
| S00-T02 Database Schema and Client | Not Started |  |  | Needs PostgreSQL `DATABASE_URL`. |
| S00-T03 Auth and Default Workspace | Not Started |  |  | Needs `SESSION_SECRET`. |
| S00-T04 Authorization and Audit Logs | Not Started |  |  |  |
| S01-T01 URL Safety and SSRF Protection | Not Started |  |  |  |
| S01-T02 HTTP Fetcher and Robots Policy | Not Started |  |  | Needs crawler env values. |
| S01-T03 Native Feed Parser and Fingerprints | Not Started |  |  |  |
| S01-T04 Feed Renderers | Not Started |  |  |  |
| S02-T01 Native Feed Discovery | Not Started |  |  |  |
| S02-T02 Static HTML Extractor | Not Started |  |  |  |
| S02-T03 Feed Discover Preview API | Not Started |  |  |  |
| S02-T04 Feed Save and Items API | Not Started |  |  |  |
| S02-T05 Public RSS, JSON, and CSV Output Endpoints | Not Started |  |  |  |
| S03-T01 Authenticated Dashboard Shell | Not Started |  |  | First user-facing sprint starts here. |
| S03-T02 Feed Creation UI | Not Started |  |  |  |
| S03-T03 Feed Detail UI | Not Started |  |  |  |
| S03-T04 Help, Empty States, and Error States | Not Started |  |  |  |
| S04-T01 Refresh Queue and Worker Shell | Not Started |  |  | MVP uses database-backed jobs first. |
| S04-T02 Refresh Worker Pipeline | Not Started |  |  |  |
| S04-T03 Manual Refresh API and Throttle | Not Started |  |  |  |
| S04-T04 Scheduler and Feed Health | Not Started |  |  |  |
| S05-T01 Basic Filter Engine | Not Started |  |  |  |
| S05-T02 Filter API | Not Started |  |  |  |
| S05-T03 Filter UI | Not Started |  |  |  |
| S05-T04 Rate Limits and Observability | Not Started |  |  |  |
| S05-T05 MVP Production Readiness Gate | Not Started |  |  |  |

## Sprint Release Notes Draft

### Sprint 00 - Foundation

Release type: internal only.

Expected user-facing change: none.

Message: Core app infrastructure is being prepared so accounts, workspaces, database records, and future feed workflows are reliable.

### Sprint 01 - Feed Engine Core

Release type: internal only.

Expected user-facing change: none.

Message: The feed engine can safely validate URLs, fetch public documents, parse native RSS/Atom feeds, fingerprint items, and render feed outputs internally.

### Sprint 02 - Discovery and Creation APIs

Release type: internal/API preview.

Expected user-facing change: technical testers may be able to create and inspect feeds through APIs.

Message: URL-to-feed creation is available behind the scenes, including preview, save, item storage, and RSS/JSON/CSV endpoints.

### Sprint 03 - User Dashboard

Release type: private alpha.

Expected user-facing change: early users can sign up, create a feed from a URL, preview items, save feeds, and copy output links.

Message: Private alpha is open for creating your first feeds and using RSS, JSON, and CSV links.

### Sprint 04 - Refresh Jobs

Release type: alpha update.

Expected user-facing change: saved feeds refresh automatically, users can manually refresh, and feed health is visible.

Message: Feeds now update automatically and show refresh status, making Morsel usable for real monitoring workflows.

### Sprint 05 - Filters and Production Hardening

Release type: MVP beta.

Expected user-facing change: users can filter noisy feed items, see better errors, and rely on a more stable beta product.

Message: MVP beta is ready with feed creation, auto-refresh, output links, basic filtering, safer rate limits, and production readiness checks.

## Blockers

No blockers recorded yet.

## Decisions

- Use PostgreSQL plus Prisma for the MVP database path.
- Use database-backed refresh jobs for MVP before adding Redis/BullMQ.
- Keep keyword/topic feed creation out of strict MVP; consider Google News keyword feeds as a post-MVP or MVP+ ticket.
- Keep advanced integrations out of strict MVP until feed creation, refresh, filtering, and outputs are production-ready.
