-- return {}

return {
  "GustavEikaas/easy-dotnet.nvim",
  dependencies = { "nvim-lua/plenary.nvim", "folke/snacks.nvim" },
  event = "VeryLazy",
  lazy = true,
  opts = {
    lsp = {
      enabled = false,
    },
    debugger = {
      bin_path = "/home/treerspeaking/src/CHashTag/sharpdbg/artifacts/bin/SharpDbg.Cli/debug/SharpDbg.Cli",
      engine = "dncdbg",
    },
    test_runner = {
      -- auto_start_testrunner = true,
      neotest_integration = true,
    },
  },
  -- config = function()
  --   require("easy-dotnet").setup()
  -- end,
}
