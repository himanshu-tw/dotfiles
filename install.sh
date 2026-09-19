#!/bin/bash
set -e
DOTFILES="$HOME/dotfiles"
echo "==> Starting dotfiles setup..."

### 1. Base setup
sudo apt update && sudo apt upgrade -y
sudo apt install unzip build-essential -y

### 2. Common CLI tools
sudo apt install -y ripgrep fzf tmux neovim btop ffmpeg img2pdf unzip wget zsh fd-find bat eza zoxide ghostty stow sway swaybg wofi waybar

### 3. Nerd Font
FONT_DIR="$HOME/.local/share/fonts"
mkdir -p "$FONT_DIR"
FONT_URL="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip"
TMP_FONT_DIR="$(mktemp -d)"

wget -q --show-progress \
  "$FONT_URL" \
  -O "$TMP_FONT_DIR/JetBrainsMono.zip"

unzip -qo \
  "$TMP_FONT_DIR/JetBrainsMono.zip" \
  -d "$FONT_DIR"

rm -rf "$TMP_FONT_DIR"
fc-cache -f

### 4. Docker
if ! command -v docker &>/dev/null; then
  echo "==> Installing Docker..."
  curl -fsSL https://get.docker.com | sh
  sudo systemctl enable --now docker.service
  sudo usermod -aG docker "$USER"
else
    echo "==> Docker already installed. Skipping docker"
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
echo "==> Done! Restart terminal or run exec zsh"
