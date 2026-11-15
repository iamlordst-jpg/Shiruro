<div align="center">

# ☾ Shiruro

### Your anime universe, in one place.

A community-built iOS companion for [Miruro](https://miruro.to/), combining a native SwiftUI experience with the Miruro website.

[![Build Shiruro IPA](https://github.com/iamlordst-jpg/shiruro/actions/workflows/build-ipa.yml/badge.svg?branch=initial-hybrid-app)](https://github.com/iamlordst-jpg/shiruro/actions/workflows/build-ipa.yml)
![Platform](https://img.shields.io/badge/platform-iOS-8A5CF6?style=flat)
![Built with](https://img.shields.io/badge/built%20with-SwiftUI-orange?style=flat)

</div>

---

## ✦ About

Shiruro gives Miruro a dedicated iOS home with a custom interface, quick navigation, playback shortcuts, and a personal episode tracker.

The project uses **SwiftUI** for its native interface and **WKWebView** to display Miruro. Anime listings and streaming remain provided by the Miruro website.

## Features

| Feature | Description |
| --- | --- |
| **Discover** | A native landing page with shortcuts to discovery sections. |
| **Search** | A native search field that attempts to submit queries to Miruro's website search. |
| **In-app browsing** | Browse Miruro inside Shiruro, with back and reload controls. |
| **Player shortcuts** | Play/pause, seek 10 seconds, and request fullscreen when the page exposes a compatible video element. |
| **Episode tracker** | Keep a local list of anime and update the last episode watched. |
| **Custom identity** | Original purple cosmic branding and app icon. |

> **Note:** Search and playback shortcuts depend on Miruro's current website structure. They are best-effort integrations, not a guaranteed native Miruro API.

## Screens & navigation

Shiruro is organized into four native tabs:

- **Home** — discovery shortcuts and recently tracked progress.
- **Search** — search Miruro and view its website results.
- **Player** — Miruro page with playback shortcuts.
- **Library** — locally stored anime titles and episode progress.

## Build an IPA

The repository includes a GitHub Actions workflow.

1. Open the [Actions tab](https://github.com/iamlordst-jpg/shiruro/actions).
2. Select **Build Shiruro IPA**.
3. Choose **Run workflow** on the `initial-hybrid-app` branch.
4. Open the completed run and download the `Shiruro-unsigned-ipa` artifact.

The workflow produces an **unsigned IPA**. A valid Apple signing method is required before installing it on a physical iPhone.

## Project structure

```text
Shiruro/
  App.swift
  ContentView.swift
  MiruroBrowser.swift
  Assets.xcassets/
branding/
  shiruro-icon.svg
.github/
  workflows/
    build-ipa.yml
Shiruro.xcodeproj/
```

## Privacy & storage

- The app loads Miruro over HTTPS.
- The episode tracker is stored locally on the device.
- Episode progress does not sync to a Miruro account.
- The embedded website may use its own cookies, storage, and privacy practices.

## Disclaimer

Shiruro is an independent community project and is **not affiliated with, endorsed by, or officially connected to Miruro**. It does not host anime streams, bypass DRM, or circumvent website access controls. Please respect the rights of content owners and the terms of the services you use.

## Contributing

Issues, suggestions, and pull requests are welcome. When reporting a problem, include the iOS version, the affected Shiruro tab, and the relevant GitHub Actions run if the issue concerns a build.

---

<div align="center">

**Shiruro** · Made for the love of anime.

</div>
