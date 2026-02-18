--[[
=====================================================================
=====================================================================
========                                    .-----.          ========
========         .----------------------.   | === |          ========
========         |.-""""""""""""""""""-.|   |-----|          ========
========         ||                    ||   | === |          ========
========         ||       NEOVIM       ||   |-----|          ========
========         ||                    ||   | === |          ========
========         ||                    ||   |-----|          ========
========         ||:Tutor              ||   |:::::|          ========
========         |'-..................-'|   |____o|          ========
========         `"")----------------(""`   ___________      ========
========        /::::::::::|  |::::::::::\  \ no mouse \     ========
========       /:::========|  |==hjkl==:::\  \ required \    ========
========      '""""""""""""'  '""""""""""""'  '""""""""""'   ========
========                                                     ========
=====================================================================
=====================================================================
--]]

_G.Config = {}

vim.pack.add({ "https://github.com/nvim-mini/mini.nvim" })

local misc = require("mini.misc")

-- execute immediately. Use for what must be executed during startup.
-- Like colorscheme, statusline, tabline, dashboard, etc.
Config.now = function(f)
    misc.safely("now", f)
end

-- execute a bit later. Use for things not needed during startup.
Config.later = function(f)
    misc.safely("later", f)
end

-- use only if needed during startup when Neovim is started
-- like `nvim -- path/to/file`, but otherwise delaying is fine.
Config.now_if_args = vim.fn.argc(-1) > 0 and Config.now or Config.later

Config.custom_augroup = vim.api.nvim_create_augroup("custom-config", {})

-- Define custom `vim.pack.add()` hook helper. See `:h vim.pack-events`.
Config.on_packchanged = function(plugin_name, kinds, callback, desc)
    vim.api.nvim_create_autocmd("PackChanged", {
        group = Config.custom_augroup,
        callback = function(event)
            local name, kind = event.data.spec.name, event.data.kind
            if not (name == plugin_name and vim.tbl_contains(kinds, kind)) then
                return
            end
            if not event.data.active then
                vim.cmd.packadd(plugin_name)
            end
            callback()
        end,
        desc = desc,
    })
end

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=4 sw=4
