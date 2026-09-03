return {
  -- {
  --   "nsidorenco/neotest-vstest",
  -- },
  -- {
  --   "rcasia/neotest-java",
  --   commit = "78d236da986cca4dd95cb10b1250c4c6e1508240",
  --   ft = "java",
  --   dependencies = {
  --     "mfussenegger/nvim-jdtls",
  --     "mfussenegger/nvim-dap", -- for debugging (optional)
  --     "rcarriga/nvim-dap-ui", -- recommended
  --     "theHamsta/nvim-dap-virtual-text", -- recommended
  --   },
  -- },
  -- {
  --   "nsidorenco/neotest-vstest",
  --   commit = "8588c3c988c7ed49879dddf937b42681cfa7ce30",
  -- },
  {
    "nvim-neotest/neotest",
    lazy = true,
    opts = {
      adapters = {
        ["easy-dotnet.neotest"] = {},
        ["neotest-java"] = {},
        -- ["neotest-vstest"] = {},
      },
    },
  },
}
