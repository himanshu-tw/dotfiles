return {
	"saghen/blink.cmp",

	version = "*",

	event = {
		"InsertEnter",
		"CmdlineEnter",
	},

	dependencies = {
		"rafamadriz/friendly-snippets",
	},

	opts = {
        keymap = {
            preset = "none",

            ["<Tab>"] = { "select_next", "fallback" },
            ["<S-Tab>"] = { "select_prev", "fallback" },

            ["<CR>"] = { "accept", "fallback" },

            ["<C-Space>"] = { "show", "show_documentation", "hide_documentation" },

            ["<Esc>"] = { "hide", "fallback" },
        },

		appearance = {
			nerd_font_variant = "mono",
		},

		completion = {
			documentation = {
				auto_show = true,
				auto_show_delay_ms = 200,
			},

			menu = {
				border = "rounded",
				draw = {
					columns = {
						{ "kind_icon" },
						{ "label", "label_description", gap = 1 },
					},
				},
			},
		},

		signature = {
			enabled = true,
		},

		sources = {
			default = {
				"lsp",
				"path",
				"snippets",
				"buffer",
			},
		},

		fuzzy = {
			implementation = "prefer_rust_with_warning",
		},
	},

	opts_extend = {
		"sources.default",
	},
}
