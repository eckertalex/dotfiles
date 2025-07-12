---@module 'snacks'

local M = {}

M.multigrep = function()
	Snacks.picker.pick({
		title = "Multigrep",
		finder = function(opts, ctx)
			Snacks.debug(opts)
		end,
	})

	-- local opts = {
	-- 	cwd = vim.uv.cwd(),
	-- 	shortcuts = {
	-- 		globs = {
	-- 			["l"] = "*.lua",
	-- 			["g"] = "*.go",
	-- 			["js"] = "*.js",
	-- 			["jsx"] = "*.jsx",
	-- 			["ts"] = "*.ts",
	-- 			["tsx"] = "*.tsx",
	-- 			["s"] = "*.test.*",
	-- 			["T"] = "!*.test.*",
	-- 		},
	-- 		paths = {
	-- 			["tm"] = "product-areas/time-money/",
	-- 			["ds"] = "product-areas/design-system/",
	-- 		},
	-- 	},
	-- 	pattern = "%s",
	-- }
	--
	-- local finder = finders.new_async_job({
	-- 	command_generator = function(prompt)
	-- 		if not prompt or prompt == "" then
	-- 			return nil
	-- 		end
	--
	-- 		local prompt_split = vim.split(prompt, "  ")
	-- 		local args = { "rg" }
	-- 		if prompt_split[1] then
	-- 			table.insert(args, "-e")
	-- 			table.insert(args, prompt_split[1])
	-- 		end
	--
	-- 		for i = 2, #prompt_split do
	-- 			if vim.startswith(prompt_split[i], "in:") then
	-- 				local path = prompt_split[i]:sub(4)
	-- 				if opts.shortcuts.paths[path] then
	-- 					path = opts.shortcuts.paths[path]
	-- 				end
	--
	-- 				table.insert(args, path)
	-- 			else
	-- 				local pattern
	-- 				if opts.shortcuts.globs[prompt_split[i]] then
	-- 					pattern = opts.shortcuts.globs[prompt_split[i]]
	-- 				else
	-- 					pattern = prompt_split[i]
	-- 				end
	--
	-- 				table.insert(args, "-g")
	-- 				table.insert(args, string.format(opts.pattern, pattern))
	-- 			end
	-- 		end
	--
	-- 		return vim.iter({
	-- 			args,
	-- 			{ "--color=never", "--no-heading", "--with-filename", "--line-number", "--column", "--smart-case" },
	-- 		})
	-- 			:flatten()
	-- 			:totable()
	-- 	end,
	-- 	entry_maker = make_entry.gen_from_vimgrep(opts),
	-- 	cwd = opts.cwd,
	-- })

	-- pickers
	-- 	.new(opts, {
	-- 		debounce = 100,
	-- 		prompt_title = "Multi Grep",
	-- 		finder = finder,
	-- 		previewer = conf.grep_previewer(opts),
	-- 		sorter = require("telescope.sorters").empty(),
	-- 	})
	-- 	:find()
end

return M
