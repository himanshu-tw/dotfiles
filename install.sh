#!/bin/bash
set -e
DOTFILES="$HOME/dotfiles"
echo "==> Starting dotfiles setup..."

sudo pacman -S --needed --noconfirm base-devel git reflector

# Refresh mirrorlist
sudo reflector --latest 20 --sort rate --save /etc/pacman.d/mirrorlist

# yay (AUR helper) - needed for ghostty, nerd fonts, etc.
if ! command -v yay &>/dev/null; then
  echo "==> Installing yay..."
  git clone https://aur.archlinux.org/yay.git /tmp/yay
  (cd /tmp/yay && makepkg -si --noconfirm)
  rm -rf /tmp/yay
fi

# System packages
echo "==> Installing system packages..."
sudo pacman -Syu --noconfirm
sudo pacman -S --needed --noconfirm \
  eza ripgrep fzf zoxide tmux neovim btop ffmpeg img2pdf fd unzip \
  hyprland hyprpaper waybar rofi-wayland swaync xdg-desktop-portal-hyprland \
  zsh git wget lazygit bat

yay -S --needed --noconfirm ghostty wofi ttf-jetbrains-mono-nerd

# Docker
if ! command -v docker &>/dev/null; then
  echo "==> Installing Docker..."
  sudo pacman -S --needed --noconfirm docker docker-compose
  sudo systemctl enable --now docker.service
  sudo usermod -aG docker "$USER"
fi

# ohmyzsh install
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "==> Installing oh-my-zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# Mise
if ! command -v mise &>/dev/null; then
  echo "==> Installing Mise..."
  curl https://mise.run | sh
else
  echo "==> Mise already installed, skipping."
fi

# oh-my-zsh writes a real .zshrc - move it out of the way so stow doesn't choke on it
[ -f "$HOME/.zshrc" ] && [ ! -L "$HOME/.zshrc" ] && mv "$HOME/.zshrc" "$HOME/.zshrc.bak"

# Symlinks
echo "==> Creating symlinks..."
"$DOTFILES/symlink-stow.sh"

echo "==> GitHub SSH setup"
"$DOTFILES/git-ssh/github-ssh-setup.sh"

# Default shell to zsh
if [ "$SHELL" != "$(which zsh)" ]; then
  chsh -s "$(which zsh)"
fi

echo ""
echo "==> Done! Restart terminal or run: exec zsh"
