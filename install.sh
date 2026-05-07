#!/bin/bash

DOTFILES="$HOME/dotfiles"

install_if_missing() {
  if ! command -v $1 &> /dev/null; then
    echo "Installing $1..."
    $2
  else
    echo "$1 already installed, skipping."
  fi
}

# System packages
sudo apt update
sudo apt install -y git curl unzip zsh tmux ripgrep fd-find fzf bat eza

# Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
  echo "oh-my-zsh already installed, skipping."
fi

# Plugins
[ ! -d "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" ] && \
  git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

[ ! -d "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" ] && \
  git clone https://github.com/zsh-users/zsh-syntax-highlighting ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# Starship
install_if_missing starship "curl -sS https://starship.rs/install.sh | sh"

# Mise
install_if_missing mise "curl https://mise.run | sh"

# Atuin
install_if_missing atuin "curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh"

# Zoxide
install_if_missing zoxide "curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh"

# Alacritty
install_if_missing alacritty "sudo apt install -y alacritty"

# Neovim
install_if_missing nvim "sudo apt install -y neovim"

# Symlinks
mkdir -p ~/.config/alacritty
ln -sf $DOTFILES/alacritty/alacritty.toml ~/.config/alacritty/alacritty.toml
ln -sf $DOTFILES/zsh/.zshrc ~/.zshrc
ln -sf $DOTFILES/starship/starship.toml ~/.config/starship.toml
ln -sf $DOTFILES/tmux/.tmux.conf ~/.tmux.conf
ln -sf $DOTFILES/nvim ~/.config/nvim

# git ssh key setup
#./git-ssh/github-ssh-setup.sh

echo "Done."
