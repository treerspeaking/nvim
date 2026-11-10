return {
  "okuuva/auto-save.nvim",
  version = "^1.0.0", -- see https://devhints.io/semver, alternatively use '*' to use the latest tagged release
  cmd = "ASToggle", -- optional for lazy loading on command
  event = { "InsertLeave", "TextChanged" }, -- optional for lazy loading on trigger events
  opts = {
    -- your config goes here
    -- or just leave it empty :)
    trigger_events = { -- See :h events
      immediate_save = { "FocusLost", "QuitPre", "VimSuspend" }, -- vim events that trigger an immediate save
      defer_save = { "InsertLeave", "TextChanged", "BufLeave" }, -- vim events that trigger a deferred save (saves after `debounce_delay`)
      cancel_deferred_save = { "InsertEnter" }, -- vim events that cancel a pending deferred save
    },
    noautocmd = true,
    debounce_delay = 3000,
  },
}
