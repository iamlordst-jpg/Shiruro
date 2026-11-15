# Shiruro

A community-built iOS companion for the Miruro website. Shiruro combines a native SwiftUI shell with an embedded WKWebView, so the site's own interface and playback remain responsible for its content.

## Current features

- Native SwiftUI navigation with Home, Search, and Library tabs
- Miruro website loaded over HTTPS in WKWebView
- Back and reload controls
- Local watchlist stored on-device
- Custom purple cosmic app icon
- GitHub Actions workflow that builds an unsigned iOS IPA

## Build

Open Actions, choose Build Shiruro IPA, then select Run workflow. The workflow also runs when app source changes are pushed to the main or initial-hybrid-app branch.

The workflow creates an unsigned IPA artifact. It must be signed with a valid Apple development certificate before installation on a device. The app does not bypass website access controls, DRM, or authentication.

## Project

- Shiruro/ — SwiftUI app source and asset catalog
- branding/ — original Shiruro icon artwork (SVG)
- .github/workflows/ — automated iOS build

Shiruro is an independent community project and is not affiliated with or endorsed by Miruro.
