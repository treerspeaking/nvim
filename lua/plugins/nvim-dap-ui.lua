return {
  {
    "rcarriga/nvim-dap-ui",
    event = "VeryLazy",
    keys = {
      {
        "<leader>du",
        function()
          require("dapui").toggle({ reset = true })
        end,
        desc = "Dap UI",
      },
      {
        "<leader>dw",
        function()
          require("dapui").elements.watches.add(vim.fn.expand("<cword>"))
        end,
        desc = "Add to Watches",
      },
    },
    opts = {
      element_mappings = {
        stacks = {
          open = "g<CR>",
          expand = "o",
        },
      },
    },
    config = function(_, opts)
      local dap = require("dap")
      local dapui = require("dapui")

      -- Apply the default options passed down by LazyVim
      dapui.setup(opts)

      vim.api.nvim_create_autocmd("FileType", {
        pattern = "dapui_stacks",
        callback = function()
          vim.keymap.set(
            "n",
            "<CR>",
            "g<CR><C-w>p",
            { buffer = true, remap = true, desc = "Open stack frame and keep focus" }
          )
        end,
      })

      -- Retain the automatic opening behavior when a debugging session starts
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
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
