return {
    settings = {
        -- HACK: cssls and tailwindcss both attach to CSS files.
        -- cssls doesn't understand Tailwind-specific at‑rules like @tailwind,
        -- @apply, and @plugin, which causes false “unknown at rule” diagnostics.
        -- Disable only that lint check so cssls still provides normal CSS
        -- completions, hovers, and property documentation.
        css = { lint = { unknownAtRules = "ignore" } },
        scss = { lint = { unknownAtRules = "ignore" } },
        less = { lint = { unknownAtRules = "ignore" } },
    },
}
