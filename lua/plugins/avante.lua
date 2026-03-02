return {
  "yetone/avante.nvim",
  -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
  -- ⚠️ must add this setting! ! !
  build = vim.fn.has("win32") ~= 0 and "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false"
    or "make",
  event = "VeryLazy",
  version = false, -- Never set this value to "*"! Never!
  ---@module 'avante'
  ---@type avante.Config
  opts = {
    -- add any opts here
    -- this file can contain specific instructions for your project
    instructions_file = "avante.md",
    -- for example
    provider = "copilot",
    selection = {
      enabled = false,
      hint_display = "none",
    },
    -- hint = { enabled = false },
    -- hints = { enabled = false },
    -- selector = {
    --   provider = "telescope",
    --   provider_opts = {},
    -- },
    file_selector = {
      provider = "telescope",
      provider_opts = {},
    },
    -- file_selector = {
    --   provider = "telescope",
    --   provider_opts = {
    --     layout_config = {
    --       width = 0.8,
    --       height = 0.6,
    --     },
    --   },
    -- },
  },
  config = function(_, opts)
    require("avante").setup(opts)
    -- Defer the monkey-patch until after the plugin has initialized its modules
    vim.schedule(function()
      local ok, Sidebar = pcall(require, "avante.sidebar")
      if ok and Sidebar and type(Sidebar.show_input_hint) == "function" then
        local orig_show = Sidebar.show_input_hint
        Sidebar.show_input_hint = function(self, ...)
          vim.schedule(function()
            if self.containers and self.containers.input and vim.api.nvim_win_is_valid(self.containers.input.winid) then
              orig_show(self)
            end
          end)
        end
      end
    end)
  end,
  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    --- The below dependencies are optional,
    "nvim-mini/mini.pick", -- for file_selector provider mini.pick
    "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
    "hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
    "ibhagwan/fzf-lua", -- for file_selector provider fzf
    "stevearc/dressing.nvim", -- for input provider dressing
    "folke/snacks.nvim", -- for input provider snacks
    -- {
    --   "folke/snacks.nvim",
    --   priority = 1000,
    --   lazy = false,
    --   ---@type snacks.Config
    --   opts = {
    --     -- your configuration comes here
    --     -- or leave it empty to use the default settings
    --     -- refer to the configuration section below
    --     bigfile = { enabled = true },
    --     dashboard = { enabled = true },
    --     explorer = { enabled = true },
    --     indent = { enabled = true },
    --     input = { enabled = true },
    --     picker = { enabled = true },
    --     notifier = { enabled = true },
    --     quickfile = { enabled = true },
    --     scope = { enabled = true },
    --     scroll = { enabled = true },
    --     statuscolumn = { enabled = true },
    --     words = { enabled = true },
    --   },
    -- },
    "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
    {
      "zbirenbaum/copilot.lua",
      cmd = "Copilot",
      event = "InsertEnter",
      config = function()
        require("copilot").setup({
          -- crucial: avante needs to know copilot is active
          suggestion = { enabled = false },
          panel = { enabled = false },
        })
      end,
    }, -- for providers='copilot'
    {
      -- support for image pasting
      "HakonHarnes/img-clip.nvim",
      event = "VeryLazy",
      opts = {
        -- recommended settings
        default = {
          embed_image_as_base64 = false,
          prompt_for_file_name = false,
          drag_and_drop = {
            insert_mode = true,
          },
          -- required for Windows users
          use_absolute_path = true,
        },
      },
    },
    {
      -- Make sure to set this up properly if you have lazy=true
      "MeanderingProgrammer/render-markdown.nvim",
      opts = {
        file_types = { "markdown", "Avante" },
      },
      ft = { "markdown", "Avante" },
    },
  },
}
