return {
	"folke/which-key.nvim",
	event = "VeryLazy",

	opts = {
		preset = "helix",
		delay = 0,

		plugins = {
			marks = true,
			registers = true,
			spelling = {
				enabled = true,
				suggestions = 20,
			},
		},

		icons = {
			breadcrumb = "»",
			separator = "➜",
			group = "+",
		},

		show_help = true,
		show_keys = true,

		sort = { "local", "order", "group", "alphanum", "mod" },

		spec = {},
	},

	config = function(_, opts)
		local wk = require("which-key")

		wk.setup(opts)

		wk.add({
			{ "<leader>f", group = "Find" },
			{ "<leader>g", group = "Git" },
			{ "<leader>b", group = "Buffers" },
			{ "<leader>c", group = "Code" },
			{ "<leader>t", group = "Toggle" },
			{ "<leader>w", group = "Window" },
			{ "<leader>q", group = "Quit" },
		})
	end,
}
