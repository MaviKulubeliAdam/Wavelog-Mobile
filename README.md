# Wavelog Mobile

Android companion app for [Wavelog](https://github.com/wavelog/wavelog) — the self-hosted amateur radio logging software.

<a href="https://play.google.com/store/apps/details?id=com.wavelog_mobile">
  <img src="https://play.google.com/intl/en_us/badges/static/images/badges/en_badge_web_generic.png" height="60" alt="Get it on Google Play">
</a>

---

## Features

- **QSO Logging** — callsign lookup via QRZ/HamQTH, band, mode, RST, DXCC info, grid square and signal map; submode auto-selected from frequency
- **QSL Confirmation Status** — LoTW, eQSL and QRZ.com confirmation chips displayed in QSO detail view
- **Contest Mode** — dedicated contest logger with serial/exchange fields and session management
- **DX Spots** — live cluster spots with filtering by band and mode
- **Logbook** — browse, search, edit and delete your QSOs
- **Statistics** — DXCC progress, band/mode breakdowns, streak tracking
- **Propagation** — real-time solar indices (SFI, sunspots, K/A-index, solar wind) and HF band conditions
- **Community** — Google Sign-In with callsign ownership verification, chat rooms, planned activations and push notifications
- **Station Profiles** — manage multiple station profiles from the app
- **Tablet Layout** — optimised split-pane layout for larger screens (propagation, achievements and main screens)
- **POTA / SOTA / WWFF** — MY_ reference fields auto-filled in ADIF export; P2P reference input on QSO form
- **ADIF Export** — export your log with MY_CALLSIGN, MY_POTA_REF and all station fields auto-populated
- **ADIF Import** — import an ADIF file directly or open a `.adif` / `.adi` file from your file manager ("Open with")
- **Achievements** — unlock badges as your log grows; responsive grid for phone and tablet
- **Antenna Compass** — bearing and distance to the contacted station

## Requirements

- Android 7.0 (API 24) or higher
- A self-hosted [Wavelog](https://github.com/wavelog/wavelog) instance **v3.2.0 or later**
- A **Wavelog API v2 token** (`wl2_…`) — generated in Wavelog → Settings → API Tokens

> **No server patch required.** Starting with v3.2.0 of Wavelog Mobile, all features run directly on the official Wavelog API v2. No files need to be uploaded to your server beyond a standard Wavelog installation.

### API Token Scopes

When creating the token in Wavelog under **Settings → API Tokens → New Token**, select these scopes:

| Scope | Purpose |
|---|---|
| `confirmation:read` | LoTW / eQSL / QRZ.com confirmation status |
| `contest:read` / `contest:write` / `contest:delete` | Contest sessions |
| `logbook:read` / `logbook:write` / `logbook:delete` | Manage logbooks |
| `lookup:read` | Callsign lookup |
| `qso:read` / `qso:write` / `qso:delete` | Log and browse QSOs |
| `station:read` / `station:write` / `station:delete` | Manage station profiles |
| `statistic:read` | Statistics screen |

## Getting Started

1. Make sure your Wavelog server is at **v3.2.0 or later**
2. In Wavelog, go to **Settings → API Tokens** and create a new token with the scopes listed above
3. Install the app from Google Play
4. Open the app, enter your server URL and paste the API token
5. Select your station profile and start logging

The app will guide you through token creation on first launch.

## ADIF Import — Open With

On Android, `.adif` and `.adi` files are registered to open with Wavelog Mobile. Tap a file in your file manager or email client, select **Wavelog Mobile — İçe Aktar**, and the app opens directly on the import screen with the file pre-loaded. Select your station profile and tap **Import**.

## Community Features

The Community section requires a Google account. Sign in with Google — your callsign (set in your Wavelog station profile) is automatically verified and claimed. Each callsign can only be linked to one Google account, preventing impersonation.

Community features include:
- Chat rooms
- Planned activation announcements
- Push notifications for new activations and messages

## Localisation

The app is available in **9 languages**: English, Turkish, German, Polish, Russian, French, Italian, Japanese and Korean.

[![Translation status](https://translate.wavelogmobile.app/widget/wavelog-mobile/app/svg-badge.svg)](https://translate.wavelogmobile.app/engage/wavelog-mobile/)

Community translations are welcome and hosted on [Weblate](https://translate.wavelogmobile.app/engage/wavelog-mobile/). No account is needed to suggest translations — sign up, pick a language, and start translating. Changes are periodically merged into the `main-dev` branch automatically.

## Tech Stack

- [Flutter](https://flutter.dev) / Dart
- [Riverpod](https://riverpod.dev) — state management
- [Firebase](https://firebase.google.com) — community auth (Google Sign-In), Firestore, push notifications
- [Hive](https://docs.hivedb.dev) — local cache
- [go_router](https://pub.dev/packages/go_router) — navigation
- [Dio](https://pub.dev/packages/dio) — HTTP client
- [flutter_svg](https://pub.dev/packages/flutter_svg) — SVG rendering

## Contributing

Pull requests are welcome. Please target the **`main-dev`** branch — do not open PRs directly against `main`.

```
feature/your-feature  →  PR  →  main-dev  →  (review)  →  PR  →  main
```

## Building

```bash
flutter pub get
flutter build appbundle --release
```

Signing is configured via `android/key.properties` (not included in the repository). Create the file with your keystore details before building a release.

## License

This project is licensed under the [GNU Affero General Public License v3.0](LICENSE) (AGPL-3.0).

---

By TA4RX / SP9AQG
