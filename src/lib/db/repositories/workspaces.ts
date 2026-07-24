import { WorkspaceRole, type Workspace } from "@prisma/client";

import { getDb } from "../client.ts";

export type CreateWorkspaceWithOwnerInput = {
  userId: string;
  name: string;
  slug: string;
};

export function createWorkspaceWithOwner({
  userId,
  name,
  slug,
}: CreateWorkspaceWithOwnerInput): Promise<Workspace> {
  return getDb().workspace.create({
    data: {
      name,
      slug,
      ownerUserId: userId,
      members: {
        create: {
          userId,
          role: WorkspaceRole.OWNER,
          joinedAt: new Date(),
        },
      },
    },
  });
}
