return {
	-- [[ colorscheme ]]
	{
		"rose-pine/neovim",
		name = "rose-pine",
		priority = 1000,
		config = function()
			vim.cmd.colorscheme("rose-pine")
		end,
	},

	-- [[ oil ]]
	{
		"stevearc/oil.nvim",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			require("oil").setup()
			vim.keymap.set("n", "-", "<cmd>Oil<cr>", { desc = "Open parent directory" })
		end,
	},

	-- [[ harpoon ]]
	{
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		dependencies = {
			"nvim-lua/plenary.nvim"
		},
		config = function()
			local harpoon = require("harpoon")
			harpoon:setup({})
			vim.keymap.set("n", "<C-g>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end,
				{ desc = "List" })
			vim.keymap.set("n", "<leader>hl", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end,
				{ desc = "List" })
			vim.keymap.set("n", "<leader>ha", function() harpoon:list():append() end, { desc = "Append" })
			vim.keymap.set("n", "<leader>hp", function() harpoon:list():prepend() end, { desc = "Prepend" })

			vim.keymap.set("n", "<C-j>", function() harpoon:list():select(1) end,
				{ desc = "Harpoon to file 1" })
			vim.keymap.set("n", "<C-k>", function() harpoon:list():select(2) end,
				{ desc = "Harpoon to file 2" })
			vim.keymap.set("n", "<C-l>", function() harpoon:list():select(3) end,
				{ desc = "Harpoon to file 3" })
			vim.keymap.set("n", "<C-;>", function() harpoon:list():select(4) end,
				{ desc = "Harpoon to file 4" })
		end
	},

	-- [[ which-key ]]
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {
			defaults = {
				["g"] = { name = "+Goto" },
				["<leader>f"] = { name = "+Find" },
				["<leader>s"] = { name = "+Search" },
				["<leader>h"] = { name = "+Harpoon" },
				["<leader>c"] = { name = "+Code" },
				["<leader>x"] = { name = "+Diagnostics/Quickfix" },
			},
		},
		config = function(_, opts)
			local wk = require("which-key")
			wk.setup(opts)
			wk.register(opts.defaults)
		end,
	},
}
