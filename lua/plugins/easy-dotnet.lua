-- return {}

return {
  "GustavEikaas/easy-dotnet.nvim",
  dependencies = { "nvim-lua/plenary.nvim", "folke/snacks.nvim" },
  opts = {
    lsp = {
      enabled = false,
    },
  },
  -- config = function()
  --   require("easy-dotnet").setup()
  -- end,
}
