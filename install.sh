#!/bin/bash

DOTFILES="$HOME/dotfiles"

ln -sf $DOTFILES/alacritty/alacritty.toml ~/.config/alacritty/alacritty.toml
ln -sf $DOTFILES/zsh/.zshrc ~/.zshrc
ln -sf $DOTFILES/starship/starship.toml ~/.config/starship/starship.toml

./git-ssh/github-ssh-setup.sh

echo "Done."
