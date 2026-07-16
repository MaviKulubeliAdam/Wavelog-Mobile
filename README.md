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
- **POTA / SOTA / WWFF** — reference fields and spot integration built in
- **ADIF Export** — export your log directly from the app

## Requirements

- Android 8.0 (API 26) or higher
- A self-hosted [Wavelog](https://github.com/wavelog/wavelog) instance
- A Wavelog API key (read-write)

### Server-side patch

A small patch is currently required on your Wavelog server for full functionality (edit/delete QSOs, contest sessions). Installation takes about a minute:

👉 **[sp9aqg.pl/install.html](https://sp9aqg.pl/install.html)**

> This patch is temporary. Once the official Wavelog REST API v2 ships, the app will be updated to use it natively and the patch will no longer be needed.

## Getting started

1. Install the app from Google Play
2. Open the app and go to **Settings**
3. Enter your Wavelog server URL and API key
4. Start logging

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
