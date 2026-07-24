-- DropForeignKey
ALTER TABLE "feed_filters" DROP CONSTRAINT "feed_filters_feed_id_fkey";

-- DropForeignKey
ALTER TABLE "feed_items" DROP CONSTRAINT "feed_items_feed_id_fkey";

-- DropForeignKey
ALTER TABLE "feed_refresh_jobs" DROP CONSTRAINT "feed_refresh_jobs_feed_id_fkey";

-- CreateIndex
CREATE UNIQUE INDEX "feeds_id_workspace_id_key" ON "feeds"("id", "workspace_id");

-- AddForeignKey
ALTER TABLE "feed_items" ADD CONSTRAINT "feed_items_feed_id_workspace_id_fkey" FOREIGN KEY ("feed_id", "workspace_id") REFERENCES "feeds"("id", "workspace_id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "feed_filters" ADD CONSTRAINT "feed_filters_feed_id_workspace_id_fkey" FOREIGN KEY ("feed_id", "workspace_id") REFERENCES "feeds"("id", "workspace_id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "feed_refresh_jobs" ADD CONSTRAINT "feed_refresh_jobs_feed_id_workspace_id_fkey" FOREIGN KEY ("feed_id", "workspace_id") REFERENCES "feeds"("id", "workspace_id") ON DELETE CASCADE ON UPDATE CASCADE;
