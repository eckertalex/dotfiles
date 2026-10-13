local augroup = require("utils").augroup

vim.api.nvim_create_autocmd("PackChanged", {
    group = augroup,
    callback = function(event)
        if event.data.spec.name ~= "nvim-treesitter" or event.data.kind ~= "update" then
            return
        end
        if not event.data.active then
            vim.cmd.packadd("nvim-treesitter")
        end
        vim.cmd("TSUpdate")
    end,
    desc = ":TSUpdate",
})

vim.pack.add({
    "https://github.com/nvim-treesitter/nvim-treesitter",
    "https://github.com/nvim-treesitter/nvim-treesitter-context",
})

local languages = {
    "bash",
    "css",
    "diff",
    "dockerfile",
    "git_config",
    "gitcommit",
    "git_rebase",
    "gitignore",
    "gitattributes",
    "go",
    "gomod",
    "gosum",
    "gowork",
    "graphql",
    "html",
    "java",
    "javascript",
    "json",
    "json5",
    "kotlin",
    "php",
    "python",
    "sql",
    "scss",
    "toml",
    "tsx",
    "typescript",
    "yaml",
    "zsh",
}

-- Skips parsers that are already installed
require("nvim-treesitter").install(languages)

vim.api.nvim_create_autocmd("FileType", {
    group = augroup,
    callback = function(event)
        -- Fails when there is no parser for this filetype
        if not pcall(vim.treesitter.start, event.buf) then
            return
        end
        vim.wo[0][0].foldmethod = "expr"
        vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
        vim.bo[event.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end,
    desc = "Start tree-sitter highlighting, folds and indent",
})

require("treesitter-context").setup({
    max_lines = 3,
})

vim.pack.add({ "https://github.com/JoosepAlviste/nvim-ts-context-commentstring" })
require("ts_context_commentstring").setup({
    enable_autocmd = false,
})

-- Built-in `gc` resolves 'commentstring' through `vim.filetype.get_option()`,
-- so hook in there to get context-aware comments (e.g. JSX in TSX files)
local get_option = vim.filetype.get_option
---@diagnostic disable-next-line: duplicate-set-field
vim.filetype.get_option = function(filetype, option)
    if option == "commentstring" then
        return require("ts_context_commentstring.internal").calculate_commentstring() or get_option(filetype, option)
    end
    return get_option(filetype, option)
end
