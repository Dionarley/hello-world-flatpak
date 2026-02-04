#!/usr/bin/env bash
set -euo pipefail

MANIFEST="com.example.HelloWorld.yml"
BUILD_DIR="build-dir"

flatpak-builder \
  --force-clean \
  --sandbox \
  "$BUILD_DIR" \
  "$MANIFEST"
