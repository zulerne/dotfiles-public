#!/usr/bin/env bash
set -euo pipefail

DOTFILES="$HOME/.dotfiles"

# Check for stow
if ! command -v stow &> /dev/null; then
    # macOS: brew install stow
    # Linux: sudo apt install stow / sudo pacman -S stow
    echo "GNU Stow not found. Install it first."
    exit 1
fi

# Check for Oh-My-Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Installing Oh-My-Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# Install custom zsh plugins
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
fi

if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
fi

cd "$DOTFILES"
stow --restow */
echo "Dotfiles linked successfully"
