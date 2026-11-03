# Manual Configs

Files that are not managed by stow — copy manually.

## Rex (macOS)

All saved Rex configuration lives in `manual/rex/` and is copied manually;
Rex is not managed by Stow. The snapshots contain:

- `init.lua` — `~/.config/rex/init.lua`; currently only a comment, since custom
  shortcuts were set in the app instead.
- `preferences.plist` — selected appearance, font, custom Catppuccin Latte/Mocha
  themes, server and update settings from `com.superlogical.rex` preferences.
- `shortcuts.json` — keyboard shortcuts set in the app (Cmd+N: new session,
  Ctrl+K: next session, Ctrl+R: rename session).

Update these snapshots from this Mac after changing settings in Rex:

```bash
python3 manual/rex/settings.py save
```

Restore on a Mac with Rex installed, **after quitting Rex.app**. Run this from
another terminal app, since quitting Rex disconnects its terminals:

```bash
cd ~/.dotfiles
python3 manual/rex/settings.py restore
```

The restore command backs up existing preferences, `init.lua` and shortcuts under
`~/Library/Application Support/rex-settings-backups/`, merges the saved
preferences into the current domain, and copies `init.lua` and shortcuts.
Then open Rex. After editing Lua settings, run `rex config check` and
`rex config reload` on the server's machine.
Install JetBrainsMono Nerd Font Mono separately for the saved font setting.
If `~/.config/rex/init.lua` is a symlink from an older setup, move that link
aside before restoring; the script refuses to overwrite it.

All saved settings are snapshots; run `save` again to capture
changes. Machine IDs, synced hosts, window/session state, sockets, terminal
history, and Tailscale credentials are excluded. The saved Tailscale switch
does not restore authentication; sign in again on a new Mac if needed.

References: [Rex configuration](https://www.superlogical.com/rex/docs/customize/config),
[Mac settings](https://www.superlogical.com/rex/docs/reference/mac-settings).
