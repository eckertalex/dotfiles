return {
    {
        "stevearc/quicker.nvim",
        config = function()
            local quicker = require("quicker")
            quicker.setup({
                quickfix = { open = true, close = true, stay = true },
                loclist = { open = true, close = true, stay = true },
                keys = {
                    { "<a-p>", quicker.toggle_expand, desc = "Toggle quickfix content" },
                },
            })
        end,
    },
}
