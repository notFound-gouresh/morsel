import assert from "node:assert/strict";
import test from "node:test";

import {
  buildFeedPreview,
  classifySourceUrl,
  createEmbedSnippet,
} from "../lib/feed-builder.mjs";

test("classifies common feed source URLs for the builder", () => {
  assert.equal(classifySourceUrl("https://www.youtube.com/@verge"), "YouTube");
  assert.equal(classifySourceUrl("https://reddit.com/r/technology"), "Reddit");
  assert.equal(classifySourceUrl("https://example.com/blog"), "Website");
});

test("builds a deterministic feed preview from a valid source", () => {
  const preview = buildFeedPreview("https://example.com/blog");

  assert.equal(preview.status, "ready");
  assert.equal(preview.sourceType, "Website");
  assert.equal(preview.feedUrl, "https://feeds.rss-studio.local/example-com-blog.xml");
  assert.equal(preview.items.length, 3);
  assert.match(preview.items[0].title, /example\.com/);
});

test("returns an actionable error for invalid source URLs", () => {
  const preview = buildFeedPreview("not a url");

  assert.equal(preview.status, "error");
  assert.equal(preview.message, "Enter a complete URL, including https://");
});

test("creates an embeddable script snippet for a generated feed", () => {
  const snippet = createEmbedSnippet("https://feeds.rss-studio.local/example-com-blog.xml");

  assert.equal(
    snippet,
    '<script async src="https://rss-studio.local/widget.js" data-feed="https://feeds.rss-studio.local/example-com-blog.xml"></script>',
  );
});
