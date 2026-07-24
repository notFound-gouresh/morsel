import { PrismaClient } from "@prisma/client";

const globalForPrisma = globalThis as typeof globalThis & {
  morselDb?: PrismaClient;
};

const db = globalForPrisma.morselDb ?? new PrismaClient();

if (process.env.NODE_ENV !== "production") {
  globalForPrisma.morselDb = db;
}

export function getDb(): PrismaClient {
  return db;
}
