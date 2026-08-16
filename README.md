# Wavelog Mobile

Android companion app for [Wavelog](https://github.com/wavelog/wavelog) — the self-hosted amateur radio logging software.

<a href="https://play.google.com/store/apps/details?id=com.wavelog_mobile">
  <img src="https://play.google.com/intl/en_us/badges/static/images/badges/en_badge_web_generic.png" height="60" alt="Get it on Google Play">
</a>

---

## Features

- **QSO Logging** — callsign lookup via QRZ/HamQTH, band, mode, RST, DXCC info, grid square and signal map
- **Contest Mode** — dedicated contest logger with serial/exchange fields and session management
- **DX Spots** — live cluster spots with filtering by band and mode
- **Logbook** — browse, search, edit and delete your QSOs
- **Statistics** — DXCC progress, band/mode breakdowns, streak tracking
- **Station Profiles** — manage multiple station profiles from the app
- **Tablet Layout** — optimised split-pane layout for larger screens
- **POTA / SOTA / WWFF** — MY_ reference fields auto-filled in ADIF export; P2P reference input on QSO form
- **ADIF Export** — export your log with MY_CALLSIGN, MY_POTA_REF and all station fields auto-populated
- **ADIF Import** — import an ADIF file directly or open a `.adif` / `.adi` file from your file manager ("Open with")
- **Achievements** — unlock badges as your log grows
- **Antenna Compass** — bearing and distance to the contacted station

## Requirements

- Android 8.0 (API 26) or higher
- A self-hosted [Wavelog](https://github.com/wavelog/wavelog) instance (recent version)
- A **Wavelog API v2 token** (`wl2_…`) — generated in Wavelog → Settings → API

### Server-side patch

A small patch is required on your Wavelog server. Even if you generate an API v2 token without it, the app will not work correctly. Installation takes about a minute:

👉 **[sp9aqg.pl/install.html](https://sp9aqg.pl/install.html)**

## Getting started

1. Install the server patch (see above)
2. In Wavelog, go to **Settings → API** and create an API v2 token (`wl2_…`)
3. Install the app from Google Play
4. Open the app, enter your server URL and paste the API v2 token
5. Select your station profile and start logging

## ADIF Import — Open with

On Android, `.adif` and `.adi` files are registered to open with Wavelog Mobile. Tap a file in your file manager or email client, select **Wavelog Mobile — İçe Aktar**, and the app opens directly on the import screen with the file pre-loaded. Select your station profile and tap **Import**.

## Localisation

The app is available in English, Turkish, German and Polish.

## Tech stack

- [Flutter](https://flutter.dev) / Dart
- [Riverpod](https://riverpod.dev) — state management
- [Hive](https://docs.hivedb.dev) — local cache
- [go_router](https://pub.dev/packages/go_router) — navigation
- [Dio](https://pub.dev/packages/dio) — HTTP client

## Building

```bash
flutter pub get
flutter build apk --release
# or for Play Store:
flutter build appbundle --release
```

Signing is configured via `android/key.properties` (not included in the repository). Create the file with your keystore details before building a release.

## License

This project is not open source. All rights reserved.

---

By TA4RX / SP9AQG
