-- return {}

return {
  "seblyng/roslyn.nvim",
  event = "VeryLazy",
  init = function()
    -- Disable autoformat for C# files by default
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "cs",
      callback = function()
        vim.b.autoformat = false
      end,
    })
  end,
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
        ["csharp|symbol_search"] = {
          dotnet_search_reference_assemblies = true,
        },
      },
    },
  },
}
