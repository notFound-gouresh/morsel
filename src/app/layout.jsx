import "./globals.css";

export const metadata = {
  title: "Morsel | Small bites from the live web",
  description:
    "Turn websites, newsletters, and social sources into clean feeds, widgets, and alerts.",
};

export default function RootLayout({ children }) {
  return (
    <html lang="en">
      <body>{children}</body>
    </html>
  );
}
