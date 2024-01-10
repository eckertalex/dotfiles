-- [[ Autocmds ]]

-- [[ Highlight on yank ]]
vim.api.nvim_create_autocmd("TextYankPost", {
	group = vim.api.nvim_create_augroup("YankHighlight", { clear = true }),
	pattern = "*",
	callback = function()
		vim.highlight.on_yank({
			higroup = "IncSearch",
			timeout = 40,
		})
	end,
})

-- [[ go to last loc when opening a buffer ]]
vim.api.nvim_create_autocmd("BufReadPost", {
	group = vim.api.nvim_create_augroup("last_loc", { clear = true }),
	callback = function(event)
		local exclude = { "gitcommit" }
		local buf = event.buf
		if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].lazyvim_last_loc then
			return
		end
		vim.b[buf].lazyvim_last_loc = true
		local mark = vim.api.nvim_buf_get_mark(buf, '"')
		local lcount = vim.api.nvim_buf_line_count(buf)
		if mark[1] > 0 and mark[1] <= lcount then
			pcall(vim.api.nvim_win_set_cursor, 0, mark)
		end
	end,
})

-- [[ close some filetypes with <q> ]]
vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("close_with_q", { clear = true }),
	pattern = {
		"PlenaryTestPopup",
		"help",
		"lspinfo",
		"man",
		"notify",
		"qf",
		"query",
		"spectre_panel",
		"startuptime",
		"tsplayground",
		"neotest-output",
		"checkhealth",
		"neotest-summary",
		"neotest-output-panel",
	},
	callback = function(event)
		vim.bo[event.buf].buflisted = false
		vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
	end,
})

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspConfig", {}),
	callback = function(ev)
		-- Enable completion triggered by <c-x><c-o>
		vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

		-- [[ Buffer local mappings ]]

		-- Displays hover information about the symbol under the cursor
		vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = ev.buf, desc = "Hover Documentation" })

		-- Jump to the definition
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = ev.buf, desc = "Definition" })

		-- Jump to declaration
		vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = ev.buf, desc = "Declaration" })

		-- Lists all the implementations for the symbol under the cursor
		vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { buffer = ev.buf, desc = "Implementation" })

		-- Jumps to the definition of the type symbol
		vim.keymap.set("n", "gy", vim.lsp.buf.type_definition,
			{ buffer = ev.buf, desc = "Type Definition" })

		-- Lists all the references
		vim.keymap.set("n", "gr", vim.lsp.buf.references, { buffer = ev.buf, desc = "References" })

		-- Displays a function's signature information
		vim.keymap.set("n", "gs", vim.lsp.buf.signature_help,
			{ buffer = ev.buf, desc = "Signature Documentation" })

		-- Renames all references to the symbol under the cursor
		vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, { buffer = ev.buf, desc = "Rename" })

		-- Selects a code action available at the current cursor position
		vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action,
			{ buffer = ev.buf, desc = "Code Action" })

		vim.keymap.set("n", "<leader>cf", function()
			vim.lsp.buf.format({ async = true })
		end, { buffer = ev.buf, desc = "Format" })
	end,
})

-- [[ inlay_hint ]]
vim.api.nvim_create_autocmd('LspAttach', {
	desc = 'Enable inlay hints',
	callback = function(event)
		local client = vim.lsp.get_client_by_id(event.data.client_id)
		if client == nil or not client.server_capabilities.inlayHintProvider then
			return
		end

		vim.lsp.inlay_hint.enable(event.buf, true)
	end,
})

vim.api.nvim_create_user_command('ToggleInlayHints', function()
	local is_enabled = vim.lsp.inlay_hint.is_enabled(nil)
	vim.lsp.inlay_hint.enable(nil, not is_enabled)
	print('Setting lsp.inlay_hint to: ' .. tostring(not is_enabled))
end, {})

vim.keymap.set('n', '<leader>uh', "<cmd>ToggleInlayHints<cr>", { desc = 'Toggle inlay hints' })

-- [[ Autoformat ]]
local format_is_enabled = true
vim.api.nvim_create_user_command('ToggleAutoformat', function()
	format_is_enabled = not format_is_enabled
	print('Setting autoformatting to: ' .. tostring(format_is_enabled))
end, {})

vim.keymap.set('n', '<leader>uf', "<cmd>ToggleAutoformat<cr>", { desc = 'Toggle autoformatting' })

-- Create an augroup that is used for managing our formatting autocmds.
--      We need one augroup per client to make sure that multiple clients
--      can attach to the same buffer without interfering with each other.
local _augroups = {}
local get_augroup = function(client)
	if not _augroups[client.id] then
		local group_name = 'lsp-format-' .. client.name
		local id = vim.api.nvim_create_augroup(group_name, { clear = true })
		_augroups[client.id] = id
	end

	return _augroups[client.id]
end

-- Whenever an LSP attaches to a buffer, we will run this function.
vim.api.nvim_create_autocmd('LspAttach', {
	group = vim.api.nvim_create_augroup('lsp-attach-format', { clear = true }),
	-- This is where we attach the autoformatting for reasonable clients
	callback = function(args)
		local client_id = args.data.client_id
		local client = vim.lsp.get_client_by_id(client_id)
		local bufnr = args.buf

		if not client then
			return
		end

		-- Only attach to clients that support document formatting
		if not client.server_capabilities.documentFormattingProvider then
			return
		end

		-- Tsserver usually works poorly. Sorry you work with bad languages
		-- You can remove this line if you know what you're doing :)
		if client.name == 'tsserver' then
			return
		end


		-- Create a command `:Format` local to the LSP buffer
		vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
			vim.lsp.buf.format()
		end, { desc = 'Format current buffer with LSP' })

		-- Create an autocmd that will run *before* we save the buffer.
		--  Run the formatting command for the LSP that has just attached.
		vim.api.nvim_create_autocmd('BufWritePre', {
			group = get_augroup(client),
			buffer = bufnr,
			callback = function()
				if not format_is_enabled then
					return
				end

				vim.lsp.buf.format {
					async = false,
					filter = function(c)
						return c.id == client.id
					end,
				}
			end,
		})
	end,
})

local function highlight_symbol(event)
	local id = vim.tbl_get(event, 'data', 'client_id')
	local client = id and vim.lsp.get_client_by_id(id)
	if client == nil or not client.supports_method('textDocument/documentHighlight') then
		return
	end

	local group = vim.api.nvim_create_augroup('highlight_symbol', { clear = false })

	vim.api.nvim_clear_autocmds({ buffer = event.buf, group = group })

	vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
		group = group,
		buffer = event.buf,
		callback = vim.lsp.buf.document_highlight,
	})

	vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
		group = group,
		buffer = event.buf,
		callback = vim.lsp.buf.clear_references,
	})
end

vim.api.nvim_create_autocmd('LspAttach', {
	desc = 'Setup highlight symbol',
	callback = highlight_symbol,
})
