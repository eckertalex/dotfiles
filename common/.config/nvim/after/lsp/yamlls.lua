---@type vim.lsp.Config
return {
    settings = {
        yaml = {
            -- allow reordering keys freely
            keyOrdering = false,
            schemas = require("schemastore").yaml.schemas(),
            schemaStore = {
                -- Must disable built-in schemaStore support to use
                -- schemas from SchemaStore.nvim plugin
                enable = false,
                -- Avoid TypeError: Cannot read properties of undefined (reading 'length')
                url = "",
            },
        },
    },
}
