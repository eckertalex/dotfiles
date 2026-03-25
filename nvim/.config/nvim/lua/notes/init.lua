local M = {}

M.notes_file = "~/code/work/notes.md"

--- Get or create the notes buffer
local function get_buf()
    local path = vim.fn.expand(M.notes_file)
    if vim.fn.filereadable(path) == 0 then
        vim.fn.mkdir(vim.fn.fnamemodify(path, ":h"), "p")
        vim.fn.writefile({}, path)
    end
    local buf = vim.fn.bufadd(path)
    vim.fn.bufload(buf)
    vim.bo[buf].buflisted = false
    vim.bo[buf].bufhidden = "hide"
    return buf, path
end

--- If the notes buffer is already visible in any window, jump there.
local function jump_to_existing(buf)
    for _, win in ipairs(vim.api.nvim_list_wins()) do
        if vim.api.nvim_win_get_buf(win) == buf then
            vim.api.nvim_set_current_win(win)
            return true
        end
    end
    return false
end

--- Open notes in the current window (oil-style).
function M.open()
    local buf = get_buf()
    if not jump_to_existing(buf) then
        vim.api.nvim_set_current_buf(buf)
    end
end

return M
