return {
  -- 1. Install and initialize the tree view plugin
  -- {
  --   "g0ne150/java-deps.nvim",
  --   commit = "62da2a20fe86e7468d9de6db94ab3d54717639d1",
  --   lazy = true,
  --   {
  --     "mason-org/mason.nvim",
  --     opts = { ensure_installed = { "vscode-java-dependency" } },
  --   },
  -- },

  -- 2. Extend LazyVim's nvim-jdtls configuration
  -- {
  --   "mfussenegger/nvim-jdtls",
  --   lazy = true,
  --   opts = function(_, opts)
  --     -- LazyVim's 'extend_or_override' allows opts.jdtls to be a function
  --     -- that receives the fully built config (including test/debug bundles)
  --     opts.jdtls = function(config)
  --       local mason_registry = require("mason-registry")
  --       local package_installed = mason_registry.is_installed("vscode-java-dependency")
  --
  --       if package_installed then
  --         local java_deps_path = mason_registry.get_package("vscode-java-dependency"):get_install_path()
  --           .. "/extension/server/com.microsoft.jdtls.ext.core-*.jar"
  --         -- glob with list=true returns a lua table of matches
  --         local deps_bundle = vim.fn.glob(java_deps_path, true, true)
  --
  --         if #deps_bundle > 0 then
  --           vim.list_extend(config.init_options.bundles, deps_bundle)
  --         end
  --       end
  --
  --       return config
  --     end
  --
  --     -- Override LazyVim's default Java test keymaps (which use jdtls.dap)
  --     -- back to using neotest, so the debugger UI doesn't open automatically.
  --     opts.on_attach = function(args)
  --       local wk = require("which-key")
  --       wk.add({
  --         {
  --           mode = "n",
  --           buffer = args.buf,
  --           { "<leader>t", group = "test" },
  --           {
  --             "<leader>tt",
  --             function()
  --               require("neotest").run.run(vim.fn.expand("%"))
  --             end,
  --             desc = "Run File (Neotest)",
  --           },
  --           {
  --             "<leader>tr",
  --             function()
  --               require("neotest").run.run()
  --             end,
  --             desc = "Run Nearest (Neotest)",
  --           },
  --           {
  --             "<leader>tT",
  --             function()
  --               require("neotest").run.run(vim.uv.cwd())
  --             end,
  --             desc = "Run All Test Files (Neotest)",
  --           },
  --         },
  --       })
  --     end
  --   end,
  -- },
  {
    "rcasia/neotest-java",
    lazy = true,
    ft = "java",
    dependencies = {
      "mfussenegger/nvim-dap", -- for debugging (optional)
    },
  },
  -- nvim-java handles JDTLS setup separately
  {
    "nvim-java/nvim-java",
    ft = "java",
    config = function()
      require("java").setup()
      vim.lsp.enable("jdtls")
    end,
  },
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
  },
}
