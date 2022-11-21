return {
  n = {
    ["<leader>h"] = false,

    ["<leader>d"] = false,

    ["<leader>gg"] = false,

    ["<leader>tl"] = false,

    -- easy splits
    ["\\"] = { "<cmd>split<cr>", desc = "Horizontal split" },
    ["|"] = { "<cmd>vsplit<cr>", desc = "Vertical split" },
  }
}
