return {
	"ThePrimeagen/harpoon",
	branch = "harpoon2",

	dependencies = {
		"nvim-lua/plenary.nvim",
	},

	config = function()
		local harpoon = require("harpoon")

		harpoon:setup()

		-- Add current file
		vim.keymap.set("n", "<leader>ha", function()
			harpoon:list():add()
		end, { desc = "Harpoon Add File" })

        -- remove current file
        vim.keymap.set("n", "<leader>hd", function()
            harpoon:list():remove()
        end, { desc = "Harpoon Remove File" })

		-- Toggle quick menu
		vim.keymap.set("n", "<leader>hh", function()
			harpoon.ui:toggle_quick_menu(harpoon:list())
		end, { desc = "Harpoon Quick Menu" })

		-- Select files
		vim.keymap.set("n", "<A-1>", function()
			harpoon:list():select(1)
		end, { desc = "Harpoon File 1" })

		vim.keymap.set("n", "<A-2>", function()
			harpoon:list():select(2)
		end, { desc = "Harpoon File 2" })

		vim.keymap.set("n", "<A-3>", function()
			harpoon:list():select(3)
		end, { desc = "Harpoon File 3" })

		vim.keymap.set("n", "<A-4>", function()
			harpoon:list():select(4)
		end, { desc = "Harpoon File 4" })

		-- Navigate between harpooned files
		vim.keymap.set("n", "<A-j>", function()
			harpoon:list():prev()
		end, { desc = "Harpoon Previous" })

		vim.keymap.set("n", "<A-k>", function()
			harpoon:list():next()
		end, { desc = "Harpoon Next" })
	end,
}
