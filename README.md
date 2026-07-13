# Morsel

Small bites from the live web.

Morsel is a Next.js product concept for turning websites, newsletters, and
social sources into clean feeds, embeddable widgets, automation bots,
integrations, and monitoring workflows.

## Run

Copy `.env.example` to `.env.local`, replace the placeholder values, then install
dependencies and start the development server:

```bash
cp .env.example .env.local
bun install
bun run dev
```

Required environment variables:

- `APP_URL`: Public base URL for the app. Use `http://localhost:3000` locally.
- `DATABASE_URL`: PostgreSQL connection URL.
- `SESSION_SECRET`: Random session secret containing at least 32 characters.
- `CRAWLER_USER_AGENT`: Identifiable user agent sent by the crawler.
- `FETCH_TIMEOUT_MS`: Positive request timeout in milliseconds.
- `FETCH_MAX_BYTES`: Positive maximum response size in bytes.
- `MANUAL_REFRESH_COOLDOWN_SECONDS`: Positive cooldown between manual refreshes.

## Verify

```bash
bun run check
```

The check command runs the Node test suite and a production Next.js build.
