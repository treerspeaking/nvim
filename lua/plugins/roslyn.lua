return {
  "seblyng/roslyn.nvim",
  event = "VeryLazy",
  ---@module 'roslyn.config'
  ---@type RoslynNvimConfig
  opts = {
    config = {
      settings = {
        ["csharp|navigation"] = {
          dotnet_navigate_to_decompiled_sources = true,
        },
        ["csharp|metadata_as_source"] = {
          dotnet_enable_decompilation = true,
        },
      },
    },
  },
}
