return {
	"nvim-treesitter/nvim-treesitter",

	build = ":TSUpdate",

	event = {
		"BufReadPost",
		"BufNewFile",
	},

	opts = {
		ensure_installed = {
			"lua",
			"go",
			"gomod",
			"gosum",
			"gowork",
			"javascript",
			"typescript",
			"tsx",
			"json",
			"html",
			"css",
			"markdown",
			"markdown_inline",
			"dockerfile",
			"gitignore",
		},

		auto_install = true,

		highlight = {
			enable = true,
		},

		indent = {
			enable = true,
		},
	},
}
