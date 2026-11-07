# ==============================================
# PATHS & ENVIRONMENT
# ==============================================

# Keep the first occurrence of each path, including on repeated sourcing.
typeset -U path PATH

# Local bin
export PATH="$HOME/.local/bin:$PATH"

# Go
export GOPATH="$HOME/go"
export PATH="$GOPATH/bin:$PATH"

# Added by Obsidian
export PATH="$PATH:/Applications/Obsidian.app/Contents/MacOS"

# Rust (optional)
if [[ -r "$HOME/.cargo/env" ]]; then
  source "$HOME/.cargo/env"
fi

# ==============================================
# CATPPUCCIN (auto light/dark)
# ==============================================

# Must be before oh-my-zsh (sets zsh-syntax-highlighting colors)
source "$HOME/.zsh/catppuccin-apply.zsh"

# ==============================================
# OH-MY-ZSH CONFIGURATION
# ==============================================

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Plugins (Syntax Highlighting must be last)
plugins=(
  git
  docker
  docker-compose
  macos
  zsh-autosuggestions
  zoxide
  fzf
  golang
  starship
  zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# ==============================================
# USER CONFIGURATION
# ==============================================

# Editor
export EDITOR='nvim'
export VISUAL='nvim'

# --- KEYBINDINGS ---
bindkey '^ ' autosuggest-accept
bindkey ' ' magic-space

# --- ALIASES ---

# Modern replacements
alias cat="bat"
alias ls="eza --icons"
alias tree="eza --tree --icons"
# alias grep="rg"
alias cd="z"
alias find="fd"
alias http="xh"
alias code="zed"
alias lg="lazygit"
alias ldo="lazydocker"
alias c="claude"

# Yazi: keep the shell in the directory selected on exit.
unalias fm 2>/dev/null
function fm() {
  local yazi_cwd_file yazi_cwd yazi_exit_code
  yazi_cwd_file="$(mktemp -t yazi-cwd.XXXXXX)" || return
  command yazi "$@" --cwd-file="$yazi_cwd_file"
  yazi_exit_code=$?
  IFS= read -r -d '' yazi_cwd <"$yazi_cwd_file"
  if [[ -n "$yazi_cwd" && "$yazi_cwd" != "$PWD" && -d "$yazi_cwd" ]]; then
    builtin cd -- "$yazi_cwd"
  fi
  command rm -f -- "$yazi_cwd_file"
  return "$yazi_exit_code"
}

# Utils
alias -g C='| pbcopy'
alias -g G='| rg'
alias -g J='| jq'

# Associations (open specific files in bat)
alias -s {json,yml,yaml,toml,md,txt,log}=bat
alias -s go=code

# Editor replacements
alias nano="nvim"
alias vim="nvim"
alias v="nvim ."  # open Neovim in the current directory, with the file tree

# ==============================================
# TOOL SETTINGS (UX & Behavior)
# ==============================================

# --- FZF ---
# Standalone fzf: use fd (respects ignore files, excludes .git).
# Ctrl+T and Alt+C use fzf's built-in filesystem walker.
export FZF_DEFAULT_COMMAND='fd --type f --strip-cwd-prefix --hidden --follow --exclude .git'

# FZF Appearance (Catppuccin colors set by catppuccin-apply.zsh)
export FZF_DEFAULT_OPTS=" \
--height 40% \
--layout=reverse \
--border \
--info=inline \
--prompt='> ' \
--pointer='>' \
--marker='+' \
$_FZF_COLORS"

# Ctrl+T: select files and directories, with a preview for each type.
export FZF_CTRL_T_OPTS=" \
--walker-skip .git,node_modules,target \
--preview 'if [ -d {} ]; then eza --tree --level=2 --color=always --icons -- {}; else bat --style=plain --color=always --paging=never --line-range=:500 -- {}; fi' \
--bind 'ctrl-/:change-preview-window(down|hidden|)'"

# Ctrl+R: Command History Preview
export FZF_CTRL_R_OPTS=" \
--preview 'echo {}' --preview-window up:3:hidden:wrap \
--bind 'ctrl-/:toggle-preview' \
--bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort' \
--color header:italic \
--header 'Press CTRL-Y to copy command into clipboard'"

# ==============================================
# HISTORY SETTINGS (Infinite)
# ==============================================

HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000000
SAVEHIST=10000000

setopt EXTENDED_HISTORY
setopt SHARE_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_SAVE_NO_DUPS

# Atuin: use Ctrl+R for history search, keeping the existing Up-arrow behavior.
if command -v atuin >/dev/null 2>&1; then
  eval "$(atuin init zsh --disable-up-arrow)"
fi

# Start new shells in the ABC (English) layout; in the background so startup isn't delayed.
if command -v macism >/dev/null 2>&1; then
  macism com.apple.keylayout.ABC &!
fi

# ==============================================
# ARCHIVED / DISABLED TOOLS
# ==============================================

# Google Cloud SDK
# if [ -f "$HOME/google-cloud-sdk/path.zsh.inc" ]; then . "$HOME/google-cloud-sdk/path.zsh.inc"; fi
# if [ -f "$HOME/google-cloud-sdk/completion.zsh.inc" ]; then . "$HOME/google-cloud-sdk/completion.zsh.inc"; fi

# Bun / Python / Pipx
# [ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"
# export BUN_INSTALL="$HOME/.bun"
# export PATH="$BUN_INSTALL/bin:$PATH"
# alias py='python3'
# export PATH="$PATH:$HOME/.local/bin"

# Claude Code through AWS Bedrock (subscription by default; credentials belong in ~/.zshrc.local)
alias claude-bedrock='CLAUDE_CODE_USE_BEDROCK=1 AWS_REGION=us-east-1 AWS_PROFILE=default claude'

# Machine-specific secrets and overrides (not tracked by git).
[ -f "$HOME/.zshrc.local" ] && source "$HOME/.zshrc.local"

# Direnv: load project environments after the other shell setup.
if command -v direnv >/dev/null 2>&1; then
  eval "$(direnv hook zsh)"
fi
