-- Personal preferences for every Lua project. Project-specific setup (like
-- Neovim's runtime for this config) lives in each project's .luarc.json.
---@type vim.lsp.Config
return {
    settings = {
        Lua = {
            completion = {
                callSnippet = "Replace",
            },
            hint = {
                enable = true,
            },
        },
    },
}
