return {
  "ekickx/clipboard-image.nvim",
  init = function()
    -- Workaround for neovim 0.10+ where 'health' module is removed
    if not package.loaded["health"] then
      package.loaded["health"] = vim.health
    end
  end,
  opts = {},
  keys = {
    { "<leader>p", "<cmd>PasteImg<CR>", mode = { "n" }, { noremap = true, silent = true } },
  },
}
