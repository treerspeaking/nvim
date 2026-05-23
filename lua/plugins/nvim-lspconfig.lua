return {
  {
    "neovim/nvim-lspconfig",
    event = "VeryLazy",
    opts = {
      servers = {
        lemminx = {}, -- For XML
        -- roslyn = {
        --   settings = {
        --     ["csharp|metadata_as_source"] = {
        --       dotnet_enable_decompilation = true,
        --     },
        --   },
        -- },
        -- omnisharp = {
        --   settings = {
        --     RoslynExtensionsOptions = {
        --       EnableDecompilationSupport = true,
        --     },
        --   },
        -- },
      },
    },
  },
}
