# Repository Instructions

macOS dotfiles managed with GNU Stow. Package directories mirror paths under `$HOME`.

## Layout

- `zsh/`: Oh-My-Zsh, aliases, shell functions, and Catppuccin theme switching.
- `starship/`, `ghostty/`, `bat/`, `lazygit/`: prompt, terminal, and CLI themes.
- `atuin/`, `btop/`, `glow/`: shell history settings and CLI themes.
- `nvim/`, `zed/`: editor settings and keymaps; the Neovim config mirrors Zed's keys. The shell's default editor is `nvim`; `v` opens `nvim .`.
- `rex/`: Rex Lua config with toggleable floating panes (Cmd+S scratch shell, Cmd+G Lazygit, Cmd+Y Yazi, Cmd+B btop).
- `yazi/`: file manager settings, keymaps, plugins, and light/dark flavors.
- `git/`: portable Git settings; personal identity belongs in `~/.gitconfig.local`.
- `go60/`: GO60 layout-editor JSON export for keyboard firmware, excluded from Stow.
- `iterm/`, `brave/`, `manual/`: separately restored iTerm2 preferences, Brave policy profile and Rex settings; excluded from Stow.
- `Brewfile`: Homebrew dependencies.

## Working Agreements

- Keep README documentation in English.
- Keep `zsh-syntax-highlighting` last in the Oh-My-Zsh plugins list.
- Preserve suffix aliases and global aliases when editing shell configuration.
- Keep credentials and machine-specific values in gitignored local overrides, such as `~/.zshrc.local` and `~/.gitconfig.local`.
- When syncing from private dotfiles, inspect the working tree, including uncommitted changes; review files before copying and remove secrets and personal paths from the public version.
- Preserve public installation scripts, privacy exclusions, and unrelated user changes.
- Keep global Claude Code and Codex settings outside this public repository; this root file contains project-specific guidance.

## Commands and Verification

- `make stow`, `make restow`, `make delete`: manage package symlinks. These affect the home directory; use a dry run or a temporary target when verifying changes.
- `stow -n -v zsh`: preview one package.
- `brew bundle dump --force --file=~/.dotfiles/Brewfile`: update the dependency list when requested.
- Validate changed shell scripts with `bash -n` or `zsh -n`, and parse JSON, TOML, and plist files where applicable. Zed uses JSON with comments and trailing commas.
- Run `git diff --check` and scan the public files with `gitleaks dir --redact --no-banner .` after a private-to-public sync.
- Yazi plugins and flavors are installed with `ya pkg install` after its configs are linked.
