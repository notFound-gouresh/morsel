export class MorselApiError extends Error {
  constructor(status, code, message, details = {}) {
    super(message);
    this.name = "MorselApiError";
    this.status = status;
    this.code = code;
    this.details = details;
  }
}
