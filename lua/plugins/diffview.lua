return {
  "sindrets/diffview.nvim",
  -- dependencies = {
  --   "nvim-tree/nvim-web-devicons", -- optional, for file icons
  -- },
  -- Lazy loading: the plugin will only load when one of these commands is called
  cmd = {
    "DiffviewOpen",
    "DiffviewClose",
    "DiffviewToggleFiles",
    "DiffviewFocusFiles",
    "DiffviewRefresh",
    "DiffviewFileHistory",
  },
  -- Custom keybindings integrated into LazyVim's which-key setup
  keys = {
    { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "Diffview Open" },
    { "<leader>gD", "<cmd>DiffviewClose<cr>", desc = "Diffview Close" },
    { "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", desc = "File History (Current)" },
    { "<leader>gH", "<cmd>DiffviewFileHistory<cr>", desc = "File History (Repo)" },
  },
  opts = {
    -- The opts table allows you to override default configurations.
    -- Leaving it empty applies the standard diffview settings.
    view = {
      default = {
        layout = "diff2_horizontal",
      },
      merge_tool = {
        layout = "diff3_horizontal",
        disable_diagnostics = true,
      },
      file_history = {
        layout = "diff2_horizontal",
      },
    },
  },
}
