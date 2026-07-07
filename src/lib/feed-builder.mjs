const SOURCE_PATTERNS = [
  ["youtube.com", "YouTube"],
  ["youtu.be", "YouTube"],
  ["reddit.com", "Reddit"],
  ["instagram.com", "Instagram"],
  ["tiktok.com", "TikTok"],
  ["x.com", "X / Twitter"],
  ["twitter.com", "X / Twitter"],
  ["news.google.com", "Google News"],
  ["telegram.me", "Telegram"],
  ["t.me", "Telegram"],
];

export function classifySourceUrl(value) {
  try {
    const url = new URL(value);
    const host = url.hostname.replace(/^www\./, "");
    const match = SOURCE_PATTERNS.find(([pattern]) => host.includes(pattern));
    return match ? match[1] : "Website";
  } catch {
    return "Unknown";
  }
}

export function buildFeedPreview(value) {
  let url;

  try {
    url = new URL(value);
  } catch {
    return {
      status: "error",
      message: "Enter a complete URL, including https://",
    };
  }

  if (!["http:", "https:"].includes(url.protocol)) {
    return {
      status: "error",
      message: "Only web URLs can be converted into feeds.",
    };
  }

  const sourceType = classifySourceUrl(url.toString());
  const slug = `${url.hostname}${url.pathname}`
    .replace(/^www\./, "")
    .replace(/[^a-zA-Z0-9]+/g, "-")
    .replace(/^-|-$/g, "")
    .toLowerCase();

  const feedUrl = `https://feeds.rss-studio.local/${slug}.xml`;
  const sourceName = url.hostname.replace(/^www\./, "");

  return {
    status: "ready",
    sourceType,
    feedUrl,
    items: [
      {
        title: `${sourceName} latest article`,
        meta: "Detected title, image, author, and publish date",
      },
      {
        title: `${sourceType} update stream`,
        meta: "Filtered duplicates and normalized article summaries",
      },
      {
        title: "New post matched feed rules",
        meta: "Ready for widgets, bots, API export, and RSS readers",
      },
    ],
  };
}

export function createEmbedSnippet(feedUrl) {
  return `<script async src="https://rss-studio.local/widget.js" data-feed="${feedUrl}"></script>`;
}
