return {
  {
    "rcarriga/nvim-dap-ui",
    config = function(_, opts)
      local dap = require("dap")
      local dapui = require("dapui")

      -- Apply the default options passed down by LazyVim
      dapui.setup(opts)

      -- Retain the automatic opening behavior when a debugging session starts
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open({})
      end

      -- The default LazyVim configuration includes the following listeners which cause the auto-close behavior.
      -- By completely overriding the config function and omitting them here, the UI will remain open.

      -- dap.listeners.before.event_terminated["dapui_config"] = function()
      --   dapui.close({})
      -- end

      -- dap.listeners.before.event_exited["dapui_config"] = function()
      --   dapui.close({})
      -- end
    end,
  },
}
