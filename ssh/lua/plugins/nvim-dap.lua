local function generate_launch_json()
  local dap = require("dap")
  local ft = vim.bo.filetype
  local configs = dap.configurations[ft]

  -- Validate that configurations exist for the current filetype
  if not configs or #configs == 0 then
    vim.notify("No default DAP configs found for filetype: " .. ft, vim.log.levels.WARN)
    return
  end

  -- Prompt the user to select a specific configuration
  vim.ui.select(configs, {
    prompt = "Select a DAP configuration to export to launch.json:",
    format_item = function(config)
      return config.name or "Unnamed Configuration"
    end,
  }, function(selected_config)
    -- Exit if the user aborts the selection menu
    if not selected_config then
      return
    end

    -- Define the target directory and ensure it exists
    local cwd = vim.fn.getcwd()
    local vscode_dir = cwd .. "/.vscode"
    if vim.fn.isdirectory(vscode_dir) == 0 then
      vim.fn.mkdir(vscode_dir, "p")
    end

    local launch_json_path = vscode_dir .. "/launch.json"

    -- Construct the standard launch.json structure
    local launch_data = {
      version = "0.2.0",
      configurations = { selected_config },
    }

    -- Serialize the Lua table to a JSON string
    local json_str = vim.fn.json_encode(launch_data)

    -- Write the JSON data to the file
    local file = io.open(launch_json_path, "w")
    if file then
      file:write(json_str)
      file:close()
      vim.notify("Created " .. launch_json_path, vim.log.levels.INFO)

      -- Open the newly created file in the current window
      vim.cmd("edit " .. launch_json_path)

      -- Format the JSON output (json_encode produces a single line)
      -- This attempts to use python or jq if installed on your system
      if vim.fn.executable("python3") == 1 then
        vim.cmd("silent! %!python3 -m json.tool")
      elseif vim.fn.executable("jq") == 1 then
        vim.cmd("silent! %!jq .")
      else
        vim.notify("Install 'jq' or 'python3' to auto-format the JSON file.", vim.log.levels.WARN)
      end
    else
      vim.notify("Failed to write to " .. launch_json_path, vim.log.levels.ERROR)
    end
  end)
end

-- Map the function to a key combination (e.g., <leader>dl)
-- vim.keymap.set(
--   "n",
--   "<leader>df",
--   generate_launch_json,
--   { noremap = true, silent = true, desc = "Generate launch.json from active DAP config" }
-- )

return {
  "mfussenegger/nvim-dap",
  recommended = true,
  desc = "Debugging support. Requires language specific adapters to be configured. (see lang extras)",

  dependencies = {
    "rcarriga/nvim-dap-ui",
    -- virtual text for the debugger
    {
      "theHamsta/nvim-dap-virtual-text",
      opts = {},
    },
    "mfussenegger/nvim-dap-python",
  },

  -- stylua: ignore
  keys = {
    { "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, desc = "Breakpoint Condition" },
    { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint" },
    { "<leader>dc", function() require("dap").continue() end, desc = "Run/Continue" },
    { "<leader>da", function() require("dap").continue({ before = get_args }) end, desc = "Run with Args" },
    { "<leader>dC", function() require("dap").run_to_cursor() end, desc = "Run to Cursor" },
    { "<leader>dg", function() require("dap").goto_() end, desc = "Go to Line (No Execute)" },
    { "<leader>dj", function() require("dap").down() end, desc = "Down" },
    { "<leader>dk", function() require("dap").up() end, desc = "Up" },
    { "<leader>dl", function() require("dap").run_last() end, desc = "Run Last" },
    { "<leader>dP", function() require("dap").pause() end, desc = "Pause" },
    { "<leader>dr", function() require("dap").repl.toggle() end, desc = "Toggle REPL" },
    { "<leader>ds", function() require("dap").session() end, desc = "Session" },
    { "<leader>dt", function() require("dap").terminate() end, desc = "Terminate" },
    { "<leader>dw", function() require("dap.ui.widgets").hover() end, desc = "Widgets" },
    { "<F10>", function() require("dap").step_over() end, desc = "Step Over" },
    { "<F11>", function() require("dap").step_into() end, desc = "Step Into" },
    { "<S-F11>", function() require("dap").step_out() end, desc = "Step Out" },
    { "<F5>", function() require("dap").continue() end, desc = "Run/Continue" },
    {"<leader>df", generate_launch_json, mode = "n", desc = "Generate launch.json"}
  },
  opts = function(_, opts)
    --   -- load mason-nvim-dap here, after all adapters have been setup
    --   if LazyVim.has("mason-nvim-dap.nvim") then
    --     require("mason-nvim-dap").setup({
    --       -- Makes a best effort to setup the various debuggers with
    --       -- reasonable debug configurations
    --       automatic_setup = true,
    --       automatic_installation = true,
    --
    --       -- You can provide additional configuration to the handlers,
    --       -- see mason-nvim-dap README for more information
    --       handlers = {},
    --
    --       -- You'll need to check that you have the required things installed
    --       -- online, please don't ask me how to install them :)
    --       ensure_installed = {
    --         -- Update this to ensure that you have the debuggers for the langs you want
    --         -- 'delve',
    --         "debugpy",
    --         "js-debug-adapter",
    --       },
    --     })
    --   end
    --
    --   local dap = require("dap")
    --
    --   dap.set_log_level("TRACE")
    --
    --   -- if not dap.adapters["pwa-node"] then
    --   --   dap.adapters["pwa-node"] = {
    --   --     type = "server",
    --   --     host = "localhost",
    --   --     port = "${port}",
    --   --     executable = {
    --   --       command = "node",
    --   --       args = {
    --   --         vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js",
    --   --         "${port}",
    --   --       },
    --   --     },
    --   --   }
    --   -- end
    --   --
    --   -- -- Adapter for Chrome (points to the exact same server)
    --   -- if not dap.adapters["pwa-chrome"] then
    --   --   dap.adapters["pwa-chrome"] = {
    --   --     type = "server",
    --   --     host = "localhost",
    --   --     port = "${port}",
    --   --     executable = {
    --   --       command = "node",
    --   --       args = {
    --   --         vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js",
    --   --         "${port}",
    --   --       },
    --   --     },
    --   --   }
    --   -- end
    --   if not dap.adapters["node"] then
    --     dap.adapters["node"] = {
    --       type = "server",
    --       host = "localhost",
    --       port = "${port}",
    --       executable = {
    --         command = "node",
    --         args = {
    --           vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js",
    --           "${port}",
    --         },
    --       },
    --     }
    --   end
    --
    --   -- Adapter for Chrome (points to the exact same server)
    --   if not dap.adapters["chrome"] then
    --     dap.adapters["chrome"] = {
    --       type = "server",
    --       host = "localhost",
    --       port = "${port}",
    --       executable = {
    --         command = "node",
    --         args = {
    --           vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js",
    --           "${port}",
    --         },
    --       },
    --     }
    --   end
    --
    --   for _, language in ipairs({ "typescript", "javascript", "typescriptreact", "javascriptreact" }) do
    --     dap.configurations[language] = {
    --       {
    --         type = "node",
    --         request = "launch",
    --         name = "Launch file",
    --         program = "${file}",
    --         cwd = "${workspaceFolder}",
    --       },
    --       {
    --         type = "node",
    --         request = "attach",
    --         name = "Attach",
    --         processId = require("dap.utils").pick_process,
    --         cwd = "${workspaceFolder}",
    --       },
    --       {
    --         type = "chrome",
    --         request = "launch",
    --         name = "Launch file chrome",
    --         url = "http://localhost:3000",
    --         webroot = "${workspaceFolder}",
    --         program = "${file}",
    --       },
    --       {
    --         type = "chrome",
    --         request = "attach",
    --         name = "Attach chrome",
    --         port = 9222,
    --         webroot = "${workspaceFolder}",
    --       },
    --     }
    --   end
    --   vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })
    --
    --   for name, sign in pairs(LazyVim.config.icons.dap) do
    --     sign = type(sign) == "table" and sign or { sign }
    --     vim.fn.sign_define(
    --       "Dap" .. name,
    --       { text = sign[1], texthl = sign[2] or "DiagnosticInfo", linehl = sign[3], numhl = sign[3] }
    --     )
    --   end
    --
    --   -- setup dap config by VsCode launch.json file
    --   local vscode = require("dap.ext.vscode")
    --   local json = require("plenary.json")
    --   vscode.json_decode = function(str)
    --     return vim.json.decode(json.json_strip_comments(str))
    --   end
    --   -- dap.listeners.after.event_initialized["set_exception_breakpoints"] = function()
    --   --   dap.set_exception_breakpoints({ "uncaught", "userUnhandled" })
    --   -- end
    --   -- dap.defaults.fallback.exception_breakpoints = { "uncaught", "userUnhandled" }
    local dap = require("dap")
    -- dap.defaults.python.exception_breakpoints = { "uncaught", "userUnhandled" }
    dap.defaults.python.exception_breakpoints = { "uncaught" }
    dap.defaults["node"].exception_breakpoints = { "uncaught", "all" }
    dap.defaults["chrome"].exception_breakpoints = { "uncaught", "all" }
    return opts
  end,
}
