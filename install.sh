#!/bin/bash

set -e

DOTFILES="$HOME/dotfiles"

echo "==> Starting dotfiles setup..."

# System packages
echo "==> Installing system packages..."
sudo apt update && sudo apt upgrade -y

sudo apt install curl alacritty eza ripgrep fzf zoxide tmux neovim btop ffmpeg python-img2pdf fd-find unzip -y

sudo apt remove $(dpkg --get-selections docker.io docker-compose docker-compose-v2 docker-doc docker-buildx podman-docker containerd runc | cut -f1)

curl -fsSL https://get.docker.com | sh
sudo systemctl enable --now docker.service
sudo usermod -aG docker $USER

# JetBrains Mono Nerd Font
mkdir -p ~/.local/share/fonts
wget https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip
unzip JetBrainsMono.zip -d ~/.local/share/fonts/JetBrainsMono/
rm JetBrainsMono.zip

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
