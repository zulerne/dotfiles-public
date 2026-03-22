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
mkdir -p "$_CACHE"

# Starship: generate config with correct palette
sed "s/^palette = .*/palette = \"catppuccin_$_CATPPUCCIN\"/" \
    "$HOME/.config/starship.toml" > "$_CACHE/starship.toml"
export STARSHIP_CONFIG="$_CACHE/starship.toml"

# Yazi: copy active theme
cp "$HOME/.config/yazi/catppuccin-$_CATPPUCCIN.toml" "$HOME/.config/yazi/theme.toml"

# --- Environment variables ---
export BAT_THEME="auto:system"
export BAT_THEME_DARK="Catppuccin Mocha"
export BAT_THEME_LIGHT="Catppuccin Latte"
export LG_CONFIG_FILE="$HOME/Library/Application Support/lazygit/config.yml,$HOME/.config/lazygit/catppuccin-$_CATPPUCCIN.yml"

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
