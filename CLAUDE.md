# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Apple Silicon macOS dotfiles managed with **GNU Stow**, normally cloned to `~/.dotfiles`. Stow packages mirror the home directory structure. `manual/`, `go60/`, `iterm/`, and `brave/` are excluded by Makefile.

## Stow Commands

```bash
# Run from ~/.dotfiles
make stow                 # Apply the packages selected by Makefile
make restow               # Relink those packages
make delete               # Remove their symlinks
make -n stow              # Print the selected Stow command without running it
stow --simulate zsh       # Check shell-package conflicts without applying
stow zsh                  # Apply single package (creates symlinks in ~)
stow -D zsh               # Remove symlinks for a package
command ya pkg install    # Restore Yazi plugins and flavors from package.toml
```

Use the Makefile targets for all-package operations. Do not use `stow */`;
it includes directories that need separate setup. Resolve existing config
conflicts explicitly; do not overwrite or adopt user files automatically.

## Packages

- **atuin/** — history search settings and Catppuccin themes
- **bat/** — file viewer settings with light/dark themes
- **btop/** — Catppuccin resource-monitor themes
- **ghostty/** — `.config/ghostty/config`: Ghostty terminal config (Catppuccin auto light/dark, JetBrains Mono)
- **git/** — `.gitconfig` and `.gitignore_global`
- **glow/** — Catppuccin styles for Markdown rendering
- **lazygit/** — light/dark theme overlays
- **nvim/** — editor settings, keybindings, lazy.nvim plugins and lockfile
- **starship/** — `.config/starship.toml`: prompt config and both Catppuccin palettes
- **yazi/** — file manager settings, keybindings, local plugins and `package.toml`
- **zed/** — editor settings, keybindings and tasks
- **zsh/** — `.zshrc`, `.zprofile`, `.zsh/`: Oh My Zsh, aliases, fzf, environment variables and theme setup
- **iterm/** — iTerm2 preferences snapshot; excluded from Makefile
- **Brewfile** — Homebrew packages, casks, VS Code extensions and Go tools (not a stow package)
- **go60/** — current GO60 layout-editor JSON export; excluded from Makefile
- **brave/** — macOS configuration profile; use the dedicated `make brave-policies` target and finish installation in System Settings
- **manual/rex/** — Rex settings copied manually; see `manual/README.md`

## Key Conventions

- Shell aliases: `cat`→`bat`, `ls`→`eza --icons`, `cd`→`z`, `find`→`fd`, `http`→`xh`, `code`→`zed`
- `grep` is not aliased; `rg` is available separately
- Default editor (`EDITOR` and `VISUAL`) is `nvim`; `vim` and `nano` are aliases for it
- `fm` launches Yazi and keeps the shell in the directory selected on exit
- Atuin handles `Ctrl+R`; the Up arrow retains its existing behavior
- fzf `Ctrl+T` selects files and directories, with previews through bat/eza; `Alt+C` changes directory
- Yarn is not enabled as an Oh My Zsh plugin; keep `ya` available for Yazi
- README is in English
- Brewfile updates: `brew bundle dump --force --file=~/.dotfiles/Brewfile`; review the diff before accepting it
- Git rewrites GitHub HTTPS URLs to SSH; plugin downloads require working GitHub SSH access
- Machine-specific shell settings and credentials belong in `~/.zshrc.local`, outside the repository
- Keep personal Git identity in `~/.gitconfig.local`
- Review private dotfiles before copying; preserve public installation scripts, privacy exclusions, portable paths and local overrides
- Keep global Claude Code and Codex settings outside this public repository

## When Editing .zshrc

- `zsh-syntax-highlighting` plugin **must** be last in the plugins list
- Configure PATH before loading Oh My Zsh; keep `typeset -U path PATH` to avoid duplicates
- Rust environment setup is optional; only source `~/.cargo/env` when readable
- Apply Catppuccin highlighting colors before Oh My Zsh loads
- Starship uses separate generated light/dark configs under `~/.cache/catppuccin/`, selected at shell startup through `STARSHIP_CONFIG`; preserve atomic cache writes and keep the tracked TOML unchanged
- eza has a native completion installed by Homebrew; do not replace it with the completion for ls
- Suffix aliases (e.g., `alias -s json=bat`) auto-open file types with the mapped tool
- Global aliases (e.g., `alias -g C='| pbcopy'`) are pipe shortcuts
