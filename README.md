<div align="center">

# ☾ Shiruro

### Your anime universe, in one place.

A community-built iOS companion for [Miruro](https://miruro.to/), wrapped in a clean, native SwiftUI experience.

[![Build Shiruro IPA](https://github.com/iamlordst-jpg/shiruro/actions/workflows/build-ipa.yml/badge.svg?branch=initial-hybrid-app)](https://github.com/iamlordst-jpg/shiruro/actions/workflows/build-ipa.yml)
![Platform](https://img.shields.io/badge/platform-iOS-8A5CF6?style=flat)
![Built with](https://img.shields.io/badge/built%20with-SwiftUI-orange?style=flat)

</div>

---

## ✦ About

Shiruro gives Miruro a dedicated iOS home with its own visual identity and a streamlined in-app browsing experience.

The app is built with **SwiftUI** and **WKWebView**. Shiruro provides the native shell; anime discovery, search, episode pages, and video playback are handled by the Miruro website.

## Features

| Feature | Description |
| --- | --- |
| **Minimal home** | A focused landing screen with a single “Explore Miruro” entry point. |
| **In-app browsing** | Open and use Miruro without leaving Shiruro. |
| **Integrated playback** | Watch through Miruro's own video player inside the app. |
| **Simple navigation** | Native back and reload controls while browsing. |
| **Custom identity** | Original purple cosmic branding and app icon. |

## Screens & navigation

Shiruro keeps the native interface intentionally simple:

- **Home** — a clean welcome screen and the “Explore Miruro” button.
- **Miruro** — the Miruro website opens inside the app, including its search, anime pages, episode navigation, and player.

The website's layout and playback experience may change independently of Shiruro.

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

## Privacy

- Shiruro loads Miruro over HTTPS inside an embedded browser.
- The embedded website may use its own cookies, local storage, and privacy practices.
- Shiruro does not provide a separate account or episode-tracking service.

## Disclaimer

Shiruro is an independent community project and is **not affiliated with, endorsed by, or officially connected to Miruro**. It does not host anime streams. Please respect the rights of content owners and the terms of the services you use.

## Contributing

Issues, suggestions, and pull requests are welcome. When reporting a problem, include your iOS version and the relevant GitHub Actions run if the issue concerns a build.

---

<div align="center">

**Shiruro** · Made for the love of anime.

</div>
