local add = MiniDeps.add
local now_if_args = _G.Config.now_if_args

now_if_args(function()
    add({
        source = "nvim-treesitter/nvim-treesitter",
        checkout = "main",
        hooks = {
            post_checkout = function()
                vim.cmd("TSUpdate")
            end,
        },
    })
    add({
        source = "nvim-treesitter/nvim-treesitter-textobjects",
        checkout = "main",
    })
    add({ source = "nvim-treesitter/nvim-treesitter-context" })

    -- Treesitter ==============================================================
    local languages = {
        "astro",
        "bash",
        "c",
        "css",
        "diff",
        "dockerfile",
        "git_config",
        "git_rebase",
        "gitattributes",
        "gitcommit",
        "gitignore",
        "go",
        "gomod",
        "gosum",
        "gowork",
        "html",
        "java",
        "javascript",
        "json5",
        "lua",
        "kotlin",
        "php",
        "sql",
        "markdown",
        "markdown_inline",
        "scss",
        "toml",
        "tsx",
        "typescript",
        "yaml",
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
    local function ts_start(ev)
        vim.treesitter.start(ev.buf)
    end
    _G.Config.new_autocmd("FileType", ts_filetypes, ts_start, "Start tree-sitter")

    local function enable_ts_features()
        vim.opt_local.foldmethod = "expr"
        vim.opt_local.foldexpr = "nvim_treesitter#foldexpr()"
        vim.opt_local.indentexpr = "nvim_treesitter#indent()"
    end
    _G.Config.new_autocmd("FileType", ts_filetypes, enable_ts_features, "Enable tree-sitter foldexpr and indentexpr")

    -- Textobjects =============================================================
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

    -- Textobjects context =====================================================
    require("treesitter-context").setup({
        max_lines = 3,
    })
end)
