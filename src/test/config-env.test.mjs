import assert from "node:assert/strict";
import test from "node:test";

import { loadEnv } from "../lib/config/env.mjs";

const validEnv = {
  APP_URL: "http://localhost:3000/",
  DATABASE_URL: "postgresql://morsel:password@localhost:5432/morsel",
  SESSION_SECRET: "a-secure-session-secret-with-32-chars",
  CRAWLER_USER_AGENT: "MorselBot/1.0 (+https://example.com/bot)",
  FETCH_TIMEOUT_MS: "10000",
  FETCH_MAX_BYTES: "2000000",
  MANUAL_REFRESH_COOLDOWN_SECONDS: "300",
};

test("loads environment values and normalizes numeric limits", () => {
  const env = loadEnv(validEnv);

  assert.equal(env.APP_URL, "http://localhost:3000");
  assert.equal(env.FETCH_TIMEOUT_MS, 10_000);
  assert.equal(env.FETCH_MAX_BYTES, 2_000_000);
  assert.equal(env.MANUAL_REFRESH_COOLDOWN_SECONDS, 300);
});

test("strips multiple trailing slashes from APP_URL", () => {
  const env = loadEnv({ ...validEnv, APP_URL: "https://example.com///" });

  assert.equal(env.APP_URL, "https://example.com");
});

test("throws when DATABASE_URL is missing", () => {
  const { DATABASE_URL: _databaseUrl, ...envWithoutDatabase } = validEnv;

  assert.throws(
    () => loadEnv(envWithoutDatabase),
    /DATABASE_URL is required/,
  );
});

test("throws when SESSION_SECRET is shorter than 32 characters", () => {
  assert.throws(
    () => loadEnv({ ...validEnv, SESSION_SECRET: "too-short" }),
    /SESSION_SECRET must be at least 32 characters/,
  );
});
