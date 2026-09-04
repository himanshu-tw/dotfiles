#!/bin/bash

set -e

PACKAGE="stow"

# Check if the package is installed
if dpkg -s "$PACKAGE" > /dev/null 2>&1; then
    echo "✔ $PACKAGE is installed."
else
    echo "❌ $PACKAGE is NOT installed."
fi


# Remove existing to avoid nesting issue
rm -rf ~/.config/nvim
rm -rf ~/.config/alacritty/alacritty.toml
rm -f ~/.tmux.conf
rm -f ~/.zshrc

stow alacritty
stow bash
stow tmux
stow nvim
stow sway
stow waybar
stow wofi
stow starship
stow ghostty
