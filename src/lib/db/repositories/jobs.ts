import type {
  FeedRefreshJob,
  RefreshJobStatus,
  RefreshTrigger,
} from "@prisma/client";

import { getDb } from "../client.ts";

export type CreateRefreshJobInput = {
  workspaceId: string;
  feedId: string;
  trigger: RefreshTrigger;
  status: RefreshJobStatus;
};

export function createRefreshJob({
  workspaceId,
  feedId,
  trigger,
  status,
}: CreateRefreshJobInput): Promise<FeedRefreshJob> {
  return getDb().feedRefreshJob.create({
    data: {
      workspaceId,
      feedId,
      trigger,
      status,
    },
  });
}
