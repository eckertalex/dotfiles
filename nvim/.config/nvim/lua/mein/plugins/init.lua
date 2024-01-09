return {
	-- Detect tabstop and shiftwidth automatically
	'tpope/vim-sleuth',

	-- comments
	{
		'numToStr/Comment.nvim',
		config = function()
			require('Comment').setup()
		end
	},

	-- [[ colorscheme ]]
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		config = function()
			require('catppuccin').setup({
				transparent_background = true,
				integrations = {
					cmp = true,
					fidget = true,
					gitsigns = true,
					harpoon = true,
					treesitter = true,
					telescope = {
						enabled = true,
					},
					mason = true,
					which_key = true,
					native_lsp = {
						enabled = true,
						virtual_text = {
							errors = { "italic" },
							hints = { "italic" },
							warnings = { "italic" },
							information = { "italic" },
						},
						underlines = {
							errors = { "undercurl" },
							hints = { "undercurl" },
							warnings = { "undercurl" },
							information = { "undercurl" },
						},
						inlay_hints = {
							background = true,
						},
					},
				},
			})

			vim.cmd.colorscheme("catppuccin-macchiato")
		end
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
		opts = {
			window = {
				border = "rounded",
			},
			plugins = { spelling = true },
			defaults = {
				mode = { "n", "v" },
				["g"] = { name = "+goto" },
				["]"] = { name = "+next" },
				["["] = { name = "+prev" },
				["<leader>c"] = { name = "+code" },
				["<leader>f"] = { name = "+find" },
				["<leader>g"] = { name = "+git" },
				["<leader>gh"] = { name = "+hunk" },
				["<leader>h"] = { name = "+harpoon" },
				["<leader>s"] = { name = "+search" },
				["<leader>t"] = { name = "+tabs" },
				["<leader>u"] = { name = "+ui" },
				["<leader>w"] = { name = "+window" },
				["<leader>x"] = { name = "+diagnostics/quickfix" },
			},
		},
		config = function(_, opts)
			local wk = require("which-key")
			wk.setup(opts)
			wk.register(opts.defaults)
		end,
	},
}
