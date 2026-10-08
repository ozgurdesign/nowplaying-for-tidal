# Now Playing for TIDAL

A tiny macOS menu-bar app that shows the track currently playing in the
[TIDAL](https://tidal.com) desktop app. There wasn't any, so I made one for
personal use.

Shows `♪ Artist - Title` while TIDAL plays, `❙❙` when paused. Menu has
**Launch at Login** and **Quit**. That's the whole app.

## Build

Needs macOS 13+ and the Swift toolchain.

```sh
swift build -c release
./scripts/build-app.sh      # assembles "Now Playing for TIDAL.app"
```

It uses Apple's private `MediaRemote` framework, so it isn't notarized. On first
launch, right-click the app and choose **Open**.

## Credits

Now Playing data comes from
[mediaremote-adapter](https://github.com/ungive/mediaremote-adapter) (BSD-3-Clause),
bundled in `vendor/`.

My own code is public domain (The Unlicense). Not affiliated with TIDAL.
