return {
  "mateuszsip/sidekick.nvim",
  branch = "feat/agy-cli",
  commit = "8350ac42bff9fe9afdcd0438534010ac97739dd1",
  name = "sidekick.nvim",
  event = "VeryLazy",
  opts = {
    nes = {
      enabled = false,
    },
    cli = {
      tools = {
        antigravity = {
          native_scroll = true,
        },
      },
      win = {
        config = function(terminal)
          -- 1. Disable the scrollback snapshot feature globally to prevent TUI flashing and forced scrolling
          require("sidekick.cli.scrollback").is_enabled = function()
            return false
          end

          -- 2. Prevent the initial `startinsert` when Sidekick toggles open
          local orig_focus = terminal.focus
          terminal.focus = function(self)
            orig_focus(self)
            self.normal_mode = true
            vim.schedule(function()
              vim.cmd("stopinsert")
            end)
            return self
          end

          -- 3. Prevent Sidekick's buggy mode-tracking from forcing `startinsert` when navigating windows
          local orig_start = terminal.start
          terminal.start = function(self)
            local orig_create_autocmd = vim.api.nvim_create_autocmd
            vim.api.nvim_create_autocmd = function(event, opts)
              -- Skip the buggy TermLeave/TermEnter mode tracking autocommand
              if
                type(event) == "table"
                and event[1] == "TermLeave"
                and event[2] == "TermEnter"
                and opts.group == self.group
              then
                return
              end
              -- Skip the WinEnter mode restoring autocommand
              if event == "WinEnter" and type(event) == "string" and opts.group == self.group then
                return
              end
              return orig_create_autocmd(event, opts)
            end

            orig_start(self)

            vim.api.nvim_create_autocmd = orig_create_autocmd

            vim.schedule(function()
              vim.cmd("wincmd =")
            end)
          end
        end,
      },
    },
  }, -- stylua: ignore
  keys = {
    -- nes is also useful in normal mode
    { "<tab>", LazyVim.cmp.map({ "ai_nes" }, "<tab>"), mode = { "n" }, expr = true },
    { "<leader>a", "", desc = "+ai", mode = { "n", "v" } },
    {
      "<c-.>",
      function()
        require("sidekick.cli").toggle()
      end,
      desc = "Sidekick Toggle",
      mode = { "n", "t", "i", "x" },
    },
    {
      "<leader>aa",
      function()
        require("sidekick.cli").toggle()
      end,
      desc = "Sidekick Toggle CLI",
    },
    {
      "<leader>as",
      function()
        require("sidekick.cli").select()
      end,
      -- Or to select only installed tools:
      -- require("sidekick.cli").select({ filter = { installed = true } })
      desc = "Select CLI",
    },
    {
      "<leader>ad",
      function()
        require("sidekick.cli").close()
      end,
      desc = "Detach a CLI Session",
    },
    {
      "<leader>at",
      function()
        require("sidekick.cli").send({ msg = "{this}" })
      end,
      mode = { "x", "n" },
      desc = "Send This",
    },
    {
      "<leader>af",
      function()
        require("sidekick.cli").send({ msg = "{file}" })
      end,
      desc = "Send File",
    },
    {
      "<leader>av",
      function()
        require("sidekick.cli").send({ msg = "{selection}" })
      end,
      mode = { "x" },
      desc = "Send Visual Selection",
    },
    {
      "<leader>ap",
      function()
        require("sidekick.cli").prompt()
      end,
      mode = { "n", "x" },
      desc = "Sidekick Select Prompt",
    },
    {
      "<C-v>",
      function()
        local handle = io.popen("ls -t ~/Pictures/*.png 2>/dev/null | head -n 1")
        if handle then
          local result = handle:read("*a"):gsub("%s+", "")
          handle:close()
          if result ~= "" then
            if vim.bo.buftype == "terminal" then
              vim.api.nvim_chan_send(vim.b.terminal_job_id, result)
            else
              vim.fn.setreg("+", result)
              vim.notify("Copied " .. result .. " to clipboard")
            end
          else
            vim.notify("No screenshots found in ~/picture", vim.log.levels.WARN)
          end
        end
      end,
      mode = { "t" },
      desc = "Paste latest screenshot",
    },
  },
}
