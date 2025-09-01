# Open with Brave (Chrome Extension + Native Helper)

This package gives you a ready-to-load Chrome extension and a native helper that launches Brave with a URL.

## What’s inside

- `extension/` — Manifest V3 Chrome extension (background service worker + icons)
- `native/open_in_brave.py` — Native Messaging helper (Python 3)
- `native/host-manifests/uk.co.adgico.open-in-brave.template.json` — Host manifest template
- `install-*.sh` / `install-windows.ps1` — Installers that place/registry the host manifest and set the correct path + extension ID

## Quick start

1) Load the extension:
   - Open `chrome://extensions`
   - Enable **Developer mode**
   - Click **Load unpacked** and select the `extension/` folder.
   - Copy the **Extension ID** that appears.

2) Install the native host:
   - macOS: run `./install-macos.sh <EXTENSION_ID>`
   - Linux: run `./install-linux.sh <EXTENSION_ID>`
   - Windows (PowerShell): `.\install-windows.ps1 -ExtensionId <EXTENSION_ID>`

   The install scripts:
   - Write the Native Messaging host manifest with the right absolute path to `open_in_brave.py`
   - Fill `allowed_origins` with your extension ID
   - Register the host (Windows registry) or place it in the correct directory (macOS/Linux)

3) Test it:
   - Right-click a link → **Open link in Brave**
   - Right-click the page → **Open this page in Brave**
   - Select text that is a URL → **Open selected URL in Brave**

## Notes

- Only `http(s)` URLs are allowed for safety. Adjust in `open_in_brave.py` if needed.
- Brave paths differ by platform; the helper tries common locations and falls back to `brave-browser` (Linux) / `brave.exe` (Windows on PATH).
- If you have Chrome Beta/Canary or Chromium, you may need to copy the manifest to their respective `NativeMessagingHosts` directories.
- To uninstall, remove the host manifest file and (on Windows) delete the registry key under `HKCU\Software\Google\Chrome\NativeMessagingHosts\uk.co.adgico.open-in-brave`.
