local function trim(s)
	return s:match("^%s*(.-)%s*$")
end

local function get_git_root()
	local handle = io.popen("git rev-parse --show-toplevel 2> /dev/null")
	if not handle then
		return nil
	end
	local result = handle:read("*a")
	handle:close()
	result = trim(result)
	if result == "" then
		return nil
	else
		return result
	end
end

local function get_git_remote()
	local handle = io.popen("git config --get remote.origin.url 2> /dev/null")
	if not handle then
		return nil
	end
	local result = handle:read("*a")
	handle:close()
	result = trim(result)
	if result == "" then
		return nil
	else
		return result
	end
end

local function copy_relative_file_path()
	local git_root = get_git_root()
	if not git_root then
		vim.notify("Not in a git repository", vim.log.levels.ERROR)
		return
	end

	local file_path = vim.fn.expand("%:p")
	local relative_path = file_path:sub(#git_root + 2)
	vim.fn.setreg("+", relative_path)
	vim.notify("Copied file path: " .. relative_path)
end

local function copy_git_url()
	local git_root = get_git_root()
	if not git_root then
		vim.notify("Not in a git repository", vim.log.levels.ERROR)
		return
	end

	local remote = get_git_remote()
	if not remote then
		vim.notify("No git remote found", vim.log.levels.ERROR)
		return
	end

	local file_path = vim.fn.expand("%:p")
	local relative_path = file_path:sub(#git_root + 2)
	-- TODO: handle other main branch names
	local branch = "main"

	if remote:match("^git@") then
		remote = remote:gsub("git@", "https://")
		remote = remote:gsub(":", "/")
	end
	remote = remote:gsub("%.git$", "")

	local url = remote .. "/blob/" .. branch .. "/" .. relative_path

	vim.fn.setreg("+", url)
	vim.notify("Copied Git URL: " .. url)
end

vim.api.nvim_create_user_command(
	"CopyFilePath",
	copy_relative_file_path,
	{ desc = "Copy current file's path relative to the Git (project) root" }
)

vim.api.nvim_create_user_command(
	"CopyGitUrl",
	copy_git_url,
	{ desc = "Copy current file's URL on the Git remote (main branch)" }
)

vim.keymap.set("n", "<leader>bf", copy_relative_file_path, { desc = "Copy file path from project root" })
vim.keymap.set("n", "<leader>bg", copy_git_url, { desc = "Copy Git URL for current file" })
