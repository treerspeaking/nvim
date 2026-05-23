return {
  {
    "mason-org/mason.nvim",
    event = "VeryLazy",
    opts = {
      registries = {
        "github:mason-org/mason-registry",
        "github:Crashdummyy/mason-registry",
      },
      ensure_installed = { "roslyn", "html-lsp" },

    },
  },
}
