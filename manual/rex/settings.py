#!/usr/bin/env python3
"""Save or restore Rex's macOS settings without copying machine identity."""

import argparse
from datetime import datetime
import json
from pathlib import Path
import plistlib
import shutil
import subprocess
import tempfile


DOMAIN = "com.superlogical.rex"
HERE = Path(__file__).resolve().parent
PREFERENCES = Path.home() / "Library/Preferences" / f"{DOMAIN}.plist"
INIT = Path.home() / ".config/rex/init.lua"
SHORTCUTS = (
    Path.home() / "Library/Application Support" / DOMAIN / "Shortcuts/shortcuts.json"
)
KEYS = {
    "Workspace.appearance",
    "Workspace.sidebarCollapsed",
    "Workspace.lightThemeID",
    "Workspace.interfaceStyle",
    "Workspace.inactivePaneFadeMode",
    "Workspace.terminalFontName",
    "Workspace.sidebarPosition",
    "Workspace.tabIconTintMode",
    "Workspace.usesStandardInactiveWindowPaneStyles",
    "Workspace.tabStyle",
    "Workspace.darkThemeID",
    "Workspace.paneDensity",
    "Workspace.customThemes",
    "Workspace.terminalFontPointSize",
    "Workspace.hiddenChromeButtons",
    "rex.server.tailnet-enabled",
    "rex.server.automatic-restart-enabled",
    "rex.server.web-client-origin-patterns",
    "rex.server.block-plugin-reload-enabled",
    "rex.server.run-mode",
    "rex.agents.names-sessions",
    "rex.client.remoteControl",
    "SUEnableAutomaticChecks",
    "SUAutomaticallyUpdate",
    "SUScheduledCheckInterval",
}


def read_preferences():
    result = subprocess.run(
        ["/usr/bin/defaults", "export", DOMAIN, "-"], capture_output=True
    )
    if result.returncode:
        # A fresh installation may not have a preferences domain yet.
        if not PREFERENCES.exists() and b"does not exist" in result.stderr:
            return {}
        result.check_returncode()
    return plistlib.loads(result.stdout)


def save():
    preferences = read_preferences()
    selected = {key: value for key, value in preferences.items() if key in KEYS}
    if not selected:
        raise SystemExit("No Rex settings found; snapshot left unchanged.")
    shortcuts = SHORTCUTS.read_bytes()
    json.loads(shortcuts)
    init = INIT.read_bytes()
    (HERE / "preferences.plist").write_bytes(plistlib.dumps(selected))
    (HERE / "shortcuts.json").write_bytes(shortcuts)
    (HERE / "init.lua").write_bytes(init)
    print(f"Saved {len(selected)} preferences, init.lua and keyboard shortcuts to {HERE}")


def restore():
    # Quit Rex.app before running this, so it cannot overwrite restored settings.
    if INIT.is_symlink():
        raise SystemExit("init.lua is a symlink; move it aside before restoring a manual copy.")
    saved = plistlib.loads((HERE / "preferences.plist").read_bytes())
    if saved.keys() - KEYS:
        raise SystemExit("Snapshot contains unexpected preference keys.")
    shortcuts = (HERE / "shortcuts.json").read_bytes()
    json.loads(shortcuts)
    init = (HERE / "init.lua").read_bytes()
    current = read_preferences()
    backup_root = Path.home() / "Library/Application Support/rex-settings-backups"
    backup_root.mkdir(parents=True, exist_ok=True, mode=0o700)
    backup = Path(tempfile.mkdtemp(prefix=datetime.now().strftime("%Y%m%d-%H%M%S-"), dir=backup_root))
    (backup / "preferences.plist").write_bytes(plistlib.dumps(current))
    if SHORTCUTS.exists():
        shutil.copy2(SHORTCUTS, backup / "shortcuts.json")
    if INIT.exists():
        shutil.copy2(INIT, backup / "init.lua")
    merged = {**current, **saved}
    with tempfile.NamedTemporaryFile(suffix=".plist") as temporary:
        temporary.write(plistlib.dumps(merged))
        temporary.flush()
        subprocess.run(
            ["/usr/bin/defaults", "import", DOMAIN, temporary.name], check=True
        )
    SHORTCUTS.parent.mkdir(parents=True, exist_ok=True)
    SHORTCUTS.write_bytes(shortcuts)
    INIT.parent.mkdir(parents=True, exist_ok=True)
    INIT.write_bytes(init)
    print(f"Restored Rex settings. Previous settings: {backup}")
    print("Open Rex.app. Sign in to Tailscale again if needed on a new Mac.")


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("action", choices=("save", "restore"))
    args = parser.parse_args()
    {"save": save, "restore": restore}[args.action]()
