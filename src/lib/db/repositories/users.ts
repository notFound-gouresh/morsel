import type { User } from "@prisma/client";

import { getDb } from "../client.ts";

export type CreateUserInput = {
  email: string;
  passwordHash: string | null;
  name?: string | null;
};

export function createUser({
  email,
  passwordHash,
  name,
}: CreateUserInput): Promise<User> {
  return getDb().user.create({
    data: {
      email: email.trim().toLowerCase(),
      passwordHash,
      name,
    },
  });
}
