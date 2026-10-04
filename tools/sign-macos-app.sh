#!/bin/bash
# Sign nested Java runtime code before sealing the enclosing app.
set -euo pipefail
APP=${1:?Usage: sign-macos-app.sh path/to/Augment.app}
: "${SIGNING_IDENTITY:?Set SIGNING_IDENTITY to your Developer ID Application identity}"
ROOT=$(cd "$(dirname "$0")/.." && pwd)
while IFS= read -r -d '' binary; do
    if /usr/bin/file -b "$binary" | grep -q 'Mach-O'; then
        codesign --force --sign "$SIGNING_IDENTITY" --timestamp --options runtime \
            --entitlements "$ROOT/osx/signing.entitlements" "$binary"
    fi
done < <(find "$APP/Contents" -type f -print0)
codesign --force --sign "$SIGNING_IDENTITY" --timestamp --options runtime \
    --entitlements "$ROOT/osx/signing.entitlements" "$APP"
codesign --verify --deep --strict --verbose=2 "$APP"
