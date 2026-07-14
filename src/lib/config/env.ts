import { loadLimits } from "./limits.ts";

type EnvOverrides = Record<string, string | undefined>;

const MIN_SESSION_SECRET_LENGTH = 32;

function requiredString(overrides: EnvOverrides, name: string): string {
  const value = overrides[name]?.trim();

  if (!value) {
    throw new Error(`${name} is required.`);
  }

  return value;
}

function appUrl(overrides: EnvOverrides): string {
  const value = requiredString(overrides, "APP_URL");
  let url: URL;

  try {
    url = new URL(value);
  } catch {
    throw new Error("APP_URL must be a valid URL.");
  }

  if (!["http:", "https:"].includes(url.protocol)) {
    throw new Error("APP_URL must use http or https.");
  }

  return value.replace(/\/+$/, "");
}

export function loadEnv(overrides: EnvOverrides = process.env) {
  const SESSION_SECRET = requiredString(overrides, "SESSION_SECRET");

  if (SESSION_SECRET.length < MIN_SESSION_SECRET_LENGTH) {
    throw new Error(
      `SESSION_SECRET must be at least ${MIN_SESSION_SECRET_LENGTH} characters.`,
    );
  }

  return {
    APP_URL: appUrl(overrides),
    DATABASE_URL: requiredString(overrides, "DATABASE_URL"),
    SESSION_SECRET,
    CRAWLER_USER_AGENT: requiredString(overrides, "CRAWLER_USER_AGENT"),
    ...loadLimits(overrides),
  };
}
