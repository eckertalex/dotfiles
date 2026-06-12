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
    "https://github.com/nvim-treesitter/nvim-treesitter-textobjects",
    "https://github.com/nvim-treesitter/nvim-treesitter-context",
})

local languages = {
    "astro",
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
    "html",
    "java",
    "javascript",
    "json5",
    "kotlin",
    "php",
    "sql",
    "scss",
    "toml",
    "tsx",
    "typescript",
    "yaml",
    "zsh",
}

local function isnt_installed(lang)
    return #vim.api.nvim_get_runtime_file("parser/" .. lang .. ".*", false) == 0
end
local to_install = vim.tbl_filter(isnt_installed, languages)
if #to_install > 0 then
    require("nvim-treesitter").install(to_install)
end

-- Enable tree-sitter after opening a file for a target language
local ts_filetypes = {}
for _, lang in ipairs(languages) do
    for _, ft in ipairs(vim.treesitter.language.get_filetypes(lang)) do
        table.insert(ts_filetypes, ft)
    end
end
vim.api.nvim_create_autocmd("FileType", {
    group = augroup,
    pattern = ts_filetypes,
    callback = function(event)
        vim.treesitter.start(event.buf)
    end,
    desc = "Start tree-sitter",
})

vim.api.nvim_create_autocmd("FileType", {
    group = augroup,
    pattern = ts_filetypes,
    callback = function()
        vim.opt_local.foldmethod = "expr"
        vim.opt_local.foldexpr = "nvim_treesitter#foldexpr()"
        vim.opt_local.indentexpr = "nvim_treesitter#indent()"
    end,
    desc = "Enable tree-sitter foldexpr and indentexpr",
})

require("nvim-treesitter-textobjects").setup({
    select = {
        lookahead = true,
    },
})
local select_maps = {
    ["af"] = "@function.outer",
    ["if"] = "@function.inner",
    ["ac"] = "@class.outer",
    ["ic"] = "@class.inner",
    ["aa"] = "@parameter.outer",
    ["ia"] = "@parameter.inner",
    ["ai"] = "@conditional.outer",
    ["ii"] = "@conditional.inner",
    ["al"] = "@loop.outer",
    ["il"] = "@loop.inner",
    ["ab"] = "@block.outer",
    ["ib"] = "@block.inner",
}
for key, query in pairs(select_maps) do
    vim.keymap.set({ "x", "o" }, key, function()
        require("nvim-treesitter-textobjects.select").select_textobject(query, "textobjects")
    end, { desc = "Select " .. query })
end

require("treesitter-context").setup({
    max_lines = 3,
})
