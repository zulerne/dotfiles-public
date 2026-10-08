# dotfiles

[![Catppuccin](https://img.shields.io/badge/theme-Catppuccin_Mocha-cba6f7)](https://catppuccin.com)

My dotfiles with Catppuccin theme.

![dark](screenshot-dark.png)
![light](screenshot-light.png)

## What's inside

- **Shell**: zsh + Oh-My-Zsh + Starship prompt
- **Terminal**: Ghostty
- **Editors**: Neovim (default) and Zed
- **CLI**: bat, eza, fzf, ripgrep, fd, zoxide, yazi, lazygit, lazydocker
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

Package directories mirror paths from `$HOME`. `go60/` is excluded from Stow.

```
zsh/.zshrc                              → ~/.zshrc
zsh/.zprofile                           → ~/.zprofile
zsh/.zsh/catppuccin-apply.zsh           → ~/.zsh/catppuccin-apply.zsh
starship/.config/starship.toml          → ~/.config/starship.toml
ghostty/.config/ghostty/config          → ~/.config/ghostty/config
nvim/.config/nvim/init.lua             → ~/.config/nvim/init.lua
zed/.config/zed/                       → ~/.config/zed/
bat/.config/bat/config                  → ~/.config/bat/config
lazygit/.config/lazygit/                → ~/.config/lazygit/
yazi/.config/yazi/                      → ~/.config/yazi/
git/.gitconfig                          → ~/.gitconfig
git/.gitignore_global                   → ~/.gitignore_global
```

`go60/` — ZMK keymap and layout export for keyboard firmware.

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

## Shell aliases

Standard commands are replaced with modern alternatives:

| Command | Replacement |
|---------|-------------|
| `cat`   | bat         |
| `ls`    | eza         |
| `grep`  | ripgrep     |
| `cd`    | zoxide      |
| `find`  | fd          |
| `http`  | xh          |

## Notes

Configs are tailored for macOS (Apple Silicon). On Linux you'll need to adjust:

- `zsh/.zprofile` — Homebrew path (`/opt/homebrew/...` → `/home/linuxbrew/...`)
- `zsh/.zshrc` — remove `macos` from Oh-My-Zsh plugins
- `zsh/.zsh/catppuccin-apply.zsh` — replace `defaults read` with your DE's dark mode detection
- `ghostty/.config/ghostty/config` — adjust macOS-specific settings
