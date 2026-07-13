import { loadLimits } from "./limits.mjs";

const MIN_SESSION_SECRET_LENGTH = 32;

function requiredString(overrides, name) {
  const value = overrides[name]?.trim();

  if (!value) {
    throw new Error(`${name} is required.`);
  }

  return value;
}

function appUrl(overrides) {
  const value = requiredString(overrides, "APP_URL");
  let url;

  try {
    url = new URL(value);
  } catch {
    throw new Error("APP_URL must be a valid URL.");
  }

  if (!["http:", "https:"].includes(url.protocol)) {
    throw new Error("APP_URL must use http or https.");
  }

  return value.replace(/\/$/, "");
}

export function loadEnv(overrides = process.env) {
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
