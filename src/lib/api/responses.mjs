import { randomUUID } from "node:crypto";

import { MorselApiError } from "./errors.mjs";

export function createRequestId() {
  return randomUUID();
}

function responseInit(init, defaultStatus) {
  const { requestId = createRequestId(), headers, ...rest } = init;
  const responseHeaders = new Headers(headers);
  responseHeaders.set("x-request-id", requestId);

  return {
    requestId,
    init: {
      status: defaultStatus,
      ...rest,
      headers: responseHeaders,
    },
  };
}

export function jsonOk(data, init = {}) {
  const response = responseInit(init, 200);

  return Response.json(
    {
      data,
      requestId: response.requestId,
    },
    response.init,
  );
}

export function jsonError(error, init = {}) {
  const apiError =
    error instanceof MorselApiError
      ? error
      : new MorselApiError(
          500,
          "INTERNAL_ERROR",
          "An unexpected error occurred.",
        );
  const response = responseInit(
    { ...init, status: apiError.status },
    apiError.status,
  );

  return Response.json(
    {
      error: {
        code: apiError.code,
        message: apiError.message,
        details: apiError.details,
      },
      requestId: response.requestId,
    },
    response.init,
  );
}
