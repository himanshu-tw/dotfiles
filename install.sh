#!/bin/bash

set -e

DOTFILES="$HOME/dotfiles"

echo "==> Starting dotfiles setup..."

# System packages
echo "==> Installing system packages..."
yay -Syu
yay -S git curl unzip zsh tmux ripgrep fd-find fzf bat eza neovim alacritty

# Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "==> Installing Oh My Zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
  echo "==> Oh My Zsh already installed, skipping."
fi

# Zsh plugins
echo "==> Installing Zsh plugins..."
[ ! -d "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" ] && \
  git clone -q https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

[ ! -d "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" ] && \
  git clone -q https://github.com/zsh-users/zsh-syntax-highlighting ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# Starship
if ! command -v starship &> /dev/null; then
  echo "==> Installing Starship..."
  curl -sS https://starship.rs/install.sh | sh -s -- -y
else
  echo "==> Starship already installed, skipping."
fi

# Mise
if ! command -v mise &> /dev/null; then
  echo "==> Installing Mise..."
  curl https://mise.run | sh
else
  echo "==> Mise already installed, skipping."
fi

# Atuin
if ! command -v atuin &> /dev/null; then
  echo "==> Installing Atuin..."
  curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh
else
  echo "==> Atuin already installed, skipping."
fi

# Zoxide
if ! command -v zoxide &> /dev/null; then
  echo "==> Installing Zoxide..."
  curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
else
  echo "==> Zoxide already installed, skipping."
fi

# Nerd Font
if ! fc-list | grep -qi "JetBrainsMono Nerd Font"; then
  echo "==> Installing JetBrainsMono Nerd Font..."
  wget -q https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip -O /tmp/JetBrainsMono.zip
  mkdir -p ~/.local/share/fonts/JetBrainsMono
  unzip -q /tmp/JetBrainsMono.zip -d ~/.local/share/fonts/JetBrainsMono
  fc-cache -fv > /dev/null
  rm /tmp/JetBrainsMono.zip
else
  echo "==> JetBrainsMono Nerd Font already installed, skipping."
fi

# Tmux Plugin Manager
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
  echo "==> Installing TPM..."
  git clone -q https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
else
  echo "==> TPM already installed, skipping."
fi

# Default shell to zsh
if [ "$SHELL" != "$(which zsh)" ]; then
  echo "==> Changing default shell to zsh..."
  chsh -s $(which zsh)
fi

# Symlinks
echo "==> Creating symlinks..."
mkdir -p ~/.config/alacritty

# Remove existing to avoid nesting issue
rm -rf ~/.config/nvim
rm -f ~/.config/alacritty/alacritty.toml
rm -f ~/.zshrc
rm -f ~/.config/starship.toml
rm -f ~/.tmux.conf

ln -sf $DOTFILES/alacritty/alacritty.toml ~/.config/alacritty/alacritty.toml
ln -sf $DOTFILES/zsh/.zshrc ~/.zshrc
ln -sf $DOTFILES/starship/starship.toml ~/.config/starship.toml
ln -sf $DOTFILES/tmux/.tmux.conf ~/.tmux.conf
ln -sf $DOTFILES/nvim ~/.config/nvim


echo "==> GitHub SSH setup"
./git-ssh/github-ssh-setup.sh

echo ""
echo "==> Done! Restart terminal or run: exec zsh"
