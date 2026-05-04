return {
  {
    "catppuccin/nvim",
    lazy = true,
    name = "catppuccin",
    opts = {
      flavour = "mocha",
      lsp_styles = {
        underlines = {
          errors = { "undercurl" },
          hints = { "undercurl" },
          warnings = { "undercurl" },
          information = { "undercurl" },
        },
      },

      auto_integrations = true,
      integrations = {
        aerial = true,
        alpha = true,
        cmp = true,
        dashboard = true,
        flash = true,
        fzf = true,
        grug_far = true,
        gitsigns = true,
        headlines = true,
        illuminate = true,
        indent_blankline = { enabled = true },
        leap = true,
        lsp_trouble = true,
        mason = true,
        mini = true,
        navic = { enabled = true, custom_bg = "lualine" },
        neotest = true,
        neotree = true,
        noice = true,
        notify = true,
        snacks = true,
        telescope = true,
        treesitter_context = true,
        which_key = true,
      },
    },
    specs = {
      {
        "akinsho/bufferline.nvim",
        optional = true,
        opts = function(_, opts)
          if (vim.g.colors_name or ""):find("catppuccin") then
            opts.highlights = require("catppuccin.special.bufferline").get_theme()
          end
        end,
      },
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin-mocha",
    },
  },
}
-- return {
--   -- Step 1: Install and configure the Catppuccin plugin
--   {
--     "catppuccin/nvim",
--     name = "catppuccin",
--     priority = 1000, -- Ensures the colorscheme loads before other plugins
--     opts = {
--       flavour = "mocha", -- Options: latte, frappe, macchiato, mocha
--       transparent_background = false,
--       term_colors = true,
--       integrations = {
--         alpha = true,
--         cmp = true,
--         flash = true,
--         gitsigns = true,
--         illuminate = true,
--         indent_blankline = { enabled = true },
--         lsp_trouble = true,
--         mason = true,
--         mini = true,
--         native_lsp = {
--           enabled = true,
--           underlines = {
--             errors = { "undercurl" },
--             hints = { "undercurl" },
--             warnings = { "undercurl" },
--             information = { "undercurl" },
--           },
--         },
--         navic = { enabled = true, custom_bg = "lualine" },
--         neotest = true,
--         noice = true,
--         notify = true,
--         semantic_tokens = true,
--         telescope = true,
--         treesitter = true,
--         which_key = true,
--       },
--     },
--   },

--   -- Step 2: Override the default LazyVim colorscheme
--   {
--     "LazyVim/LazyVim",
--     opts = {
--       colorscheme = "catppuccin",
--     },
--   },
-- }
