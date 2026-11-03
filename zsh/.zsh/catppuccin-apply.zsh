#!/usr/bin/env zsh
# Apply catppuccin theme (mocha/latte) based on macOS appearance.
# Sourced from .zshrc on shell startup.

if [[ "$(defaults read -g AppleInterfaceStyle 2>/dev/null)" == "Dark" ]]; then
    _CATPPUCCIN="mocha"
else
    _CATPPUCCIN="latte"
fi

# --- Runtime config generation (avoids modifying git-tracked files) ---
_CACHE="$HOME/.cache/catppuccin"

# Starship: select a separate cache for each palette. Publish complete files
# atomically so concurrent shells never read a partially written config.
() {
    local source_config="$HOME/.config/starship.toml"
    local cached_config="$_CACHE/starship-${_CATPPUCCIN}.toml"
    local temp_config

    # Fall back to the source config if the cache cannot be generated.
    export STARSHIP_CONFIG="$source_config"
    [[ -r "$source_config" ]] || return

    if [[ ! -s "$cached_config" || "$source_config" -nt "$cached_config" ]]; then
        command mkdir -p -- "$_CACHE" || return
        temp_config="$(mktemp "$_CACHE/starship-${_CATPPUCCIN}.XXXXXX")" || return
        if ! command sed "s/^palette = .*/palette = \"catppuccin_$_CATPPUCCIN\"/" \
            "$source_config" > "$temp_config" \
            || ! command mv -f -- "$temp_config" "$cached_config"; then
            command rm -f -- "$temp_config"
            return
        fi
    fi

    export STARSHIP_CONFIG="$cached_config"
}

# --- Environment variables ---
export LG_CONFIG_FILE="$HOME/Library/Application Support/lazygit/config.yml,$HOME/.config/lazygit/catppuccin-$_CATPPUCCIN.yml"
export ATUIN_THEME__NAME="catppuccin-${_CATPPUCCIN}-mauve"
# Glow's CLI reads GLOW_STYLE; its TUI reads GLAMOUR_STYLE.
export GLOW_STYLE="$HOME/.config/glow/styles/catppuccin-${_CATPPUCCIN}.json"
export GLAMOUR_STYLE="$GLOW_STYLE"

# --- FZF colors ---
if [[ "$_CATPPUCCIN" == "mocha" ]]; then
    _FZF_COLORS=" \
--color=bg+:#313244,bg:#1E1E2E,spinner:#F5E0DC,hl:#F38BA8 \
--color=fg:#CDD6F4,header:#F38BA8,info:#CBA6F7,pointer:#F5E0DC \
--color=marker:#B4BEFE,fg+:#CDD6F4,prompt:#CBA6F7,hl+:#F38BA8 \
--color=selected-bg:#45475A \
--color=border:#6C7086,label:#CDD6F4"
else
    _FZF_COLORS=" \
--color=bg+:#CCD0DA,bg:#EFF1F5,spinner:#DC8A78,hl:#D20F39 \
--color=fg:#4C4F69,header:#D20F39,info:#8839EF,pointer:#DC8A78 \
--color=marker:#7287FD,fg+:#4C4F69,prompt:#8839EF,hl+:#D20F39 \
--color=selected-bg:#BCC0CC \
--color=border:#9CA0B0,label:#4C4F69"
fi

# --- zsh-syntax-highlighting (sets ZSH_HIGHLIGHT_STYLES) ---
source "$HOME/.zsh/catppuccin_${_CATPPUCCIN}-zsh-syntax-highlighting.zsh"
