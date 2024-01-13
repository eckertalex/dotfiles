return {
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.5",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local function filenameFirst(_, path)
        local tail = vim.fs.basename(path)
        local parent = vim.fs.dirname(path)
        if parent == "." then
          return tail
        end
        return string.format("%s\t\t%s", tail, parent)
      end

      vim.api.nvim_create_autocmd("FileType", {
        pattern = "TelescopeResults",
        callback = function(ctx)
          vim.api.nvim_buf_call(ctx.buf, function()
            vim.fn.matchadd("TelescopeParent", "\t\t.*$")
            vim.api.nvim_set_hl(0, "TelescopeParent", { link = "Comment" })
          end)
        end,
      })

      local action_layout = require("telescope.actions.layout")
      require("telescope").setup({
        defaults = {
          path_display = filenameFirst,
          mappings = {
            n = {
              ["<C-h>"] = action_layout.toggle_preview,
            },
            i = {
              ["<C-h>"] = action_layout.toggle_preview,
            },
          },
        },
      })

      local builtin = require("telescope.builtin")

      vim.keymap.set("n", "<leader><leader>", builtin.find_files, { desc = "Find Files" })
      vim.keymap.set("n", "<leader>r", builtin.resume, { desc = "Resume Telescope" })

      -- find
      vim.keymap.set("n", "<leader>fb", function()
        builtin.buffers({ sort_mru = true, sort_lastused = true })
      end, { desc = "Buffers" })
      vim.keymap.set("n", "<leader>fr", builtin.oldfiles, { desc = "Recent" })

      -- git
      vim.keymap.set("n", "<leader>gc", builtin.git_commits, { desc = "Commits" })
      vim.keymap.set("n", "<leader>gs", builtin.git_status, { desc = "Status" })
      vim.keymap.set("n", "<leader>gf", builtin.git_files, { desc = "Git Files" })

      -- search
      vim.keymap.set("n", "<leader>sb", builtin.current_buffer_fuzzy_find, { desc = "Buffer" })
      vim.keymap.set("n", "<leader>sd", function()
        builtin.diagnostics({ bufnr = 0 })
      end, { desc = "Buffer Diagnostics" })
      vim.keymap.set("n", "<leader>sD", builtin.diagnostics, { desc = "Diagnostics" })
      vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "Grep" })
      vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "Help" })
      vim.keymap.set("n", "<leader>sw", builtin.grep_string, { desc = "Current Word" })
    end,
  },

  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = function()
      local harpoon = require("harpoon")
      harpoon:setup({})
      vim.keymap.set("n", "<C-g>", function()
        harpoon.ui:toggle_quick_menu(harpoon:list())
      end, { desc = "List" })
      vim.keymap.set("n", "<leader>hl", function()
        harpoon.ui:toggle_quick_menu(harpoon:list())
      end, { desc = "List" })
      vim.keymap.set("n", "<leader>ha", function()
        harpoon:list():append()
      end, { desc = "Append" })
      vim.keymap.set("n", "<leader>hp", function()
        harpoon:list():prepend()
      end, { desc = "Prepend" })

      vim.keymap.set("n", "<C-h>", function()
        harpoon:list():select(1)
      end, { desc = "Harpoon to file 1" })
      vim.keymap.set("n", "<C-j>", function()
        harpoon:list():select(2)
      end, { desc = "Harpoon to file 2" })
      vim.keymap.set("n", "<C-k>", function()
        harpoon:list():select(3)
      end, { desc = "Harpoon to file 3" })
      vim.keymap.set("n", "<C-l>", function()
        harpoon:list():select(4)
      end, { desc = "Harpoon to file 4" })
    end,
  },

  {
    -- Adds git related signs to the gutter, as well as utilities for managing changes
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup({
        -- See `:help gitsigns.txt`
        signs = {
          add = { text = "+" },
          change = { text = "~" },
          delete = { text = "_" },
          topdelete = { text = "‾" },
          changedelete = { text = "~" },
        },
        on_attach = function(bufnr)
          local gs = package.loaded.gitsigns

          local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
          end

          -- Navigation
          map({ "n", "v" }, "]c", function()
            if vim.wo.diff then
              return "]c"
            end
            vim.schedule(function()
              gs.next_hunk()
            end)
            return "<Ignore>"
          end, { expr = true, desc = "Next hunk" })

          map({ "n", "v" }, "[c", function()
            if vim.wo.diff then
              return "[c"
            end
            vim.schedule(function()
              gs.prev_hunk()
            end)
            return "<Ignore>"
          end, { expr = true, desc = "Previous hunk" })

          -- Actions
          -- visual mode
          map("v", "<leader>ghs", function()
            gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
          end, { desc = "Stage hunk" })
          map("v", "<leader>ghr", function()
            gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
          end, { desc = "Reset hunk" })
          -- normal mode
          map("n", "<leader>ghs", gs.stage_hunk, { desc = "Stage hunk" })
          map("n", "<leader>ghr", gs.reset_hunk, { desc = "Reset hunk" })
          map("n", "<leader>ghS", gs.stage_buffer, { desc = "Stage buffer" })
          map("n", "<leader>ghu", gs.undo_stage_hunk, { desc = "Undo stage hunk" })
          map("n", "<leader>ghR", gs.reset_buffer, { desc = "Reset buffer" })
          map("n", "<leader>ghp", gs.preview_hunk, { desc = "Preview hunk" })
          map("n", "<leader>ghb", function()
            gs.blame_line({ full = false })
          end, { desc = "Blame line" })
          map("n", "<leader>ghd", gs.diffthis, { desc = "Diff this" })
          map("n", "<leader>ghD", function()
            gs.diffthis("~")
          end, { desc = "Diff this ~" })
        end,
      })
    end,
  },

  {
    "RRethy/vim-illuminate",
    config = function()
      require("illuminate").configure({
        large_file_cutoff = 2000,
        delay = 200,
        large_file_overrides = {
          providers = { "lsp" },
        },
      })

      local function map(key, dir, buffer)
        vim.keymap.set("n", key, function()
          require("illuminate")["goto_" .. dir .. "_reference"](false)
        end, { desc = dir:sub(1, 1):upper() .. dir:sub(2) .. " Reference", buffer = buffer })
      end

      map("]]", "next")
      map("[[", "prev")

      -- also set it after loading ftplugins, since a lot overwrite [[ and ]]
      vim.api.nvim_create_autocmd("FileType", {
        callback = function()
          local buffer = vim.api.nvim_get_current_buf()
          map("]]", "next", buffer)
          map("[[", "prev", buffer)
        end,
      })
    end,
    keys = {
      { "]]", desc = "Next Reference" },
      { "[[", desc = "Prev Reference" },
    },
  },

  {
    "echasnovski/mini.bufremove",
    config = function()
      local bufremove = require("mini.bufremove").delete
      vim.keymap.set("n", "<leader>bd", function()
        if vim.bo.modified then
          local choice = vim.fn.confirm(("Save changes to %q?"):format(vim.fn.bufname()), "&Yes\n&No\n&Cancel")
          if choice == 1 then -- Yes
            vim.cmd.write()
            bufremove(0)
          elseif choice == 2 then -- No
            bufremove(0, true)
          end
        else
          bufremove(0)
        end
      end, { desc = "Delete Buffer" })
      vim.keymap.set("n", "<leader>bD", function()
        bufremove(0, true)
      end, { desc = "Delete Buffer (Force)" })
    end,
  },

  {
    "folke/trouble.nvim",
    cmd = { "TroubleToggle", "Trouble" },
    opts = { use_diagnostic_signs = true },
    keys = {
      { "<leader>xx", "<cmd>TroubleToggle document_diagnostics<cr>", desc = "Document Diagnostics (Trouble)" },
      { "<leader>xX", "<cmd>TroubleToggle workspace_diagnostics<cr>", desc = "Workspace Diagnostics (Trouble)" },
      { "<leader>xL", "<cmd>TroubleToggle loclist<cr>", desc = "Location List (Trouble)" },
      { "<leader>xQ", "<cmd>TroubleToggle quickfix<cr>", desc = "Quickfix List (Trouble)" },
      {
        "[q",
        function()
          if require("trouble").is_open() then
            require("trouble").previous({ skip_groups = true, jump = true })
          else
            local ok, err = pcall(vim.cmd.cprev)
            if not ok then
              vim.notify(err, vim.log.levels.ERROR)
            end
          end
        end,
        desc = "Previous trouble/quickfix item",
      },
      {
        "]q",
        function()
          if require("trouble").is_open() then
            require("trouble").next({ skip_groups = true, jump = true })
          else
            local ok, err = pcall(vim.cmd.cnext)
            if not ok then
              vim.notify(err, vim.log.levels.ERROR)
            end
          end
        end,
        desc = "Next trouble/quickfix item",
      },
    },
  },

  {
    "folke/todo-comments.nvim",
    cmd = { "TodoTrouble", "TodoTelescope" },
    config = true,
    keys = {
      {
        "]t",
        function()
          require("todo-comments").jump_next()
        end,
        desc = "Next todo comment",
      },
      {
        "[t",
        function()
          require("todo-comments").jump_prev()
        end,
        desc = "Previous todo comment",
      },
      { "<leader>xt", "<cmd>TodoTrouble<cr>", desc = "Todo (Trouble)" },
      { "<leader>xT", "<cmd>TodoTrouble keywords=TODO,FIX,FIXME<cr>", desc = "Todo/Fix/Fixme (Trouble)" },
      { "<leader>st", "<cmd>TodoTelescope<cr>", desc = "Todo" },
      { "<leader>sT", "<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>", desc = "Todo/Fix/Fixme" },
    },
  },

  {
    "folke/which-key.nvim",
    opts = {
      window = {
        border = "rounded",
      },
      plugins = { spelling = true },
      defaults = {
        mode = { "n", "v" },
        ["g"] = { name = "+goto" },
        ["]"] = { name = "+next" },
        ["["] = { name = "+prev" },
        ["<leader>b"] = { name = "+buffers" },
        ["<leader>c"] = { name = "+code" },
        ["<leader>f"] = { name = "+find" },
        ["<leader>g"] = { name = "+git" },
        ["<leader>gh"] = { name = "+hunk" },
        ["<leader>h"] = { name = "+harpoon" },
        ["<leader>q"] = { name = "+quit" },
        ["<leader>s"] = { name = "+search" },
        ["<leader>t"] = { name = "+tabs" },
        ["<leader>u"] = { name = "+ui" },
        ["<leader>w"] = { name = "+window" },
        ["<leader>x"] = { name = "+diagnostics/quickfix" },
      },
    },
    config = function(_, opts)
      local wk = require("which-key")
      wk.setup(opts)
      wk.register(opts.defaults)
    end,
  },
}
