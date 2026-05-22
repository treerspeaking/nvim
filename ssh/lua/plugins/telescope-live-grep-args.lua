return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      {
        "nvim-telescope/telescope-live-grep-args.nvim",
        -- This will not install any breaking changes.
        version = "^1.1.0",
      },
    },
    config = function(_, opts)
      local telescope = require("telescope")

      -- LazyVim passes its default configuration via 'opts'
      -- We merge or extend that configuration here
      telescope.setup(opts)

      -- Load the extension after setup
      telescope.load_extension("live_grep_args")
    end,
    keys = {
      {
        "<leader>fl",
        function()
          require("telescope").extensions.live_grep_args.live_grep_args()
        end,
        desc = "Find Live Grep with Args",
      },
    },
  },
}

-- return {}
