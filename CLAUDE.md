# CLAUDE.md

This file provides guidance to Claude Code when working with code in this repository.

## Overview

macOS dotfiles managed with **GNU Stow**. Package directories mirror the home directory structure; `go60/` is excluded from Stow.

## Stow Commands

```bash
make stow      # Apply all packages
make restow    # Re-apply all packages
make delete    # Remove all symlinks
stow zsh       # Apply single package
```

## Packages

- **zsh/** — `.zshrc`, `.zprofile`, `.zsh/`: Oh-My-Zsh config, aliases, fzf, Catppuccin theme scripts
- **starship/** — `.config/starship.toml`: prompt config
- **nvim/** — `.config/nvim/init.lua`: Neovim with lazy.nvim and Catppuccin theme
- **zed/** — `.config/zed/`: Zed editor settings and keymap
- **ghostty/** — `.config/ghostty/config`: Ghostty terminal (Catppuccin auto light/dark, JetBrains Mono)
- **bat/** — `.config/bat/config`: automatic light/dark Catppuccin theme selection
- **lazygit/** — `.config/lazygit/`: Catppuccin lazygit themes
- **yazi/** — `.config/yazi/`: file manager config and Catppuccin themes
- **go60/** — `go60-layout.keymap` and layout JSON: ZMK keymap for GO60 keyboard (home row mods, cursor/symbol/mouse layers; not a stow package)
- **git/** — `.gitconfig`, `.gitignore_global`
- **Brewfile** — all brew/cask/vscode/go dependencies (not a stow package)

## Key Conventions

- Shell aliases replace standard commands: `cat`→`bat`, `ls`→`eza`, `grep`→`rg`, `cd`→`z`, `find`→`fd`, `http`→`xh`, `code`→`zed`
- Default editor is `nvim`
- README is in English
- Keep credentials in `~/.zshrc.local` and personal Git identity in `~/.gitconfig.local`
- Review private dotfiles before copying them into this public repository; remove secrets and personal paths
- Brewfile updates: `brew bundle dump --force --file=~/.dotfiles/Brewfile`

## When Editing .zshrc

- `zsh-syntax-highlighting` plugin **must** be last in the plugins list
- Suffix aliases (e.g., `alias -s json=bat`) auto-open file types with the mapped tool
- Global aliases (e.g., `alias -g C='| pbcopy'`) are pipe shortcuts
