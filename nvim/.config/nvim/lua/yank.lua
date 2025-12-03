local M = {}

-- get full absolute path
local function get_absolute_path()
    return vim.fn.expand("%:p")
end

-- get path relative to Git root (fallback to cwd)
local function get_relative_path()
    local file = vim.fn.expand("%:p")
    local git_root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]

    local relpath
    if vim.v.shell_error == 0 and git_root and vim.fn.isdirectory(git_root) == 1 then
        relpath = vim.fn.fnamemodify(file, ":." .. git_root)
    else
        relpath = vim.fn.expand("%:.")
    end

    return "./" .. relpath
end

-- format visual range, e.g., "12-18"
local function get_visual_range()
    local start_line = vim.fn.line("v")
    local end_line = vim.fn.line(".")
    if start_line > end_line then
        start_line, end_line = end_line, start_line
    end
    if start_line == end_line then
        return tostring(start_line)
    else
        return string.format("%d-%d", start_line, end_line)
    end
end

-- Copy text to clipboard
local function copy_to_clipboard(text)
    vim.fn.setreg("+", text)
    vim.notify("Yanked: " .. text)
end

-- yank absolute path (and visual line range if applicable)
function M.yank_absolute()
    local path = get_absolute_path()
    if vim.fn.mode():match("[vV]") then
        path = path .. ":" .. get_visual_range()
    end
    copy_to_clipboard(path)
end

-- yank relative path (and visual line range if applicable)
function M.yank_relative()
    local path = get_relative_path()
    if vim.fn.mode():match("[vV]") then
        path = path .. ":" .. get_visual_range()
    end
    copy_to_clipboard(path)
end

return M
