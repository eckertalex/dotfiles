Config.now(function()
    require("mini.basics").setup({
        options = {
            extra_ui = true,
        },
        mappings = {
            windows = true,
            move_with_alt = true,
        },
        autocommands = {
            relnum_in_visual_mode = true,
        },
    })
end)

Config.now(function()
    require("mini.icons").setup()

    -- Add LSP kind icons. Useful for 'mini.completion'.
    Config.later(MiniIcons.tweak_lsp_kind)
end)

Config.now(function()
    local starter = require("mini.starter")
    starter.setup({
        query_updaters = "abcdefghijklmnopqrstuvwxyz0123456789_.",
        evaluate_single = true,
        items = {
            starter.sections.builtin_actions(),
            starter.sections.recent_files(9, true, false),
        },
        content_hooks = {
            starter.gen_hook.adding_bullet(),
            starter.gen_hook.indexing("all", { "Builtin actions" }),
            starter.gen_hook.aligning("center", "center"),
        },
    })
end)

Config.now(function()
    require("mini.statusline").setup()
end)

Config.now(function()
    require("mini.tabline").setup()
end)

Config.now_if_args(function()
    require("mini.misc").setup()

    MiniMisc.setup_auto_root()
    MiniMisc.setup_restore_cursor()
end)

-- Completion and signature help. Implements async "two stage" autocompletion:
-- - Based on attached LSP servers that support completion.
-- - Fallback (based on built-in keyword completion) if there is no LSP candidates.
--
-- Example usage in Insert mode with attached LSP:
-- - Start typing text that should be recognized by LSP (like variable name).
-- - After 100ms a popup menu with candidates appears.
-- - Press `<C-n>` / `<C-p>` to navigate down/up the list.
-- - During navigation there is an info window to the right showing extra info
--   that the LSP server can provide about the candidate. It appears after the
--   candidate stays selected for 100ms. Use `<C-f>` / `<C-b>` to scroll it.
-- - Navigating to an entry also changes buffer text. If you are happy with it,
--   keep typing after it. To discard completion completely, press `<C-e>`.
-- - After pressing special trigger(s), usually `(`, a window appears that shows
--   the signature of the current function/method. It gets updated as you type
--   showing the currently active parameter.
--
-- Example usage in Insert mode without an attached LSP or in places not
-- supported by the LSP (like comments):
-- - Start typing a word that is present in current or opened buffers.
-- - After 100ms popup menu with candidates appears.
-- - Navigate with `<C-n>` / `<C-p>`. This also updates
--   buffer text. If happy with choice, keep typing. Stop with `<C-e>`.
--
-- It also works with snippet candidates provided by LSP server. Best experience
-- when paired with 'mini.snippets' (which is set up in this file).
Config.now_if_args(function()
    -- Customize post-processing of LSP responses for a better user experience.
    -- Don't show 'Text' suggestions (usually noisy) and show snippets last.
    local process_items_opts = { kind_priority = { Text = -1, Snippet = 99 } }
    local process_items = function(items, base)
        return MiniCompletion.default_process_items(items, base, process_items_opts)
    end
    require("mini.completion").setup({
        lsp_completion = {
            -- Without this config autocompletion is set up through `:h 'completefunc'`.
            -- Although not needed, setting up through `:h 'omnifunc'` is cleaner
            -- (sets up only when needed) and makes it possible to use `<C-u>`.
            source_func = "omnifunc",
            auto_setup = false,
            process_items = process_items,
        },
    })

    -- Set 'omnifunc' for LSP completion only when needed.
    vim.api.nvim_create_autocmd("LspAttach", {
        group = Config.custom_augroup,
        callback = function(event)
            vim.bo[event.buf].omnifunc = "v:lua.MiniCompletion.completefunc_lsp"
        end,
        desc = "Set 'omnifunc'",
    })

    -- Advertise to servers that Neovim now supports certain set of completion and
    -- signature features through 'mini.completion'.
    vim.lsp.config("*", { capabilities = MiniCompletion.get_lsp_capabilities() })
end)

-- Manage and expand snippets (templates for a frequently used text).
-- Typical workflow is to type snippet's (configurable) prefix and expand it
-- into a snippet session.
--
-- How to manage snippets:
-- - 'mini.snippets' itself doesn't come with preconfigured snippets. Instead there
--   is a flexible system of how snippets are prepared before expanding.
--   They can come from pre-defined path on disk, 'snippets/' directories inside
--   config or plugins, defined inside `setup()` call directly.
-- - This config, however, does come with snippet configuration:
--     - 'snippets/global.json' is a file with global snippets that will be
--       available in any buffer
--     - 'after/snippets/lua.json' defines personal snippets for Lua language
--     - 'friendly-snippets' plugin configured in 'plugin/40_plugins.lua' provides
--       a collection of language snippets
--
-- How to expand a snippet in Insert mode:
-- - If you know snippet's prefix, type it as a word and press `<C-j>`. Snippet's
--   body should be inserted instead of the prefix.
-- - If you don't remember snippet's prefix, type only part of it (or none at all)
--   and press `<C-j>`. It should show picker with all snippets that have prefixes
--   matching typed characters (or all snippets if none was typed).
--   Choose one and its body should be inserted instead of previously typed text.
--
-- How to navigate during snippet session:
-- - Snippets can contain tabstops - places for user to interactively adjust text.
--   Each tabstop is highlighted depending on session progression - whether tabstop
--   is current, was or was not visited. If tabstop doesn't yet have text, it is
--   visualized with special "ghost" inline text: • and ∎ by default.
-- - Type necessary text at current tabstop and navigate to next/previous one
--   by pressing `<C-l>` / `<C-h>`.
-- - Repeat previous step until you reach special final tabstop, usually denoted
--   by ∎ symbol. If you spotted a mistake in an earlier tabstop, navigate to it
--   and return back to the final tabstop.
-- - To end a snippet session when at final tabstop, keep typing or go into
--   Normal mode. To force end snippet session, press `<C-c>`.
--
-- See also:
-- - `:h MiniSnippets-overview` - overview of how module works
-- - `:h MiniSnippets-examples` - examples of common setups
-- - `:h MiniSnippets-session` - details about snippet session
-- - `:h MiniSnippets.gen_loader` - list of available loaders
Config.later(function()
    -- Although 'mini.snippets' provides functionality to manage snippet files, it
    -- deliberately doesn't come with those.
    --
    -- The 'rafamadriz/friendly-snippets' is currently the largest collection of
    -- snippet files. They are organized in 'snippets/' directory (mostly) per language.
    -- 'mini.snippets' is designed to work with it as seamlessly as possible.
    -- See `:h MiniSnippets.gen_loader.from_lang()`.
    vim.pack.add({ "https://github.com/rafamadriz/friendly-snippets" })

    -- Define language patterns to work better with 'friendly-snippets'
    local latex_patterns = { "latex/**/*.json", "**/latex.json" }
    local lang_patterns = {
        tex = latex_patterns,
        plaintex = latex_patterns,
        -- Recognize special injected language of markdown tree-sitter parser
        markdown_inline = { "markdown.json" },
    }

    local snippets = require("mini.snippets")
    local config_path = vim.fn.stdpath("config")
    snippets.setup({
        snippets = {
            -- Always load 'snippets/global.json' from config directory
            snippets.gen_loader.from_file(config_path .. "/snippets/global.json"),
            -- Load from 'snippets/' directory of plugins, like 'friendly-snippets'
            snippets.gen_loader.from_lang({ lang_patterns = lang_patterns }),
        },
    })

    -- By default snippets available at cursor are not shown as candidates in
    -- 'mini.completion' menu. This requires a dedicated in-process LSP server
    -- that will provide them.
    MiniSnippets.start_lsp_server()
end)

Config.later(function()
    require("mini.bracketed").setup({
        -- use keymap from mini.indentscope
        indent = { suffix = "" },
    })
end)

Config.later(function()
    require("mini.diff").setup()

    vim.keymap.set("n", "<leader>gd", "<cmd>lua MiniDiff.toggle_overlay()<cr>", { desc = "Diff file" })
end)

Config.later(function()
    require("mini.bufremove").setup()

    vim.keymap.set("n", "<leader>bd", "<cmd>lua MiniBufremove.delete()<cr>", { desc = "Delete" })
    vim.keymap.set("n", "<leader>bD", "<cmd>lua MiniBufremove.delete(0, true)<cr>", { desc = "Delete!" })
end)

Config.later(function()
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
            { mode = "n", keys = "\\" },
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
end)

Config.later(function()
    vim.pack.add({ "https://github.com/JoosepAlviste/nvim-ts-context-commentstring" })
    require("ts_context_commentstring").setup({
        enable_autocmd = false,
    })

    require("mini.comment").setup({
        options = {
            custom_commentstring = function()
                return require("ts_context_commentstring").calculate_commentstring() or vim.bo.commentstring
            end,
        },
    })
end)

Config.later(function()
    require("mini.cursorword").setup({})
end)

Config.later(function()
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
end)

Config.later(function()
    require("mini.indentscope").setup()
end)
