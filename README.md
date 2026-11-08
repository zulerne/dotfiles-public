# dotfiles

[![Catppuccin](https://img.shields.io/badge/theme-Catppuccin_Mocha-cba6f7)](https://catppuccin.com)

My dotfiles with Catppuccin theme.

![dark](screenshot-dark.png)

## What's inside

- **Shell**: zsh + Oh-My-Zsh + Starship prompt
- **Terminal**: [Rex](https://www.superlogical.com/rex/) with floating panes for a scratch shell, Lazygit and Yazi; Ghostty config is kept as well
- **Editors**: Neovim (default) and Zed
- **CLI**: Atuin, bat, btop, eza, fzf, ripgrep, fd, Glow, zoxide, yazi, lazygit
- **Theme**: Catppuccin (auto light/dark switching)
- **Font**: JetBrains Mono Nerd Font
- **Packages**: Brewfile for Homebrew

## Quick start

```bash
git clone https://github.com/zulerne/dotfiles-public.git ~/.dotfiles
cd ~/.dotfiles
./install.sh  # installs Oh-My-Zsh, zsh plugins, links configs, and installs Yazi packages
```

To stow selectively: `stow zsh starship ghostty`
To preview changes: `stow -n -v zsh`
To remove symlinks: `stow -D zsh`

## Structure

Package directories mirror paths from `$HOME`. `go60/`, `iterm/`, `brave/`, and `manual/` are excluded from the Makefile and installation script's Stow operations.

```
zsh/.zshrc                              → ~/.zshrc
zsh/.zprofile                           → ~/.zprofile
zsh/.zsh/catppuccin-apply.zsh           → ~/.zsh/catppuccin-apply.zsh
atuin/.config/atuin/                    → ~/.config/atuin/
btop/.config/btop/themes/               → ~/.config/btop/themes/
glow/.config/glow/styles/               → ~/.config/glow/styles/
starship/.config/starship.toml          → ~/.config/starship.toml
ghostty/.config/ghostty/config          → ~/.config/ghostty/config
nvim/.config/nvim/                      → ~/.config/nvim/
zed/.config/zed/                       → ~/.config/zed/
bat/.config/bat/config                  → ~/.config/bat/config
lazygit/.config/lazygit/                → ~/.config/lazygit/
yazi/.config/yazi/                      → ~/.config/yazi/
rex/.config/rex/init.lua                → ~/.config/rex/init.lua
git/.gitconfig                          → ~/.gitconfig
git/.gitignore_global                   → ~/.gitignore_global
```

`go60/` contains the current GO60 layout-editor JSON export for keyboard firmware.

`iterm/` contains an iTerm2 preferences snapshot with personal paths removed. Import it separately through iTerm2's preferences workflow; it is not a Stow package.

`rex/` is the Rex Lua config: Cmd+S, Cmd+G, Cmd+Y and Cmd+B toggle floating panes with a scratch shell, Lazygit, Yazi and btop. Run `rex config reload` after editing it.

`manual/rex/` contains Rex appearance and shortcut snapshots with a backup-aware save/restore script. Follow [manual/README.md](manual/README.md) to restore them after quitting Rex.

Yazi plugins and Catppuccin flavors are listed in `yazi/.config/yazi/package.toml`. After linking Yazi configs manually, run `ya pkg install` to install them.

`AGENTS.md` and `CLAUDE.md` contain project instructions for Codex and Claude Code. Global agent settings are kept outside this public repository.

## Personalization

Machine-specific secrets go in local override files (gitignored):

- `~/.zshrc.local` — API keys, tokens, private env vars
- `~/.gitconfig.local` — name, email, signing key

For Yazi's `g v` shortcut, set your Obsidian vault path in `~/.zshrc.local`:

```bash
export OBSIDIAN_VAULT="/path/to/your/vault"
```

The shortcut does nothing when `OBSIDIAN_VAULT` is unset.

## Neovim

The config mirrors the Zed setup in `zed/`, so the same keys work in both.
Space is the leader key.

| Keys | Action |
|------|--------|
| `Space e` | File tree: open, focus, close; `Esc` returns to the editor, `-` moves to the parent folder |
| `Space f` / `Space b` | Find file / switch between open buffers (opens in the list: `j`/`k`, `dd` closes) |
| `Space /`, `g/` | Search in project; `Space s…` for more pickers, `Space s.` resumes the last one |
| `Space sr` | Search and replace in the project (grug-far); in Visual mode, for the selection |
| `Space p` | Recent projects: switches to the project and restores its session |
| `Space sd` / `Space sD` | Diagnostics in the project / in the file |
| `Space w` / `Space q` / `Space Q` | Save / close buffer / quit Neovim |
| `Space g` | Lazygit in a floating window; `e` on a file opens it here |
| `Space t`, `Alt+Space` | Toggle terminal |
| `Space r` / `Space R` | Save and run: the Go test under the cursor, `go run .` in a `package main` file, else the last command / edit the command first |
| `gd` `gD` `gy` `gI` `gA` | Definition, declaration, type, implementation, references |
| `gs` / `gS` | Symbols in file / project |
| `cd` / `g.` / `gh` | Rename / code actions / signature and docs (again to scroll it) |
| `]m` `[m` / `grx` | Next/previous function / run the code lens under the cursor |
| `]/` `[/` | Next/previous comment |
| `]t` `[t` / `Space st` | Next/previous TODO, FIXME, HACK… comment / search them in the project |
| `s` / `S` | Flash: jump anywhere on screen (type 1–2 letters, then the label) / select a syntax node |
| `[-` `]-` / `[+` `]+` / `[=` `]=` | Previous/next line with less / more / the same indent |
| `]c` `[c` `do` `dO` `dp` | Next/previous change, expand hunk, stage, restore |
| `Tab` | Accept completion or Copilot suggestion |
| `ys` `cs` `ds` | Add / change / delete surrounding characters |
| `gl` `gL` / `g>` `g<` / `ga` | Multi-cursor, as in Zed: add a cursor at the next/previous match / skip and add / all matches; `Esc` clears |
| `F4`/`F5`, `F9`, `F10`, `F11`, `Shift+F11`, `Shift+F5` | Debugger, as in Zed: start/continue, breakpoint, step over, step into, step out, stop |
| `Space dt` / `Space db` / `Space dd` | Debug the Go test under the cursor / breakpoint / start or continue; more under `Space d` |

Opening Neovim on a directory (`v`, `nvim`, `nvim .`) restores that project's
open files for the current git branch, like Zed; `Space sS` lists sessions.
Files save when you leave a buffer or the terminal loses focus, and format on
save: goimports for Go, Ruff for Python, StyLua for Lua. Go files are also
checked by golangci-lint on open and save, using the project's `.golangci.yml`
or its default linters. Run `:Copilot auth`
once to sign in to GitHub Copilot. `:Mason` shows installed tools and
`:checkhealth` reports problems. JSON, YAML and Bash language servers run on
Node.js; yaml-language-server needs a newer Node.js than 18.

## Shell aliases

Standard commands are replaced with modern alternatives:

| Command | Replacement |
|---------|-------------|
| `cat`   | bat         |
| `ls`    | eza         |
| `cd`    | zoxide      |
| `find`  | fd          |
| `http`  | xh          |

Use `rg` directly for ripgrep. Atuin handles `Ctrl+R` history search; the Up arrow keeps its existing behavior. fzf's `Ctrl+T` selects files and directories with bat/eza previews. Direnv loads project environments when installed.

## Markdown and themes

The shell selects Catppuccin Latte or Mocha at startup based on macOS appearance. Atuin and Glow use the bundled themes; btop themes can be selected in btop's settings. Starship uses an atomically generated cache for each palette under `~/.cache/catppuccin/`.

In Yazi, Markdown files open in Glow's pager. Press `q` to return, or `O` to choose another opener. `g c` opens `~/.dotfiles`; `D` is disabled to prevent permanent deletion.

## Brave policies

`brave/brave.mobileconfig` contains the private dotfiles' Brave policy profile. It is installed separately from Stow:

```bash
make brave-policies
```

Review and finish installing **Brave — Minimal** in System Settings. Quit and reopen Brave, then inspect `brave://policy`. The profile disables optional Brave services, AI, crypto features, Tor and telemetry. It applies to stable Brave for all users of the Mac.

To remove it, run `make brave-policies-delete` and remove the profile in System Settings. The Make targets open the relevant UI; installation and removal require manual confirmation there.

## Notes

Configs are tailored for macOS (Apple Silicon). On Linux you'll need to adjust:

- `zsh/.zprofile` — Homebrew path (`/opt/homebrew/...` → `/home/linuxbrew/...`)
- `zsh/.zshrc` — remove `macos` from Oh-My-Zsh plugins
- `zsh/.zsh/catppuccin-apply.zsh` — replace `defaults read` with your DE's dark mode detection
- `ghostty/.config/ghostty/config` — adjust macOS-specific settings
