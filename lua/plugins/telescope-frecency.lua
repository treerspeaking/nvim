return {
  "nvim-telescope/telescope-frecency.nvim",
  -- install the latest stable version
  version = "*",
  config = function()
    require("telescope").load_extension("frecency")
  end,
  keys = {
    {
      "<leader>fr",
      "<cmd>Telescope frecency<cr>",
      desc = "Telescope Frecency",
    },
  },
}
