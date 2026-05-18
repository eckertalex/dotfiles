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
                -- Don't analyze code from submodules
                ignoreSubmodules = true,
                -- Add Neovim's methods for easier code writing
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
