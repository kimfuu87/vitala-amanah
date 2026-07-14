import type { Metadata } from "next";
import "./globals.css";
import "./auth.css";
import "./demo.css";

export const metadata: Metadata = {
  title: "Vitala Amanah | Life, wealth and legacy",
  description: "A Malaysian-first family wealth and legacy organiser.",
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="en" suppressHydrationWarning>
      <body>{children}</body>
    </html>
  );
}
