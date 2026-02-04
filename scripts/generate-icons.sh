#!/usr/bin/env bash
set -euo pipefail

APP_ID="com.example.HelloWorld"
SRC="assets/icon/${APP_ID}.png"
DEST="app/share/icons/hicolor"

SIZES=(48 64 128 256)

command -v convert >/dev/null || {
  echo "imagemagick (convert) is required"
  exit 1
}

for size in "${SIZES[@]}"; do
  dir="${DEST}/${size}x${size}/apps"
  mkdir -p "$dir"

  convert "$SRC" -resize "${size}x${size}" \
    "${dir}/${APP_ID}.png"
done

echo "Icons generated successfully"
