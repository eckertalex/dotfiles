return {
    {
        "nvim-treesitter/nvim-treesitter",
        version = false, -- last release is way too old and doesn't work on Windows
        build = ":TSUpdate",
        dependencies = {
            "nvim-treesitter/nvim-treesitter-textobjects",
        },
        config = function()
            ---@diagnostic disable-next-line: missing-fields
            require("nvim-treesitter.configs").setup({
                auto_install = true,
                highlight = { enable = true },
                indent = { enable = true },
                ensure_installed = {
                    "astro",
                    "bash",
                    "c",
                    "css",
                    "diff",
                    "dockerfile",
                    "elixir",
                    "gitcommit",
                    "gitignore",
                    "go",
                    "gomod",
                    "gosum",
                    "gowork",
                    "html",
                    "javascript",
                    "jsdoc",
                    "json",
                    "json5",
                    "jsonc",
                    "lua",
                    "luadoc",
                    "luap",
                    "markdown",
                    "markdown_inline",
                    "query",
                    "regex",
                    "scss",
                    "toml",
                    "tsx",
                    "typescript",
                    "vim",
                    "vimdoc",
                    "yaml",
                },
                incremental_selection = {
                    enable = true,
                    keymaps = {
                        init_selection = "gnn",
                        node_incremental = "gnn",
                        scope_incremental = "grc",
                        node_decremental = "grm",
                    },
                },
                textobjects = {
                    select = {
                        enable = true,
                        lookahead = true,
                        keymaps = {
                            ["aa"] = "@parameter.outer",
                            ["ia"] = "@parameter.inner",
                            ["af"] = "@function.outer",
                            ["if"] = "@function.inner",
                        },
                    },
                },
            })
        end,
    },

    {
        "nvim-treesitter/nvim-treesitter-context",
        config = function()
            require("treesitter-context").setup({
                max_lines = 3,
            })
        end,
    },
}
