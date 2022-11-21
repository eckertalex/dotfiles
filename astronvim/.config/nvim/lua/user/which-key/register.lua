local utils = require "user.utils"
local toggle_term_cmd = astronvim.toggle_term_cmd

return {
  n = {
    ["<leader>"] = {
      H = { "<cmd>set hlsearch!<cr>", "Toggle Highlight" },
      z = { "<cmd>ZenMode<cr>", "Zen Mode" },

      a = {
        name = "Annotate",
        ["<cr>"] = { function() require("neogen").generate() end, "Current" },
        c = { function() require("neogen").generate { type = "class" } end, "Class" },
        f = { function() require("neogen").generate { type = "func" } end, "Function" },
        t = { function() require("neogen").generate { type = "type" } end, "Type" },
        F = { function() require("neogen").generate { type = "file" } end, "File" },
      },

      f = {
        name = "Telescope",
        ["?"] = { "<cmd>Telescope help_tags<cr>", "Find Help" },
        ["'"] = { "<cmd>Telescope marks<cr>", "Marks" },
        B = { "<cmd>Telescope bibtex<cr>", "BibTeX" },
        e = { "<cmd>Telescope file_browser<cr>", "Explorer" },
        h = { "<cmd>Telescope oldfiles<cr>", "History" },
        k = { "<cmd>Telescope keymaps<cr>", "Keymaps" },
        m = { "<cmd>Telescope man_pages<cr>", "Man Pages" },
        M = { "<cmd>Telescope media_files<cr>", "Media" },
        n = { "<cmd>Telescope notify<cr>", "Notifications" },
        p = { "<cmd>Telescope project<cr>", "Projects" },
        r = { "<cmd>Telescope registers<cr>", "Registers" },
        t = { "<cmd>Telescope colorscheme<cr>", "Themes" },
      },

      g = {
        name = "Git",
        g = { function() toggle_term_cmd "gitui" end, "ToggleTerm gitui" },
      },

      t = {
        name = "Terminal",
        g = { function() toggle_term_cmd "gitui" end, "ToggleTerm gitui" },
      },

      d = {
        name = "Document",
        n = { "<cmd>enew<cr>", "New File" },
        c = { function() utils.vim_opt_toggle("conceallevel", 2, 0, "Conceal") end, "Toggle Conceal" },
        w = { function() utils.vim_opt_toggle("wrap", true, false, "Soft Wrap") end, "Toggle Soft Wrapping" },
        W = { function() utils.vim_opt_toggle("textwidth", 80, 0, "Hard Wrap") end, "Toggle Hard Wrapping" },
      },

      h = {
        name = "Hop",
        c = { "<cmd>HopChar1<cr>", "Character" },
        C = { "<cmd>HopChar2<cr>", "2 Characters" },
        l = { "<cmd>HopLine<cr>", "Line" },
        p = { "<cmd>HopPattern<cr>", "Pattern" },
        w = { "<cmd>HopWord<cr>", "Word" },
      },
    },
  },
  v = {
    ["<leader>"] = {
      h = {
        name = "Hop",
        c = { "<cmd>HopChar1<cr>", "Character" },
        C = { "<cmd>HopChar2<cr>", "2 Characters" },
        l = { "<cmd>HopLine<cr>", "Line" },
        p = { "<cmd>HopPattern<cr>", "Pattern" },
        w = { "<cmd>HopWord<cr>", "Word" },
      },
    }
  }
}
