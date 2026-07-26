-- LazyVim's dap.nlua extra still calls osv.run_this(), removed upstream in
-- 81fa8fe ("feat!: remove `run_this()` as it is confusing and redundant").
-- Rebuild the same behaviour on the public osv.launch() API.
return {
  {
    "jbyuki/one-small-step-for-vimkind",
    lazy = false,
    config = function()
      local dap = require("dap")

      -- Handle of the headless debuggee, so a second run replaces the first.
      local debuggee

      local function start_debuggee(opts)
        if debuggee then
          pcall(vim.fn.jobstop, debuggee)
          debuggee = nil
        end

        local file = vim.fn.expand("%:p")
        local chan = vim.fn.jobstart(
          { vim.v.progpath, "-u", "NONE", "-i", "NONE", "-n", "--embed", "--headless" },
          { rpc = true, clear_env = true }
        )
        if chan <= 0 then
          vim.notify("osv: could not spawn a headless Neovim", vim.log.levels.ERROR)
          return
        end

        vim.fn.rpcrequest(chan, "nvim_exec_lua", "vim.o.runtimepath = ...", { vim.o.runtimepath })
        vim.fn.rpcrequest(chan, "nvim_exec_lua", "vim.o.packpath = ...", { vim.o.packpath })

        if vim.fn.rpcrequest(chan, "nvim_get_mode").blocking then
          vim.fn.jobstop(chan)
          vim.notify("osv: debuggee is waiting for input at startup, aborting", vim.log.levels.ERROR)
          return
        end

        local args = (type(opts) == "table" and not vim.tbl_isempty(opts)) and { opts } or {}
        local server = vim.fn.rpcrequest(chan, "nvim_exec_lua", [[return require("osv").launch(...)]], args)
        if type(server) ~= "table" or not server.port then
          vim.fn.jobstop(chan)
          vim.notify("osv: the debuggee failed to start a DAP server", vim.log.levels.ERROR)
          return
        end
        debuggee = chan

        -- Source the file only once nvim-dap has finished sending breakpoints.
        dap.listeners.after.configurationDone["osv"] = function()
          dap.listeners.after.configurationDone["osv"] = nil
          vim.schedule(function()
            vim.fn.rpcnotify(chan, "nvim_command", "luafile " .. vim.fn.fnameescape(file))
          end)
        end

        return server
      end

      dap.adapters.nlua = function(callback, conf)
        if conf.start_neovim then
          local server = start_debuggee(conf.start_neovim)
          if not server then
            return
          end
          return callback({ type = "server", host = server.host or "127.0.0.1", port = server.port })
        end
        callback({ type = "server", host = conf.host or "127.0.0.1", port = conf.port or 8086 })
      end

      dap.configurations.lua = {
        { type = "nlua", request = "attach", name = "Run this file", start_neovim = {} },
        {
          type = "nlua",
          request = "attach",
          name = "Attach to running Neovim instance (port = 8086)",
          port = 8086,
        },
      }
    end,
  },
  {
    {
      "mfussenegger/nvim-dap",
      dependencies = {
        "jbyuki/one-small-step-for-vimkind",
      },
    },
  },
}
