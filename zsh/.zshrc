# ── Oh My Zsh ───────────────────────────────────────
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"

plugins=(
  zsh-autosuggestions
  zsh-syntax-highlighting
  vi-mode
)

# Force Oh My Zsh vi-mode to use solid blocks for all modes
VI_MODE_CURSOR_NORMAL=2
VI_MODE_CURSOR_INSERT=2
VI_MODE_CURSOR_VISUAL=2
VI_MODE_CURSOR_OPPEND=2

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

# ── docker aliases ──────────────────────────────────
alias dcu='docker compose up --build'
alias dcd='docker compose down'
alias dcl='docker compose logs -f'

# ── dev shortcuts ───────────────────────────────────
alias v='nvim'
alias py='python3'
alias ta='tmux attach || tmux new-session'

alias grep="rg"


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

# opencode
export PATH=/home/himanshu-tw/.opencode/bin:$PATH
eval "$(uv generate-shell-completion zsh)"
eval "$(uvx --generate-shell-completion zsh)"


gcf() {
  # 1. Get all local and remote branches, clean up formatting
  # Using --print-query lets fzf output what you typed even if there are no matches
  local selected
  selected=$(git branch -a --format='%(refname:short)' | 
             sed 's/origin\///' | 
             sort -u | 
             fzf --height 40% --border --ansi --print-query)

  # Exit if the user hit Escape or Ctrl+C
  [ -z "$selected" ] && return 1

  # fzf --print-query outputs two lines:
  # Line 1: What you typed into the search bar
  # Line 2: The match you selected (if any)
  local query=$(echo "$selected" | head -n 1)
  local branch=$(echo "$selected" | tail -n 1)

  # Case A: You selected an existing branch from the list
  if [ "$query" = "$branch" ] || [ -n "$branch" ]; then
    git checkout "$branch"
  
  # Case B: You typed something that didn't match any existing branch
  else
    echo -n "Branch '$query' doesn't exist. Create it? (y/N): "
    read -r response
    if [[ "$response" =~ ^[Yy]$ ]]; then
      git checkout -b "$query"
    else
      echo "Aborted."
    fi
  fi
}

tm() {
  # 1. Use zoxide to interactively pick the folder path
  # We use 'zoxide query -i' directly to get the absolute path string
  local dir
  dir=$(zoxide query -i)
  
  # Exit cleanly if you hit Escape or didn't select anything
  [ -z "$dir" ] && return 1

  # 2. Extract just the folder name to use as a clean tmux session name
  local session_name
  session_name=$(basename "$dir" | tr '.' '_')
  cd $session_name

  # 3. If the tmux session doesn't exist yet, build it in the background
  if ! tmux has-session -t "$session_name" 2>/dev/null; then
    # Create the session detached (-d) and force the start directory (-c)
    tmux new-session -d -s "$session_name" -c "$dir"
    
    # Window 1: Name it 'editor', then send the nvim command + Enter (C-m)
    tmux rename-window -t "$session_name:1" 'editor'
    tmux send-keys -t "$session_name:1" "nvim ." C-m

    # Window 2: Create 'terminal' window and ensure it starts in the project root
    tmux new-window -t "$session_name" -n 'terminal' -c "$dir"
    tmux send-keys -t "$session_name:2" C-m

    # Window 3: Create 'git' window and ensure it starts in the project root
    tmux new-window -t "$session_name" -n 'git' -c "$dir"
    tmux send-keys -t "$session_name:3" C-m
  fi

  # 4. Attach to the session (or switch to it if you are already inside tmux)
  if [ -n "$TMUX" ]; then
    tmux switch-client -t "$session_name"
  else
    tmux attach-session -t "$session_name"
  fi
}


gl() {
  git log --graph --color=always \
      --format="%C(auto)%h%d %s %C(black)%C(bold)%cr" "$@" | \
  fzf --ansi --no-sort --reverse --tiebreak=index --bind=ctrl-x:toggle-sort \
      --preview 'git show --color=always {+2}' \
      --header "Press CTRL-X to toggle sort" \
      --height=80% --border
}


nr() {
  # 1. Check if package.json exists in the current project
  if [ ! -f "package.json" ]; then
    echo "No package.json found in this directory."
    return 1
  fi

  # 2. Parse the script keys cleanly using Node
  local script
  script=$(node -e "const s = require('./package.json').scripts; if(s) console.log(Object.keys(s).join('\n'))" 2>/dev/null | fzf --height 40% --border)

  # Exit cleanly if nothing was selected
  [ -z "$script" ] && return 0

  # 3. Detect lockfile to choose the right package manager
  if [ -f "bun.lockb" ] || [ -f "bun.lock" ]; then
    bun run "$script"
  elif [ -f "pnpm-lock.yaml" ]; then
    pnpm run "$script"
  elif [ -f "yarn.lock" ]; then
    yarn run "$script"
  elif [ -f "package-lock.json" ]; then
    npm run "$script"
  else
    # 4. Fallback logic: If no lockfile exists, check if bun is installed on the system
    if command -v bun &> /dev/null; then
      bun run "$script"
    else
      npm run "$script"
    fi
  fi
}

# opencode
export PATH=/home/himanshu/.opencode/bin:$PATH
export PATH="$HOME/.config/emacs/bin:$PATH"
