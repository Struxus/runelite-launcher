#!/bin/bash
# Release packages must be signed AND accepted by Apple's notary service.
set -euo pipefail
APP=${1:?Usage: package-macos-release.sh app output.dmg format}
OUTPUT=${2:?Missing output DMG}
FORMAT=${3:-ULFO}
: "${SIGNING_IDENTITY:?Set SIGNING_IDENTITY to your Developer ID Application identity}"
: "${NOTARY_PROFILE:?Set NOTARY_PROFILE to a notarytool keychain credential profile}"
ROOT=$(cd "$(dirname "$0")/.." && pwd)
bash "$ROOT/tools/sign-macos-app.sh" "$APP"
STAGING=$(mktemp -d)
trap 'rm -rf "$STAGING"' EXIT
ditto "$APP" "$STAGING/Augment.app"
ln -s /Applications "$STAGING/Applications"
hdiutil create -ov -volname Augment -fs HFS+ -format "$FORMAT" -srcfolder "$STAGING" "$OUTPUT"
codesign --force --sign "$SIGNING_IDENTITY" --timestamp "$OUTPUT"
xcrun notarytool submit "$OUTPUT" --wait --keychain-profile "$NOTARY_PROFILE" --output-format json > "$OUTPUT.notary.json"
python3 - "$OUTPUT.notary.json" <<'PY'
import json,sys
result=json.load(open(sys.argv[1]))
if result.get('status') != 'Accepted':
    raise SystemExit('Notarization was not accepted: '+str(result))
PY
xcrun stapler staple "$OUTPUT"
xcrun stapler validate "$OUTPUT"
spctl --assess --type open --context context:primary-signature --verbose=2 "$OUTPUT"
