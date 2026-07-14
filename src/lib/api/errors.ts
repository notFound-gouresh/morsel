export type ApiErrorDetails = Record<string, unknown>;

export class MorselApiError extends Error {
  readonly status: number;
  readonly code: string;
  readonly details: ApiErrorDetails;

  constructor(
    status: number,
    code: string,
    message: string,
    details: ApiErrorDetails = {},
  ) {
    super(message);
    this.name = "MorselApiError";
    this.status = status;
    this.code = code;
    this.details = details;
  }
}
