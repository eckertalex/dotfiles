vim.pack.add({
    "https://github.com/nvim-mini/mini.bufremove",
    "https://github.com/nvim-mini/mini.clue",
    "https://github.com/nvim-mini/mini.hipatterns",
    "https://github.com/nvim-mini/mini.icons",
    "https://github.com/nvim-mini/mini.indentscope",
})

require("mini.icons").setup()
MiniIcons.tweak_lsp_kind()

require("mini.bufremove").setup()
vim.keymap.set("n", "<leader>bd", function()
    MiniBufremove.delete()
end, { desc = "Delete" })
vim.keymap.set("n", "<leader>bD", function()
    MiniBufremove.delete(0, true)
end, { desc = "Delete!" })

local miniclue = require("mini.clue")
miniclue.setup({
    window = {
        delay = 0,
    },
    clues = {
        { mode = "n", keys = "<Leader>b", desc = "+Buffer" },
        { mode = "n", keys = "<Leader>f", desc = "+Find" },
        { mode = "n", keys = "<Leader>g", desc = "+Git" },
        { mode = "n", keys = "<Leader>s", desc = "+Search" },
        { mode = "x", keys = "<Leader>s", desc = "+Search" },
        { mode = "n", keys = "<Leader>t", desc = "+Terminal" },
        { mode = "n", keys = "<Leader>x", desc = "+Diagnostics" },
        { mode = "n", keys = "<Leader>y", desc = "+Yank" },
        { mode = "x", keys = "<Leader>y", desc = "+Yank" },
        miniclue.gen_clues.builtin_completion(),
        miniclue.gen_clues.g(),
        miniclue.gen_clues.marks(),
        miniclue.gen_clues.registers(),
        miniclue.gen_clues.square_brackets(),
        miniclue.gen_clues.windows({ submode_resize = true }),
        miniclue.gen_clues.z(),
    },
    triggers = {
        { mode = "n", keys = "<Leader>" },
        { mode = "x", keys = "<Leader>" },
        { mode = "n", keys = "[" },
        { mode = "n", keys = "]" },
        { mode = "x", keys = "[" },
        { mode = "x", keys = "]" },
        { mode = "i", keys = "<C-x>" },
        { mode = "n", keys = "g" },
        { mode = "x", keys = "g" },
        { mode = "n", keys = "'" },
        { mode = "n", keys = "`" },
        { mode = "x", keys = "'" },
        { mode = "x", keys = "`" },
        { mode = "n", keys = '"' },
        { mode = "x", keys = '"' },
        { mode = "i", keys = "<C-r>" },
        { mode = "c", keys = "<C-r>" },
        { mode = "n", keys = "<C-w>" },
        { mode = "n", keys = "z" },
        { mode = "x", keys = "z" },
    },
})

local hipatterns = require("mini.hipatterns")

local function make_pattern(word)
    return string.format("()%%f[%%w_]%s()%%f[^%%w_]", word)
end

hipatterns.setup({
    highlighters = {
        fixme = {
            pattern = {
                make_pattern("FIXME"),
                make_pattern("FIX"),
            },
            group = "MiniHipatternsFixme",
        },
        hack = {
            pattern = {
                make_pattern("HACK"),
                make_pattern("WARN"),
                make_pattern("WARNING"),
            },
            group = "MiniHipatternsHack",
        },
        todo = {
            pattern = make_pattern("TODO"),
            group = "MiniHipatternsTodo",
        },
        note = {
            pattern = {
                make_pattern("NOTE"),
                make_pattern("INFO"),
            },
            group = "MiniHipatternsNote",
        },
        hex_color = hipatterns.gen_highlighter.hex_color(),
    },
})

require("mini.indentscope").setup()
