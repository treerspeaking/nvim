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

    local function sanitize(tbl)
      local res = {}
      for k, v in pairs(tbl) do
        if type(v) == "table" then
          res[k] = sanitize(v)
        elseif type(v) == "function" then
          res[k] = "<function>"
        else
          res[k] = v
        end
      end
      return res
    end

    -- Construct the standard launch.json structure
    local launch_data = {
      version = "0.2.0",
      configurations = { sanitize(selected_config) },
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
  event = "VeryLazy",
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
    { "<leader>dhb", function() require("dap").set_breakpoint(nil ,vim.fn.input('Hit condition: ')) end, desc = "Breakpoint Hit Condition" },
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
    local dap = require("dap")
    -- dap.defaults.python.exception_breakpoints = { "uncaught", "userUnhandled" }
    dap.defaults.python.exception_breakpoints = { "uncaught" }
    dap.defaults["node"].exception_breakpoints = { "uncaught", "all" }
    dap.defaults["chrome"].exception_breakpoints = { "uncaught", "all" }
    return opts
  end,
}
