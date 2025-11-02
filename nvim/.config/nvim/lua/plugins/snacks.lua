---@module 'snacks'

return {
	{
		"folke/snacks.nvim",
		event = { "VeryLazy" },
		lazy = false,
		priority = 1000,
		---@type snacks.Config
		opts = {
			bigfile = {},
			bufdelete = {},
			indent = {},
			input = {},
			notifier = {},
			picker = {
				formatters = {
					file = {
						filename_first = true,
					},
				},
				win = {
					input = {
						keys = {
							["<c-h>"] = { "toggle_hidden", mode = { "i", "n" } },
							["<c-t>"] = { "toggle_preview", mode = { "i", "n" } },
							["<c-w>"] = { "cycle_win", mode = { "i", "n" } },
						},
					},
				},
				jump = {
					reuse_win = false,
				},
			},
			quickfile = {},
			image = {},
			statuscolumn = {},
			toggle = {},
			zen = {
				toggles = {
					dim = false,
					git_signs = false,
				},
				show = {
					statusline = true,
				},
			},
		},
		-- stylua: ignore
		keys = {
            -- bufdelete
			{ "<leader>bd", function() Snacks.bufdelete() end, desc = "Delete" },
			{ "<leader>bD", function() Snacks.bufdelete({ force = true }) end, desc = "Delete!" },
			{ "<leader>ba", function() Snacks.bufdelete.all() end, desc = "Delete all buffers" },
			{ "<leader>bo", function() Snacks.bufdelete.other() end, desc = "Delete other buffers" },

			{ "<leader><leader>", function() Snacks.picker.smart() end, desc = "Smart Find Files" },
			{ "<leader>,", function() Snacks.picker.buffers() end, desc = "Buffers" },
			{ "<leader>/", function() Snacks.picker.grep() end, desc = "Grep" },
			-- find
			{ "<leader>fc", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "Find Config File" },
			{ "<leader>ff", function() Snacks.picker.files() end, desc = "Find Files" },
			{ "<leader>fg", function() Snacks.picker.git_files() end, desc = "Find Git Files" },
			{ "<leader>fr", function() Snacks.picker.recent() end, desc = "Recent" },
			-- git
			{ "<leader>gc", function() Snacks.picker.git_branches() end, desc = "Git Branches" },
			{ "<leader>gl", function() Snacks.picker.git_log() end, desc = "Git Log" },
			{ "<leader>gL", function() Snacks.picker.git_log_line() end, desc = "Git Log Line" },
			{ "<leader>gs", function() Snacks.picker.git_status() end, desc = "Git Status" },
			{ "<leader>gS", function() Snacks.picker.git_stash() end, desc = "Git Stash" },
			{ "<leader>gd", function() Snacks.picker.git_diff() end, desc = "Git Diff (Hunks)" },
			{ "<leader>gf", function() Snacks.picker.git_log_file() end, desc = "Git Log File" },
			-- grep
			{ "<leader>sb", function() Snacks.picker.lines() end, desc = "Buffer Lines" },
			{ "<leader>sB", function() Snacks.picker.grep_buffers() end, desc = "Grep Open Buffers" },
			{ "<leader>sg", function() Snacks.picker.grep() end, desc = "Grep" },
			{ "<leader>sw", function() Snacks.picker.grep_word() end, desc = "Visual selection or word", mode = { "n", "x" } },
			-- search
			{ "<leader>sn", function() Snacks.picker.notifications() end, desc = "Notification History" },
			{ '<leader>s"', function() Snacks.picker.registers() end, desc = "Registers" },
			{ "<leader>s/", function() Snacks.picker.search_history() end, desc = "Search History" },
			{ "<leader>sc", function() Snacks.picker.command_history() end, desc = "Command History" },
			{ "<leader>sC", function() Snacks.picker.commands() end, desc = "Commands" },
			{ "<leader>sd", function() Snacks.picker.diagnostics() end, desc = "Diagnostics" },
			{ "<leader>sD", function() Snacks.picker.diagnostics_buffer() end, desc = "Buffer Diagnostics" },
			{ "<leader>sh", function() Snacks.picker.help() end, desc = "Search help" },
			{ "<leader>sl", function() Snacks.picker.loclist() end, desc = "Location List" },
			{ "<leader>sp", function() Snacks.picker.lazy() end, desc = "Search for Plugin Spec" },
			{ "<leader>sq", function() Snacks.picker.qflist() end, desc = "Quickfix List" },
			{ "<leader>sr", function() Snacks.picker.resume() end, desc = "Resume" },
			{ "<leader>su", function() Snacks.picker.undo() end, desc = "Undo History" },
			{ "<leader>sm", function() Snacks.picker.marks() end, desc = "Marks" },
            -- zen
			{ "<leader>z", function() Snacks.zen() end, desc = "Zen Mode" },
		},
		config = function(_, opts)
			require("snacks").setup(opts)

			vim.api.nvim_create_autocmd("User", {
				pattern = "VeryLazy",
				callback = function()
					Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>ts")
					Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>tw")
					Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>tL")
					Snacks.toggle.diagnostics():map("<leader>td")
					Snacks.toggle.line_number():map("<leader>tl")
					Snacks.toggle
						.option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 })
						:map("<leader>tc")
					Snacks.toggle.treesitter():map("<leader>tT")
					Snacks.toggle.inlay_hints():map("<leader>th")
					Snacks.toggle.indent():map("<leader>tg")
				end,
			})

			---@type table<number, {token:lsp.ProgressToken, msg:string, done:boolean}[]>
			local progress = vim.defaulttable()
			vim.api.nvim_create_autocmd("LspProgress", {
				---@param ev {data: {client_id: integer, params: lsp.ProgressParams}}
				callback = function(ev)
					local client = vim.lsp.get_client_by_id(ev.data.client_id)
					local value = ev.data.params.value --[[@as {percentage?: number, title?: string, message?: string, kind: "begin" | "report" | "end"}]]
					if not client or type(value) ~= "table" then
						return
					end
					local p = progress[client.id]

					for i = 1, #p + 1 do
						if i == #p + 1 or p[i].token == ev.data.params.token then
							p[i] = {
								token = ev.data.params.token,
								msg = ("[%3d%%] %s%s"):format(
									value.kind == "end" and 100 or value.percentage or 100,
									value.title or "",
									value.message and (" **%s**"):format(value.message) or ""
								),
								done = value.kind == "end",
							}
							break
						end
					end

					local msg = {} ---@type string[]
					progress[client.id] = vim.tbl_filter(function(v)
						return table.insert(msg, v.msg) or not v.done
					end, p)

					local spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
					vim.notify(table.concat(msg, "\n"), "info", {
						id = "lsp_progress",
						title = client.name,
						opts = function(notif)
							notif.icon = #progress[client.id] == 0 and " "
								or spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
						end,
					})
				end,
			})
		end,
	},

	{
		"folke/todo-comments.nvim",
		optional = true,
		keys = {
			{
				"<leader>st",
				function()
					Snacks.picker.todo_comments({ hidden = true })
				end,
				desc = "Todo",
			},
			{
				"<leader>sT",
				function()
					Snacks.picker.todo_comments({ keywords = { "TODO", "FIX", "FIXME" }, hidden = true })
				end,
				desc = "Todo/Fix/Fixme",
			},
		},
	},
}
