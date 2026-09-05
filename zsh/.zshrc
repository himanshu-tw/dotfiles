# ── Shell Vim Mode Configuration ────────────────────
bindkey -v

# ── Environment Variables & Paths ───────────────────
export EDITOR=nvim
export VISUAL=nvim

export PATH="$HOME/.local/bin:$PATH"
export PATH="/home/himanshu-tiwari/.opencode/bin:/home/himanshu-tw/.opencode/bin:/home/himanshu/.opencode/bin:$PATH"

# ── Shell History Config ────────────────────────────
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history

setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS

# ── Modern Tool Initializations ─────────────────────
eval "$(~/.local/bin/mise activate zsh)"
eval "$(zoxide init zsh)"
eval "$(starship init zsh)"

# ── Tool Shell Completions ──────────────────────────
eval "$(uv generate-shell-completion zsh)"
eval "$(uvx --generate-shell-completion zsh)"

# ── Aliases ─────────────────────────────────────────
alias bashconfig="nvim ~/.zshrc"
alias cd='z'
alias grep="rg"
alias v='nvim'
alias py='python3'
alias ta='tmux attach || tmux new-session'

alias ls="eza --icons"
alias ll="eza -lah --icons --git --group-directories-first"
alias lt="eza --tree --level=2"

alias dcu='docker compose up --build'
alias dcd='docker compose down'
alias dcl='docker compose logs -f'

# ── Interactive Custom Functions ────────────────────

gcf() {
  local selected
  selected=$(git branch -a --format='%(refname:short)' | 
             sed 's/origin\///' | 
             sort -u | 
             fzf --height 40% --border --ansi --print-query)

  [ -z "$selected" ] && return 1

  local query
  local branch
  query=$(echo "$selected" | head -n 1)
  branch=$(echo "$selected" | tail -n 1)

  if [ "$query" = "$branch" ] || [ -n "$branch" ]; then
    git checkout "$branch"
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
  local dir
  dir=$(zoxide query -i)
  [ -z "$dir" ] && return 1

  local session_name
  session_name=$(basename "$dir" | tr '.' '_')
  cd "$dir" || return 1

  if ! tmux has-session -t "$session_name" 2>/dev/null; then
    tmux new-session -d -s "$session_name" -c "$dir"
    
    tmux rename-window -t "$session_name:1" 'editor'
    tmux send-keys -t "$session_name:1" "nvim ." C-m

    tmux new-window -t "$session_name" -n 'terminal' -c "$dir"
    tmux send-keys -t "$session_name:2" C-m

    tmux new-window -t "$session_name" -n 'git' -c "$dir"
    tmux send-keys -t "$session_name:3" C-m
  fi

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
  if [ ! -f "package.json" ]; then
    echo "No package.json found in this directory."
    return 1
  fi

  local script
  script=$(node -e "const s = require('./package.json').scripts; if(s) console.log(Object.keys(s).join('\n'))" 2>/dev/null | fzf --height 40% --border)

  [ -z "$script" ] && return 0

  if [ -f "bun.lockb" ] || [ -f "bun.lock" ]; then
    bun run "$script"
  elif [ -f "pnpm-lock.yaml" ]; then
    pnpm run "$script"
  elif [ -f "yarn.lock" ]; then
    yarn run "$script"
  elif [ -f "package-lock.json" ]; then
    npm run "$script"
  else
    if command -v bun &> /dev/null; then
      bun run "$script"
    else
      npm run "$script"
    fi
  fi
}
