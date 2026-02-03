#!/usr/bin/env bash
#
# hello-world.sh
# Simple Hello World application
#
# Security & portability best practices:
# - Strict mode
# - No unquoted variables
# - No external dependencies
# - Works inside Flatpak sandbox

set -Eeuo pipefail
IFS=$'\n\t'

readonly APP_NAME="hello-world-bash"

main() {
    printf '%s\n' "Hello World"
}

main "$@"
