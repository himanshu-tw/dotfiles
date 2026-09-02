#!/bin/bash

set -e

DOTFILES="$HOME/dotfiles"

echo "==> Starting dotfiles setup..."

# System packages
echo "==> Installing system packages..."
sudo pacman -Syu
sudo pacman -S git curl alacritty eza ripgrep fzf zoxide tmux neovim btop ffmpeg img2pdf fd ttf-jetbrains-mono-nerd docker docker-compose docker-buildx
sudo systemctl enable --now docker.service
sudo usermod -aG docker $USER

# Mise
if ! command -v mise &>/dev/null; then
  echo "==> Installing Mise..."
  curl https://mise.run | sh
else
  echo "==> Mise already installed, skipping."
fi

# Starship
curl -sS https://starship.rs/install.sh | sh


# Symlinks
echo "==> Creating symlinks..."
./symlink-stow.sh

echo "==> GitHub SSH setup"
./git-ssh/github-ssh-setup.sh

echo ""
echo "==> Done! Restart terminal or run: exec zsh"
