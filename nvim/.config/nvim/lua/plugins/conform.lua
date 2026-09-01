return {
	"stevearc/conform.nvim",

	event = {
		"BufWritePre",
	},

	cmd = {
		"ConformInfo",
	},

	opts = {
		formatters_by_ft = {
			lua = { "stylua" },

			go = {
				"gofmt",
			},

			javascript = {
				"prettier",
			},

			typescript = {
				"prettier",
			},

			javascriptreact = {
				"prettier",
			},

			typescriptreact = {
				"prettier",
			},

			json = {
				"prettier",
			},

			html = {
				"prettier",
			},

			css = {
				"prettier",
			},

			markdown = {
				"prettier",
			},
		},

		format_on_save = {
			timeout_ms = 500,
			lsp_format = "fallback",
		},
	},
}
