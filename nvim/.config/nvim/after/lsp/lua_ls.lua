return {
    settings = {
        Lua = {
            completion = {
                callSnippet = "Replace",
            },
            runtime = {
                version = "LuaJIT",
                path = vim.split(package.path, ";"),
            },
            workspace = {
                library = {
                    vim.env.VIMRUNTIME,
                },
            },
            hint = {
                enable = true,
            },
        },
    },
}
