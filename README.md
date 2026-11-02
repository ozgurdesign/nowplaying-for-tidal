# Now Playing for TIDAL

A Mac menu-bar app that shows the track playing in [TIDAL](https://tidal.com).

**[Download the latest version](https://github.com/ozgurdesign/nowplaying-for-tidal/releases/latest)** · [ozgur.ca](https://ozgur.ca/projects/nowplaying-for-tidal)

## What it does

Shows `♪ Artist - Title` in the menu bar while TIDAL plays, and `❙❙` when it's paused. The menu has **Launch at Login** and **Quit**. That's the whole app.

## Download

Each release has one disk image, `NowPlayingForTIDAL-<version>.dmg`, for macOS 13 Ventura and later, on Apple silicon and Intel.

The "Source code" links GitHub adds to every release only contain this README and the licence. The app is the `.dmg`.

## First launch

The app reads playback through Apple's private MediaRemote framework, so it can't be notarized, and macOS asks before opening it the first time.

1. Open the disk image and drag Now Playing for TIDAL to Applications.
2. Open it once. macOS says it can't check the app.
3. Go to System Settings › Privacy & Security and click Open Anyway.

You only need to do this once.

## Privacy

The app has no network access and collects nothing.

## About this repository

This repository hosts releases only. The source code is not public, and issues and pull requests are turned off.

## Credits

Now Playing data comes from [mediaremote-adapter](https://github.com/ungive/mediaremote-adapter) by Jonas van den Berg and contributors, bundled under the BSD 3-Clause License. Its notice is in [LICENSE](LICENSE) and inside the app.

Not affiliated with TIDAL.

## Licence

Now Playing for TIDAL by [Oz Gultekin](https://ozgur.ca) is licensed under [CC BY-NC-ND 4.0](https://creativecommons.org/licenses/by-nc-nd/4.0/). See [LICENSE](LICENSE).
