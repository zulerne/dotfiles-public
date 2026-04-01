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
    yarn
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
alias grep="rg"
alias cd="z"
alias find="fd"
alias http="xh"
alias code="zed"
alias fm="yazi"
alias lg="lazygit"
alias ldo="lazydocker"
alias c="claude"

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

# Eza completion fix
compdef eza=ls

# ==============================================
# PATHS & ENVIRONMENT (System Plumbing)
# ==============================================

# Local bin
export PATH="$HOME/.local/bin:$PATH"

# Go
export GOPATH="$HOME/go"
export PATH="$GOPATH/bin:$PATH"

# JetBrains Toolbox
export PATH="$PATH:$HOME/Library/Application Support/JetBrains/Toolbox/scripts"

# ==============================================
# TOOL SETTINGS (UX & Behavior)
# ==============================================

# --- FZF ---
# Search Engine: Use fd (fast, ignores .git)
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

# Ctrl+T: File Preview (Clean, no line numbers)
export FZF_CTRL_T_OPTS=" \
--preview 'bat --color=always {}' \
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
setopt HIST_REDUCE_BLANKS

# ==============================================
# OPTIONAL TOOLS (uncomment to enable)
# ==============================================

# Google Cloud SDK
# if [ -f "$HOME/google-cloud-sdk/path.zsh.inc" ]; then . "$HOME/google-cloud-sdk/path.zsh.inc"; fi
# if [ -f "$HOME/google-cloud-sdk/completion.zsh.inc" ]; then . "$HOME/google-cloud-sdk/completion.zsh.inc"; fi

# NVM
# export NVM_DIR="$HOME/.nvm"
# [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"
# [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"

# Bun
# [ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"
# export BUN_INSTALL="$HOME/.bun"
# export PATH="$BUN_INSTALL/bin:$PATH"

# Rust / Cargo
. "$HOME/.cargo/env"

# ==============================================
# LOCAL OVERRIDES (not tracked by git)
# ==============================================

[ -f ~/.zshrc.local ] && source ~/.zshrc.local
