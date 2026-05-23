-- return {}

return {
  "GustavEikaas/easy-dotnet.nvim",
  dependencies = { "nvim-lua/plenary.nvim", "folke/snacks.nvim" },
  event = "VeryLazy",
  opts = {
    lsp = {
      enabled = false,
    },
  },
  -- config = function()
  --   require("easy-dotnet").setup()
  -- end,
}
