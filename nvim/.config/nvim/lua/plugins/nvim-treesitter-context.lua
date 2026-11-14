return {
  "nvim-treesitter/nvim-treesitter-context",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  opts = {
    enable = true,
    max_lines = 3, -- Limits the sticky header to 3 lines so it doesn't crowd your screen
    trim_scope = "outer", -- Discards outer context lines first if max_lines is exceeded
    mode = "cursor", -- Calculates context based on cursor position
    integrations = {
        treesitter = true,
        treesitter_context = true, -- Enables native Catppuccin colors for the sticky header
    },
  },
}
