#!/bin/bash

set -e

DOTFILES="$HOME/dotfiles"

echo "==> Starting dotfiles setup..."

# System packages
echo "==> Installing system packages..."
sudo pacman -Syu
sudo pacman -S git curl alacritty zsh eza ripgrep fzf zoxide tmux neovim btop ffmpeg img2pdf fd ttf-jetbrains-mono-nerd docker docker-compose docker-buildx
sudo systemctl enable --now docker.service
sudo usermod -aG docker $USER

# Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "==> Installing Oh My Zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
  echo "==> Oh My Zsh already installed, skipping."
fi

# Zsh plugins
echo "==> Installing Zsh plugins..."
[ ! -d "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" ] &&
  git clone -q https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

[ ! -d "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" ] &&
  git clone -q https://github.com/zsh-users/zsh-syntax-highlighting ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# Mise
if ! command -v mise &>/dev/null; then
  echo "==> Installing Mise..."
  curl https://mise.run | sh
else
  echo "==> Mise already installed, skipping."
fi

# Default shell to zsh
if [ "$SHELL" != "$(which zsh)" ]; then
  echo "==> Changing default shell to zsh..."
  chsh -s $(which zsh)
fi

# Symlinks
echo "==> Creating symlinks..."
./symlink-stow.sh

echo "==> GitHub SSH setup"
./git-ssh/github-ssh-setup.sh

echo ""
echo "==> Done! Restart terminal or run: exec zsh"
