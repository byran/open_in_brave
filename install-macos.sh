#!/usr/bin/env bash
set -euo pipefail

EXTENSION_ID="${1:-}"
if [[ -z "$EXTENSION_ID" ]]; then
  read -p "Enter the Chrome extension ID (from chrome://extensions): " EXTENSION_ID
fi

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HELPER_PATH="$BASE_DIR/native/open_in_brave.py"
HOST_NAME="uk.co.adgico.open-in-brave"
TARGET_DIR="$HOME/Library/Application Support/Google/Chrome/NativeMessagingHosts"
mkdir -p "$TARGET_DIR"

MANIFEST_PATH="$TARGET_DIR/$HOST_NAME.json"
cat "$BASE_DIR/native/host-manifests/uk.co.adgico.open-in-brave.template.json" \
  | sed "s|\"path\": \"\"|\"path\": \"${HELPER_PATH//\//\\/}\"|" \
  | sed "s/REPLACE_WITH_EXTENSION_ID/$EXTENSION_ID/" \
  > "$MANIFEST_PATH"

chmod +x "$HELPER_PATH"

echo "Installed native host manifest to: $MANIFEST_PATH"
echo "If you use Chrome Beta/Canary or a different profile, you may also need to copy the manifest to the corresponding NativeMessagingHosts directory."
