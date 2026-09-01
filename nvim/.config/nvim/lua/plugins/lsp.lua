return {
	"neovim/nvim-lspconfig",

	event = {
		"BufReadPre",
		"BufNewFile",
	},
	config = function()
        local capabilities = require("blink.cmp").get_lsp_capabilities()
		--------------------------------------------------
		-- Lua
		--------------------------------------------------
		vim.lsp.config("lua_ls", {
            capabilities = capabilities,

			settings = {
				Lua = {
					diagnostics = {
						globals = { "vim" },
					},
				},
			},
		})

		--------------------------------------------------
		-- Enable Servers
		--------------------------------------------------
		vim.lsp.enable("lua_ls")
		vim.lsp.enable("gopls")
		vim.lsp.enable("ts_ls")

		--------------------------------------------------
		-- Diagnostics
		--------------------------------------------------
		vim.diagnostic.config({
			virtual_text = true,
			signs = true,
			underline = true,
			update_in_insert = false,
			severity_sort = true,

			float = {
				border = "rounded",
				source = "if_many",
			},
		})
	end,
}
