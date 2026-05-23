return {
  "rmagatti/auto-session",
  lazy = false,

  ---enables autocomplete for opts
  ---@module "auto-session"
  ---@type AutoSession.Config
  opts = {
    suppressed_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
    cwd_change_handling = true,
    post_cwd_changed_cmds = {
      function()
        require("lualine").refresh()
      end,
    },
    -- single_session_mode = true,
    -- log_level = 'debug',
  },
}
