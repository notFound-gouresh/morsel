import {
  FeedItemStatus,
  FeedSourceKind,
  type Feed,
  type FeedItem,
  type FeedSourceType,
  type Prisma,
} from "@prisma/client";

import { getDb } from "../client.ts";

export type CreateFeedInput = {
  workspaceId: string;
  createdByUserId: string;
  name: string;
  slug: string;
  sourceType: FeedSourceType;
  sourceUrl: string;
  refreshIntervalMinutes: number;
};

export function createFeed({
  workspaceId,
  createdByUserId,
  name,
  slug,
  sourceType,
  sourceUrl,
  refreshIntervalMinutes,
}: CreateFeedInput): Promise<Feed> {
  return getDb().feed.create({
    data: {
      workspaceId,
      createdByUserId,
      name,
      slug,
      sourceType,
      sourceUrl,
      refreshIntervalMinutes,
      sources: {
        create: {
          kind: FeedSourceKind.URL,
          url: sourceUrl,
        },
      },
    },
  });
}

export type FeedItemInput = {
  fingerprint: string;
  sourceItemId?: string | null;
  canonicalUrl?: string | null;
  url?: string | null;
  title?: string | null;
  descriptionText?: string | null;
  descriptionHtml?: string | null;
  author?: string | null;
  authors?: Prisma.InputJsonValue;
  imageUrl?: string | null;
  imageProxyUrl?: string | null;
  datePublished?: Date | null;
  dateModified?: Date | null;
  raw?: Prisma.InputJsonValue;
  status?: FeedItemStatus;
  filterReason?: Prisma.InputJsonValue;
  isPinned?: boolean;
};

export type UpsertFeedItemInput = {
  workspaceId: string;
  feedId: string;
  item: FeedItemInput;
};

export function upsertFeedItem({
  workspaceId,
  feedId,
  item,
}: UpsertFeedItemInput): Promise<FeedItem> {
  const now = new Date();
  const mutableData = {
    sourceItemId: item.sourceItemId,
    canonicalUrl: item.canonicalUrl,
    url: item.url,
    title: item.title,
    descriptionText: item.descriptionText,
    descriptionHtml: item.descriptionHtml,
    author: item.author,
    authors: item.authors,
    imageUrl: item.imageUrl,
    imageProxyUrl: item.imageProxyUrl,
    datePublished: item.datePublished,
    dateModified: item.dateModified,
    raw: item.raw,
    status: item.status,
    filterReason: item.filterReason,
    isPinned: item.isPinned,
  } satisfies Prisma.FeedItemUpdateInput;

  return getDb().feedItem.upsert({
    where: {
      feedId_fingerprint: {
        feedId,
        fingerprint: item.fingerprint,
      },
    },
    create: {
      workspaceId,
      feedId,
      fingerprint: item.fingerprint,
      ...mutableData,
      status: item.status ?? FeedItemStatus.ACTIVE,
      firstSeenAt: now,
      lastSeenAt: now,
    },
    update: {
      ...mutableData,
      lastSeenAt: now,
    },
  });
}
