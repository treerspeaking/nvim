return { -- The task runner we use
  "stevearc/overseer.nvim",
  -- commit = "6271cab7ccc4ca840faa93f54440ffae3a3918bd",
  cmd = { "CompilerOpen", "CompilerToggleResults", "CompilerRedo", "OverseerRun", "OverseerToggle" },
  opts = {
    task_list = {
      direction = "bottom",
      min_height = 25,
      max_height = 25,
      default_detail = 1,
    },
  },
  keys = {
    { "<leader>oo", "<cmd>OverseerToggle!<cr>", desc = "OverseerToggle" },
    { "<leader>or", "<cmd>OverseerRun<cr>", desc = "OverseerRun" },
    -- { "<leader>oo", false }, -- unbind <leader>oo bind
  },
  config = function(_, opts)
    require("overseer").setup(opts)
    require("overseer").register_template({
      name = "Build and run current file",
      builder = function()
        local file = vim.fn.expand("%:p")
        local filename_noext = vim.fn.expand("%:t:r")
        local outdir = vim.fn.getcwd() .. "/bin"
        local outfile = outdir .. "/" .. filename_noext
        local mkdir_cmd = "mkdir -p " .. vim.fn.shellescape(outdir) .. " && "
        local ft = vim.bo.filetype
        local cmd = { "echo", "Unsupported filetype: " .. ft }

        if ft == "cpp" then
          local cpp_outfile = outfile .. ".out"
          cmd = {
            "bash",
            "-c",
            mkdir_cmd .. "g++ -g -O0 -std=c++23 " .. vim.fn.shellescape(file) .. " -o " .. vim.fn.shellescape(
              cpp_outfile
            ) .. " && " .. vim.fn.shellescape(cpp_outfile),
          }
        elseif ft == "c" then
          cmd = {
            "bash",
            "-c",
            mkdir_cmd
              .. "gcc -g "
              .. vim.fn.shellescape(file)
              .. " -o "
              .. vim.fn.shellescape(outfile)
              .. " && "
              .. vim.fn.shellescape(outfile),
          }
        elseif ft == "python" then
          cmd = { "python3", file }
        elseif ft == "go" then
          cmd = {
            "bash",
            "-c",
            mkdir_cmd
              .. "go build -o "
              .. vim.fn.shellescape(outfile)
              .. " "
              .. vim.fn.shellescape(file)
              .. " && "
              .. vim.fn.shellescape(outfile),
          }
        elseif ft == "javascript" then
          cmd = { "node", file }
        elseif ft == "rust" then
          cmd = {
            "bash",
            "-c",
            mkdir_cmd
              .. "rustc -g "
              .. vim.fn.shellescape(file)
              .. " -o "
              .. vim.fn.shellescape(outfile)
              .. " && "
              .. vim.fn.shellescape(outfile),
          }
        elseif ft == "lua" then
          cmd = { "lua", file }
        elseif ft == "sh" or ft == "bash" then
          cmd = { "bash", file }
        end

        return {
          cmd = cmd,
          components = { "default", "on_output_quickfix", "on_result_diagnostics" },
        }
      end,
      condition = {
        filetype = { "c", "cpp", "python", "go", "javascript", "rust", "lua", "sh", "bash" },
      },
    })
  end,
}
