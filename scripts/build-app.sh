#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."
ROOT="$PWD"
APP="$ROOT/Now Playing for TIDAL.app"
BIN_NAME="NowPlayingForTidal"

echo "==> swift build -c release"
swift build -c release
BIN="$ROOT/.build/release/$BIN_NAME"
[ -f "$BIN" ] || { echo "missing binary: $BIN"; exit 1; }

echo "==> assembling bundle"
rm -rf "$APP"
mkdir -p "$APP/Contents/MacOS" "$APP/Contents/Resources" "$APP/Contents/Frameworks"

cp "$BIN" "$APP/Contents/MacOS/$BIN_NAME"
cp "$ROOT/Info.plist.template" "$APP/Contents/Info.plist"
cp "$ROOT/assets/AppIcon.icns" "$APP/Contents/Resources/"
cp "$ROOT/vendor/mediaremote-adapter.pl" "$APP/Contents/Resources/"
cp -R "$ROOT/vendor/MediaRemoteAdapter.framework" "$APP/Contents/Frameworks/"

echo "==> ad-hoc signing"
codesign --force --deep --sign - "$APP" >/dev/null

echo "built: $APP"
