#!/bin/bash
set -e
DOTFILES="$HOME/dotfiles"
echo "==> Starting dotfiles setup..."

### 1. Base setup
sudo pacman -S --needed --noconfirm base-devel git reflector
sudo reflector --latest 20 --sort rate --save /etc/pacman.d/mirrorlist
sudo pacman -Syu --noconfirm

### yay AUR setup
./yay-setup.sh

### 2. Common CLI tools
sudo pacman -S --needed --noconfirm ripgrep fzf tmux neovim btop ffmpeg img2pdf unzip wget zsh fd bat eza zoxide ghostty

### 3. Nerd Font (via AUR)
yay -S --needed --noconfirm ttf-jetbrains-mono-nerd

### 4. Docker
if ! command -v docker &>/dev/null; then
  echo "==> Installing Docker..."
  curl -fsSL https://get.docker.com | sh
  sudo systemctl enable --now docker.service
  sudo usermod -aG docker "$USER"
fi

### 9. oh-my-zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

### 10. Mise
if ! command -v mise &>/dev/null; then
  curl https://mise.run | sh
fi

# oh-my-zsh writes a real .zshrc - move it out of the way so stow doesn't choke on it
[ -f "$HOME/.zshrc" ] && [ ! -L "$HOME/.zshrc" ] && mv "$HOME/.zshrc" "$HOME/.zshrc.bak"

### 11. Symlinks
echo "==> Creating symlinks..."
"$DOTFILES/symlink-stow.sh"

echo "==> GitHub SSH setup"
"$DOTFILES/git-ssh/github-ssh-setup.sh"

### 12. Default shell
if [ "$SHELL" != "$(command -v zsh)" ]; then
  chsh -s "$(command -v zsh)"
fi

echo ""
echo "==> Done! Restart terminal or run: exec zsh"
