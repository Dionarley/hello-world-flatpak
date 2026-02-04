#!/usr/bin/env bash
#
# bootstrap.sh
# Clean & scaffold Hello World Flatpak (Bash)
#

set -Eeuo pipefail
IFS=$'\n\t'

readonly APP_ID="com.example.HelloWorld"
readonly APP_BIN="hello-world"
readonly MANIFEST="${APP_ID}.yml"

clean_tree() {
    # remove estrutura antiga problemática
    rm -rf flatpak build-dir 2>/dev/null || true
}

create_dirs() {
    mkdir -p \
        app/bin \
        app/share/applications \
        tests
}

create_app() {
    if [[ ! -f app/bin/${APP_BIN} ]]; then
        cat > app/bin/${APP_BIN} <<'EOF'
#!/usr/bin/env bash

set -Eeuo pipefail
IFS=$'\n\t'

main() {
    printf '%s\n' "Hello World"
}

main "$@"
EOF
        chmod 0755 app/bin/${APP_BIN}
    fi
}

create_desktop() {
    local desktop="app/share/applications/${APP_ID}.desktop"

    if [[ ! -f "${desktop}" ]]; then
        cat > "${desktop}" <<EOF
[Desktop Entry]
Type=Application
Name=Hello World (Bash)
Exec=${APP_BIN}
Terminal=true
Categories=Utility;
EOF
    fi
}

create_tests() {
    local test_file="tests/test_hello_world.bats"

    if [[ ! -f "${test_file}" ]]; then
        cat > "${test_file}" <<'EOF'
#!/usr/bin/env bats

@test "hello-world prints Hello World" {
    run ./app/bin/hello-world
    [ "$status" -eq 0 ]
    [ "$output" = "Hello World" ]
}
EOF
        chmod 0755 "${test_file}"
    fi
}

create_manifest() {
    if [[ ! -f "${MANIFEST}" ]]; then
        cat > "${MANIFEST}" <<EOF
app-id: ${APP_ID}

runtime: org.freedesktop.Platform
runtime-version: "23.08"
sdk: org.freedesktop.Sdk

command: ${APP_BIN}

finish-args: []

modules:
  - name: hello-world
    buildsystem: simple
    build-commands:
      - install -Dm755 app/bin/${APP_BIN} /app/bin/${APP_BIN}
      - install -Dm644 app/share/applications/${APP_ID}.desktop /app/share/applications/${APP_ID}.desktop
    sources:
      - type: dir
        path: .
EOF
    fi
}

create_makefile() {
    if [[ ! -f Makefile ]]; then
        cat > Makefile <<EOF
APP=${APP_BIN}
MANIFEST=${MANIFEST}

test:
	shellcheck app/bin/\$(APP)
	bats tests/

flatpak-build:
	flatpak-builder --force-clean --sandbox build-dir \$(MANIFEST)

flatpak-run:
	flatpak-builder --run build-dir \$(MANIFEST) \$(APP)
EOF
    fi
}

create_shellcheck() {
    if [[ ! -f .shellcheckrc ]]; then
        cat > .shellcheckrc <<'EOF'
shell=bash
disable=SC1091
EOF
    fi
}

create_readme() {
    if [[ ! -f README.md ]]; then
        cat > README.md <<'EOF'
# Hello World Flatpak (Bash)

Minimal Bash application packaged as Flatpak.

## Requirements
- flatpak
- flatpak-builder
- shellcheck
- bats

## Test
make test

## Build
make flatpak-build

## Run
make flatpak-run
EOF
    fi
}

main() {
    clean_tree
    create_dirs
    create_app
    create_desktop
    create_tests
    create_manifest
    create_makefile
    create_shellcheck
    create_readme

    printf '%s\n' "✔ Project cleaned and scaffolded successfully"
}

main "$@"
