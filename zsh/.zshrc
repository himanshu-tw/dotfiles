# ── Oh My Zsh ───────────────────────────────────────
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"

plugins=(
  git
  docker
  docker-compose
  node
  python
  zsh-autosuggestions
  zsh-syntax-highlighting
  vi-mode
)

source $ZSH/oh-my-zsh.sh

# ── History ─────────────────────────────────────────
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_IGNORE_DUPS HIST_IGNORE_SPACE SHARE_HISTORY

# ── mise ────────────────────────────────────────────
eval "$(~/.local/bin/mise activate zsh)"

# ── zoxide ──────────────────────────────────────────
eval "$(zoxide init zsh)"

# ── Editor ──────────────────────────────────────────
export EDITOR=nvim
export VISUAL=nvim

alias zshconfig="nvim ~/.zshrc"
alias ohmyzsh="nvim ~/.oh-my-zsh"

# ── ls aliases ──────────────────────────────────────
alias ls="eza --icons"
alias ll="eza -lah --icons --git --group-directories-first"
alias lt="eza --tree --level=2"
alias cd='z'
alias cat='batcat'

# ── git aliases (OMZ git plugin ke upar extra) ──────
alias gl='git log --oneline --graph --decorate -10'
alias gcb='git checkout -b'

# ── docker aliases ──────────────────────────────────
alias dcu='docker compose up -d'
alias dcd='docker compose down'
alias dcl='docker compose logs -f'

# ── dev shortcuts ───────────────────────────────────
alias v='nvim'
alias py='python3'
alias ta='tmux attach || tmux new-session'
alias lg="lazygit"

alias grep="rg"


# Added by LM Studio CLI (lms)
export PATH="$PATH:/home/himanshu-tiwari/.lmstudio/bin"
# End of LM Studio CLI section

# bun completions
[ -s "/home/himanshu-tiwari/.bun/_bun" ] && source "/home/himanshu-tiwari/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
export PATH=$PATH:$HOME/.local/bin

# opencode
export PATH=/home/himanshu-tiwari/.opencode/bin:$PATH

# nub
export PATH="$HOME/.nub/bin:$PATH"
