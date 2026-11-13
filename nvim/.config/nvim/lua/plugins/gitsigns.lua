return {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    -- 1. Unstaged alterations (Visible in the gutter by default)
    signs = {
      add          = { text = "┃" },
      change       = { text = "┃" },
      delete       = { text = "_" },
      topdelete    = { text = "‾" },
      changedelete = { text = "~" },
      untracked    = { text = "┆" },
    },
    
    -- 2. Staged changes (What you have 'git add'ed but not committed)
    signs_staged = {
      add          = { text = "┃" },
      change       = { text = "┃" },
      delete       = { text = "_" },
      topdelete    = { text = "‾" },
      changedelete = { text = "~" },
    },

    -- 3. Explicitly toggle staged tracking
    signs_staged_enable = true,
  },
}
