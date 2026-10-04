Latest version RuneLite launcher, with CI.

Can be used for any client revision (317, OSRS, 500+, etc.), as well as any Java application.

## Usage Guide

- Fork this repository on GitHub
- Replace all `Augment` (case sensitive) with your server name.
- Replace all `Augment` (case sensitive) with your lowercase server name.
- Replace `augmentps.io`/`augmentps.io` with your domain name.
- In `launcher.properties` replace the `https://static.runelite.net/bootstrap.json` link with a link to your own
  bootstrap (you can host it on a Gist for example).
  See [bootstrap.json.example](https://github.com/Jire/runelite-launcher/blob/main/bootstrap.json.example) for an
  example.
- Push your changes to GitHub, and then go to the Actions tab, click on the latest workflow.
- Wait for the workflow to finish, and then download the `jar`/`linux`/`macos-app`/`macos-dmg`/`windows` files and
  distribute them as you please.

## Support

If there's a problem with the launcher,
please [open an issue on GitHub](https://github.com/Jire/runelite-launcher/issues/new).

If you want it set up for you with blazing-fast edge-served hosting, contact **jire** on Discord.

## Augment branding

`branding/augment-master.png` is the original Augment artwork. Run
`python3 tools/build-branding.py` with Pillow installed to regenerate all sizes.

- Windows EXE and installer: matching transparent ICOs with 16, 20, 24, 32, 40, 48, 64, 96, 128 and 256 px images.
- Installer header: white-background BMPs at 55, 64, 83, 110, 128 and 166 px; all three Windows installer targets select an appropriate DPI variant.
- Java windows: native-sized icon list; splash is 200 logical pixels with 1x, 2x and 3x artwork.
- macOS: ICNS through 1024 px, including Retina representations.
- Linux: transparent 512 px PNG.

The existing resource filenames are retained for compatibility with the build scripts.
`branding/preview.png` shows the icons at actual pixel sizes. Windows installers
must be built and checked on Windows (or the Windows CI jobs); a local macOS JAR
build does not verify Windows installation or taskbar behaviour.

Windows shortcuts use an icon filename derived from the artwork SHA-256 hash, so artwork changes get a fresh Explorer cache key. Installation refreshes existing desktop shortcuts even when the desktop task is deselected, updates Start menu icons, and notifies Explorer of association changes. User-created or pinned copies of shortcuts may still need to be recreated.
