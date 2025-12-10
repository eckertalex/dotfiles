return {
    {
        "saghen/blink.cmp",
        version = "1.*",
        config = function()
            require("blink.cmp").setup({
                keymap = { preset = "default" },
                appearance = {
                    nerd_font_variant = "mono",
                },
                completion = {
                    documentation = {
                        auto_show = true,
                        auto_show_delay_ms = 500,
                    },
                },
                sources = {
                    default = { "lazydev", "lsp", "path", "buffer" },
                    providers = {
                        lazydev = {
                            name = "LazyDev",
                            module = "lazydev.integrations.blink",
                            score_offset = 100,
                        },
                    },
                },
                signature = { enabled = true },
                fuzzy = { implementation = "prefer_rust_with_warning" },
            })
        end,
    },
}
