"use client";

import { Check, Copy, ExternalLink, Rss, Send, Sparkles } from "lucide-react";
import { useMemo, useState } from "react";

import { buildFeedPreview, createEmbedSnippet } from "../lib/feed-builder.mjs";

const presets = [
  "https://www.youtube.com/@verge",
  "https://reddit.com/r/technology",
  "https://news.google.com/search?q=markets",
];

export function FeedConsole() {
  const [sourceUrl, setSourceUrl] = useState("https://example.com/blog");
  const [copied, setCopied] = useState(false);
  const preview = useMemo(() => buildFeedPreview(sourceUrl), [sourceUrl]);
  const embedSnippet =
    preview.status === "ready" ? createEmbedSnippet(preview.feedUrl) : "";

  function copySnippet() {
    if (!embedSnippet) return;

    navigator.clipboard
      .writeText(embedSnippet)
      .then(() => {
        setCopied(true);
        window.setTimeout(() => setCopied(false), 1400);
      })
      .catch(() => setCopied(false));
  }

  return (
    <section className="console" aria-label="Live feed builder">
      <div className="console__bar">
        <div>
          <span className="eyebrow">Live Feed Builder</span>
          <h2>Generate RSS feeds in seconds</h2>
        </div>
        <Rss aria-hidden="true" />
      </div>

      <label className="field">
        <span>Source URL</span>
        <div className="field__control">
          <input
            value={sourceUrl}
            onChange={(event) => setSourceUrl(event.target.value)}
            placeholder="https://example.com/blog"
          />
          <button type="button" aria-label="Generate feed">
            <Sparkles aria-hidden="true" size={18} />
          </button>
        </div>
      </label>

      <div className="preset-row" aria-label="Example sources">
        {presets.map((preset) => (
          <button type="button" key={preset} onClick={() => setSourceUrl(preset)}>
            {new URL(preset).hostname.replace("www.", "")}
          </button>
        ))}
      </div>

      {preview.status === "ready" ? (
        <div className="preview-grid">
          <div className="feed-card">
            <div className="feed-card__top">
              <span>{preview.sourceType}</span>
              <span>Auto-refresh</span>
            </div>
            <p className="feed-url">{preview.feedUrl}</p>
            <ul>
              {preview.items.map((item) => (
                <li key={item.title}>
                  <Check aria-hidden="true" size={16} />
                  <span>
                    <strong>{item.title}</strong>
                    <small>{item.meta}</small>
                  </span>
                </li>
              ))}
            </ul>
          </div>

          <div className="embed-card">
            <div className="feed-card__top">
              <span>Widget Embed</span>
              <span>HTML</span>
            </div>
            <code>{embedSnippet}</code>
            <button type="button" onClick={copySnippet}>
              <Copy aria-hidden="true" size={16} />
              {copied ? "Copied" : "Copy code"}
            </button>
          </div>
        </div>
      ) : (
        <div className="error-box" role="alert">
          {preview.message}
        </div>
      )}

      <div className="delivery-row" aria-label="Delivery options">
        <span>
          <ExternalLink aria-hidden="true" size={16} />
          RSS URL
        </span>
        <span>
          <Send aria-hidden="true" size={16} />
          Discord, Slack, Telegram
        </span>
        <span>CSV, JSON, OPML</span>
      </div>
    </section>
  );
}
