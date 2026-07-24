-- EnableExtension
CREATE EXTENSION IF NOT EXISTS "citext";

-- CreateEnum
CREATE TYPE "workspace_status" AS ENUM ('active', 'trialing', 'past_due', 'suspended', 'deleted');

-- CreateEnum
CREATE TYPE "workspace_role" AS ENUM ('owner', 'admin', 'editor', 'viewer', 'billing', 'support');

-- CreateEnum
CREATE TYPE "feed_status" AS ENUM ('draft', 'active', 'paused', 'degraded', 'failed', 'deleted');

-- CreateEnum
CREATE TYPE "feed_visibility" AS ENUM ('public', 'private', 'unlisted');

-- CreateEnum
CREATE TYPE "feed_source_type" AS ENUM ('native', 'webpage', 'visual', 'platform', 'search', 'newsletter');

-- CreateEnum
CREATE TYPE "feed_source_kind" AS ENUM ('url', 'rss', 'atom', 'jsonfeed', 'sitemap', 'visual_recipe', 'platform_adapter', 'newsletter_address', 'search_query');

-- CreateEnum
CREATE TYPE "feed_item_status" AS ENUM ('active', 'filtered', 'hidden', 'deleted');

-- CreateEnum
CREATE TYPE "feed_filter_scope" AS ENUM ('workspace', 'feed');

-- CreateEnum
CREATE TYPE "feed_filter_type" AS ENUM ('whitelist', 'blacklist', 'field_rule', 'missing_field', 'dedup', 'similarity');

-- CreateEnum
CREATE TYPE "refresh_trigger" AS ENUM ('scheduled', 'manual', 'initial', 'retry', 'admin');

-- CreateEnum
CREATE TYPE "refresh_job_status" AS ENUM ('queued', 'running', 'succeeded', 'failed', 'cancelled');

-- CreateEnum
CREATE TYPE "error_severity" AS ENUM ('info', 'warning', 'error', 'critical');

-- CreateTable
CREATE TABLE "users" (
    "id" UUID NOT NULL,
    "email" CITEXT NOT NULL,
    "email_verified_at" TIMESTAMPTZ,
    "name" TEXT,
    "avatar_url" TEXT,
    "password_hash" TEXT,
    "timezone" TEXT NOT NULL DEFAULT 'UTC',
    "mfa_enabled" BOOLEAN NOT NULL DEFAULT false,
    "last_login_at" TIMESTAMPTZ,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ NOT NULL,

    CONSTRAINT "users_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "workspaces" (
    "id" UUID NOT NULL,
    "name" TEXT NOT NULL,
    "slug" TEXT NOT NULL,
    "owner_user_id" UUID NOT NULL,
    "billing_email" CITEXT,
    "status" "workspace_status" NOT NULL DEFAULT 'active',
    "logo_url" TEXT,
    "settings" JSONB NOT NULL DEFAULT '{}',
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ NOT NULL,

    CONSTRAINT "workspaces_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "workspace_members" (
    "id" UUID NOT NULL,
    "workspace_id" UUID NOT NULL,
    "user_id" UUID NOT NULL,
    "role" "workspace_role" NOT NULL,
    "invited_by_user_id" UUID,
    "invited_email" CITEXT,
    "invitation_token_hash" TEXT,
    "invitation_expires_at" TIMESTAMPTZ,
    "joined_at" TIMESTAMPTZ,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "workspace_members_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "feeds" (
    "id" UUID NOT NULL,
    "workspace_id" UUID NOT NULL,
    "name" TEXT NOT NULL,
    "slug" TEXT NOT NULL,
    "description" TEXT,
    "status" "feed_status" NOT NULL DEFAULT 'draft',
    "visibility" "feed_visibility" NOT NULL DEFAULT 'private',
    "source_type" "feed_source_type" NOT NULL,
    "source_url" TEXT NOT NULL,
    "public_rss_url" TEXT,
    "public_json_url" TEXT,
    "public_csv_url" TEXT,
    "refresh_interval_minutes" INTEGER NOT NULL,
    "last_refreshed_at" TIMESTAMPTZ,
    "next_refresh_at" TIMESTAMPTZ,
    "last_success_at" TIMESTAMPTZ,
    "last_failure_at" TIMESTAMPTZ,
    "failure_count" INTEGER NOT NULL DEFAULT 0,
    "settings" JSONB NOT NULL DEFAULT '{}',
    "created_by_user_id" UUID NOT NULL,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ NOT NULL,
    "deleted_at" TIMESTAMPTZ,

    CONSTRAINT "feeds_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "feed_sources" (
    "id" UUID NOT NULL,
    "feed_id" UUID NOT NULL,
    "kind" "feed_source_kind" NOT NULL,
    "url" TEXT,
    "adapter_key" TEXT,
    "recipe" JSONB,
    "headers" JSONB,
    "robots_status" TEXT,
    "etag" TEXT,
    "last_modified" TEXT,
    "last_http_status" INTEGER,
    "last_fetch_duration_ms" INTEGER,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ NOT NULL,

    CONSTRAINT "feed_sources_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "feed_items" (
    "id" UUID NOT NULL,
    "workspace_id" UUID NOT NULL,
    "feed_id" UUID NOT NULL,
    "source_item_id" TEXT,
    "fingerprint" TEXT NOT NULL,
    "canonical_url" TEXT,
    "url" TEXT,
    "title" TEXT,
    "description_text" TEXT,
    "description_html" TEXT,
    "author" TEXT,
    "authors" JSONB NOT NULL DEFAULT '[]',
    "image_url" TEXT,
    "image_proxy_url" TEXT,
    "date_published" TIMESTAMPTZ,
    "date_modified" TIMESTAMPTZ,
    "raw" JSONB,
    "status" "feed_item_status" NOT NULL DEFAULT 'active',
    "filter_reason" JSONB,
    "is_pinned" BOOLEAN NOT NULL DEFAULT false,
    "first_seen_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "last_seen_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ NOT NULL,

    CONSTRAINT "feed_items_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "feed_filters" (
    "id" UUID NOT NULL,
    "workspace_id" UUID NOT NULL,
    "feed_id" UUID,
    "scope" "feed_filter_scope" NOT NULL,
    "name" TEXT,
    "type" "feed_filter_type" NOT NULL,
    "field" TEXT,
    "operator" TEXT,
    "value" JSONB,
    "is_enabled" BOOLEAN NOT NULL DEFAULT true,
    "order_index" INTEGER NOT NULL DEFAULT 0,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ NOT NULL,

    CONSTRAINT "feed_filters_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "feed_refresh_jobs" (
    "id" UUID NOT NULL,
    "workspace_id" UUID NOT NULL,
    "feed_id" UUID NOT NULL,
    "trigger" "refresh_trigger" NOT NULL,
    "status" "refresh_job_status" NOT NULL,
    "priority" INTEGER NOT NULL DEFAULT 0,
    "started_at" TIMESTAMPTZ,
    "finished_at" TIMESTAMPTZ,
    "attempt" INTEGER NOT NULL DEFAULT 0,
    "items_found" INTEGER NOT NULL DEFAULT 0,
    "items_new" INTEGER NOT NULL DEFAULT 0,
    "items_changed" INTEGER NOT NULL DEFAULT 0,
    "error_code" TEXT,
    "error_message" TEXT,
    "metadata" JSONB NOT NULL DEFAULT '{}',
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "feed_refresh_jobs_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "audit_logs" (
    "id" UUID NOT NULL,
    "workspace_id" UUID,
    "actor_user_id" UUID,
    "action" TEXT NOT NULL,
    "target_type" TEXT,
    "target_id" UUID,
    "ip_hash" TEXT,
    "user_agent_hash" TEXT,
    "metadata" JSONB NOT NULL DEFAULT '{}',
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "audit_logs_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "error_logs" (
    "id" UUID NOT NULL,
    "workspace_id" UUID,
    "feed_id" UUID,
    "job_id" UUID,
    "severity" "error_severity" NOT NULL,
    "source" TEXT,
    "code" TEXT,
    "message" TEXT NOT NULL,
    "details" JSONB NOT NULL DEFAULT '{}',
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "error_logs_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "usage_limits" (
    "id" UUID NOT NULL,
    "workspace_id" UUID NOT NULL,
    "period_start" TIMESTAMPTZ NOT NULL,
    "period_end" TIMESTAMPTZ NOT NULL,
    "metric" TEXT NOT NULL,
    "used" INTEGER NOT NULL DEFAULT 0,
    "limit" INTEGER,
    "metadata" JSONB NOT NULL DEFAULT '{}',
    "updated_at" TIMESTAMPTZ NOT NULL,

    CONSTRAINT "usage_limits_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "users_email_key" ON "users"("email");

-- CreateIndex
CREATE UNIQUE INDEX "workspaces_slug_key" ON "workspaces"("slug");

-- CreateIndex
CREATE INDEX "workspaces_owner_user_id_idx" ON "workspaces"("owner_user_id");

-- CreateIndex
CREATE INDEX "workspace_members_workspace_id_role_idx" ON "workspace_members"("workspace_id", "role");

-- CreateIndex
CREATE UNIQUE INDEX "workspace_members_workspace_id_user_id_key" ON "workspace_members"("workspace_id", "user_id");

-- CreateIndex
CREATE INDEX "feeds_workspace_id_status_idx" ON "feeds"("workspace_id", "status");

-- CreateIndex
CREATE INDEX "feeds_next_refresh_at_idx" ON "feeds"("next_refresh_at");

-- CreateIndex
CREATE INDEX "feeds_source_url_idx" ON "feeds"("source_url");

-- CreateIndex
CREATE UNIQUE INDEX "feeds_workspace_id_slug_key" ON "feeds"("workspace_id", "slug");

-- CreateIndex
CREATE INDEX "feed_sources_feed_id_idx" ON "feed_sources"("feed_id");

-- CreateIndex
CREATE INDEX "feed_sources_adapter_key_idx" ON "feed_sources"("adapter_key");

-- CreateIndex
CREATE INDEX "feed_items_workspace_feed_published_idx" ON "feed_items"("workspace_id", "feed_id", "date_published" DESC);

-- CreateIndex
CREATE INDEX "feed_items_canonical_url_idx" ON "feed_items"("canonical_url");

-- CreateIndex
CREATE UNIQUE INDEX "feed_items_feed_id_fingerprint_key" ON "feed_items"("feed_id", "fingerprint");

-- CreateIndex
CREATE INDEX "feed_filters_workspace_scope_enabled_idx" ON "feed_filters"("workspace_id", "scope", "is_enabled");

-- CreateIndex
CREATE INDEX "feed_filters_feed_id_order_index_idx" ON "feed_filters"("feed_id", "order_index");

-- CreateIndex
CREATE INDEX "feed_refresh_jobs_feed_id_created_at_idx" ON "feed_refresh_jobs"("feed_id", "created_at" DESC);

-- CreateIndex
CREATE INDEX "feed_refresh_jobs_status_priority_created_at_idx" ON "feed_refresh_jobs"("status", "priority", "created_at");

-- CreateIndex
CREATE INDEX "feed_refresh_jobs_workspace_id_status_idx" ON "feed_refresh_jobs"("workspace_id", "status");

-- CreateIndex
CREATE INDEX "audit_logs_workspace_id_created_at_idx" ON "audit_logs"("workspace_id", "created_at" DESC);

-- CreateIndex
CREATE INDEX "audit_logs_target_type_target_id_idx" ON "audit_logs"("target_type", "target_id");

-- CreateIndex
CREATE INDEX "audit_logs_actor_user_id_created_at_idx" ON "audit_logs"("actor_user_id", "created_at" DESC);

-- CreateIndex
CREATE INDEX "error_logs_feed_id_created_at_idx" ON "error_logs"("feed_id", "created_at" DESC);

-- CreateIndex
CREATE INDEX "error_logs_severity_created_at_idx" ON "error_logs"("severity", "created_at" DESC);

-- CreateIndex
CREATE INDEX "error_logs_code_created_at_idx" ON "error_logs"("code", "created_at" DESC);

-- CreateIndex
CREATE UNIQUE INDEX "usage_limits_workspace_period_metric_key" ON "usage_limits"("workspace_id", "period_start", "period_end", "metric");

-- AddForeignKey
ALTER TABLE "workspaces" ADD CONSTRAINT "workspaces_owner_user_id_fkey" FOREIGN KEY ("owner_user_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "workspace_members" ADD CONSTRAINT "workspace_members_workspace_id_fkey" FOREIGN KEY ("workspace_id") REFERENCES "workspaces"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "workspace_members" ADD CONSTRAINT "workspace_members_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "workspace_members" ADD CONSTRAINT "workspace_members_invited_by_user_id_fkey" FOREIGN KEY ("invited_by_user_id") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "feeds" ADD CONSTRAINT "feeds_workspace_id_fkey" FOREIGN KEY ("workspace_id") REFERENCES "workspaces"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "feeds" ADD CONSTRAINT "feeds_created_by_user_id_fkey" FOREIGN KEY ("created_by_user_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "feed_sources" ADD CONSTRAINT "feed_sources_feed_id_fkey" FOREIGN KEY ("feed_id") REFERENCES "feeds"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "feed_items" ADD CONSTRAINT "feed_items_workspace_id_fkey" FOREIGN KEY ("workspace_id") REFERENCES "workspaces"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "feed_items" ADD CONSTRAINT "feed_items_feed_id_fkey" FOREIGN KEY ("feed_id") REFERENCES "feeds"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "feed_filters" ADD CONSTRAINT "feed_filters_workspace_id_fkey" FOREIGN KEY ("workspace_id") REFERENCES "workspaces"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "feed_filters" ADD CONSTRAINT "feed_filters_feed_id_fkey" FOREIGN KEY ("feed_id") REFERENCES "feeds"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "feed_refresh_jobs" ADD CONSTRAINT "feed_refresh_jobs_workspace_id_fkey" FOREIGN KEY ("workspace_id") REFERENCES "workspaces"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "feed_refresh_jobs" ADD CONSTRAINT "feed_refresh_jobs_feed_id_fkey" FOREIGN KEY ("feed_id") REFERENCES "feeds"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "audit_logs" ADD CONSTRAINT "audit_logs_workspace_id_fkey" FOREIGN KEY ("workspace_id") REFERENCES "workspaces"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "audit_logs" ADD CONSTRAINT "audit_logs_actor_user_id_fkey" FOREIGN KEY ("actor_user_id") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "error_logs" ADD CONSTRAINT "error_logs_workspace_id_fkey" FOREIGN KEY ("workspace_id") REFERENCES "workspaces"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "error_logs" ADD CONSTRAINT "error_logs_feed_id_fkey" FOREIGN KEY ("feed_id") REFERENCES "feeds"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "error_logs" ADD CONSTRAINT "error_logs_job_id_fkey" FOREIGN KEY ("job_id") REFERENCES "feed_refresh_jobs"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "usage_limits" ADD CONSTRAINT "usage_limits_workspace_id_fkey" FOREIGN KEY ("workspace_id") REFERENCES "workspaces"("id") ON DELETE CASCADE ON UPDATE CASCADE;
