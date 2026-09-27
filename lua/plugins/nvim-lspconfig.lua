return {
  {
    "neovim/nvim-lspconfig",
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
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      -- Let clangd build/resolve C++20 named modules such as `import std;`
      -- fkin AI

      local clangd = opts.servers.clangd
      if clangd and clangd.cmd and not vim.tbl_contains(clangd.cmd, "--experimental-modules-support") then
        table.insert(clangd.cmd, "--experimental-modules-support") -- Add Modules support
      end
    end,
  },
}
