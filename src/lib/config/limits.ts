type EnvOverrides = Record<string, string | undefined>;

function positiveInteger(value: string | undefined, name: string): number {
  const normalized = typeof value === "string" ? value.trim() : value;
  const number = Number(normalized);

  if (!Number.isSafeInteger(number) || number <= 0) {
    throw new Error(`${name} must be a positive integer.`);
  }

  return number;
}

export function loadLimits(overrides: EnvOverrides = process.env) {
  return {
    FETCH_TIMEOUT_MS: positiveInteger(
      overrides.FETCH_TIMEOUT_MS,
      "FETCH_TIMEOUT_MS",
    ),
    FETCH_MAX_BYTES: positiveInteger(
      overrides.FETCH_MAX_BYTES,
      "FETCH_MAX_BYTES",
    ),
    MANUAL_REFRESH_COOLDOWN_SECONDS: positiveInteger(
      overrides.MANUAL_REFRESH_COOLDOWN_SECONDS,
      "MANUAL_REFRESH_COOLDOWN_SECONDS",
    ),
  };
}
