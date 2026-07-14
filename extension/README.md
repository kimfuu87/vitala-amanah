# Vitala Amanah Chrome Companion

Manifest V3 companion for the public demo. It displays the current readiness summary, quick-adds a basic asset, and opens the full app or account sign-in.

## Install locally

1. Open `chrome://extensions`.
2. Enable Developer mode.
3. Choose **Load unpacked** and select this `extension` directory.
4. Pin **Vitala Amanah Companion**.

## Security boundary

- Requests only `activeTab` plus access to the exact Vitala Amanah production origin.
- Does not read page content, browsing history, passwords, tokens, documents, or clipboard data.
- Does not store authentication tokens or decrypted information.
- Quick capture accepts only a record name, category, and approximate value.
- This demo build uses the app's public demo workspace. Per-user extension sessions must remain disabled until authenticated API authorization is implemented and reviewed.

## Release checklist

- Add reviewed extension icons and screenshots.
- Complete Chrome Web Store privacy disclosures.
- Replace public demo capture with authenticated, short-lived server sessions.
- Add rate limiting and automated authorization-boundary tests.
- Complete an independent security review before enabling sensitive capture.
