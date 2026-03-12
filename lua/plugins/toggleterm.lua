return {
  "akinsho/toggleterm.nvim",
  version = "*",
  config = function(_, opts)
    require("toggleterm").setup(opts)
    vim.keymap.set(
      "n",
      "<leader>t",
      '<Cmd>execute v:count . "ToggleTerm"<CR>',
      { noremap = true, desc = "Toggle Terminal" }
    )
    vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], { noremap = true, desc = "Move to left window" })
    vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], { noremap = true, desc = "Move to down window" })
    vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], { noremap = true, desc = "Move to up window" })
    vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], { noremap = true, desc = "Move to right window" })
    -- vim.keymap.set(
    --   "t",
    --   "<space>ft",
    --   '<Cmd>execute v:count . "ToggleTerm"<CR>',
    --   { noremap = true, desc = "Toggle Terminal" }
    -- )
    --    vim.keymap.set(
    --      { "n", "t" },
    --      "<C-_>",
    --      "<Cmd>execute v:count . 'ToggleTerm'<CR>",
    --      { noremap = true, desc = "Toggle Terminal" }
    --    )
  end,
}
--
--return {}
