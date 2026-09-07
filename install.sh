#!/bin/bash
set -e
DOTFILES="$HOME/dotfiles"
echo "==> Starting dotfiles setup..."

### 1. Detect distro
if [ -f /etc/os-release ]; then
  . /etc/os-release
  case "$ID" in
    arch|endeavouros|manjaro) DISTRO="arch" ;;
    fedora) DISTRO="fedora" ;;
    debian|ubuntu|pop) DISTRO="debian" ;;
    *)
      case "$ID_LIKE" in
        *arch*) DISTRO="arch" ;;
        *fedora*|*rhel*) DISTRO="fedora" ;;
        *debian*) DISTRO="debian" ;;
        *) echo "Unsupported distro: $ID"; exit 1 ;;
      esac
      ;;
  esac
else
  echo "Cannot detect distro (/etc/os-release missing)"; exit 1
fi
echo "==> Detected: $DISTRO"

### 2. Package manager wrapper
pkg_update() {
  case "$DISTRO" in
    arch)   sudo pacman -Syu --noconfirm ;;
    fedora) sudo dnf upgrade --refresh -y ;;
    debian) sudo apt update && sudo apt upgrade -y ;;
  esac
}
pkg_install() {
  case "$DISTRO" in
    arch)   sudo pacman -S --needed --noconfirm "$@" ;;
    fedora) sudo dnf install -y "$@" ;;
    debian) sudo apt install -y "$@" ;;
  esac
}

### 3. Base build deps
case "$DISTRO" in
  arch)   pkg_install base-devel git reflector; sudo reflector --latest 20 --sort rate --save /etc/pacman.d/mirrorlist ;;
  fedora) pkg_install @development-tools git ;;
  debian) pkg_install build-essential git curl ;;
esac

pkg_update

### 4. Common CLI tools (name differs per distro)
case "$DISTRO" in
  arch)   FD=fd;      BAT=bat ;;
  fedora) FD=fd-find; BAT=bat ;;
  debian) FD=fd-find; BAT=bat ;;
esac
pkg_install ripgrep fzf tmux neovim btop ffmpeg img2pdf unzip wget zsh "$FD" "$BAT"

# Debian renames binaries: fdfind -> fd, batcat -> bat
if [ "$DISTRO" = "debian" ]; then
  mkdir -p "$HOME/.local/bin"
  ln -sf "$(command -v fdfind)" "$HOME/.local/bin/fd"
  ln -sf "$(command -v batcat)" "$HOME/.local/bin/bat"
fi

### 5. zoxide (official cross-distro installer, no need to fight package names)
if ! command -v zoxide &>/dev/null; then
  curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
fi

### 6. eza (packaged on Arch/Fedora, not reliably on Debian stable -> binary fallback)
if ! command -v eza &>/dev/null; then
  case "$DISTRO" in
    arch|fedora) pkg_install eza || true ;;
  esac
  if ! command -v eza &>/dev/null; then
    echo "==> Installing eza from GitHub release..."
    EZA_URL=$(curl -s https://api.github.com/repos/eza-community/eza/releases/latest \
      | grep browser_download_url | grep linux-gnu.tar.gz | grep -v musl | cut -d '"' -f4)
    curl -sSL "$EZA_URL" -o /tmp/eza.tar.gz
    tar -xzf /tmp/eza.tar.gz -C /tmp
    sudo mv /tmp/eza "$(command -v eza 2>/dev/null || echo /usr/local/bin/eza)"
    rm -f /tmp/eza.tar.gz
  fi
fi

### 7. Nerd Font (direct download, identical on every distro)
if [ ! -d "$HOME/.local/share/fonts/JetBrainsMono" ]; then
  mkdir -p "$HOME/.local/share/fonts/JetBrainsMono"
  curl -sSL https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip -o /tmp/jbm.zip
  unzip -oq /tmp/jbm.zip -d "$HOME/.local/share/fonts/JetBrainsMono/"
  rm -f /tmp/jbm.zip
  fc-cache -f
fi

### 8. Docker (official convenience script, distro-agnostic)
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
