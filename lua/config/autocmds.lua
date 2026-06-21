-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")
vim.api.nvim_create_autocmd("TermOpen", {
  pattern = "*",
  callback = function()
    local venv_selector = require("venv-selector")
    local current_venv = venv_selector.venv()

    if current_venv ~= nil and current_venv ~= "" then
      local env_name = vim.fn.fnamemodify(current_venv, ":t")

      local command = string.format("conda activate %s\r", env_name)
      local term_buf = vim.api.nvim_get_current_buf()
      local term_chan = vim.api.nvim_buf_get_var(term_buf, "terminal_job_id")

      if term_chan then
        vim.api.nvim_chan_send(term_chan, command)
        vim.api.nvim_chan_send(term_chan, "clear\r")
      end
    end
  end,
})

-- Delete LazyVim's default BufWritePre formatting hook so it doesn't run instantly
-- We use vim.schedule to ensure this runs after LazyVim finishes creating it
vim.schedule(function()
  pcall(vim.api.nvim_del_augroup_by_name, "LazyFormat")
end)

-- Global table to keep track of formatting timers per buffer
_G._delayed_format_timers = _G._delayed_format_timers or {}

-- auto format after 1 minutes if the uf is on
vim.api.nvim_create_autocmd({ "BufWritePost", "InsertEnter", "InsertLeave", "TextChanged", "TextChangedI" }, {
  group = vim.api.nvim_create_augroup("DelayedFormat", { clear = true }),
  callback = function(args)
    local buf = args.buf

    -- Check if formatting is currently enabled via <leader>uf toggle
    local ok, format_enabled = pcall(function()
      return require("lazyvim.util").format.enabled(buf)
    end)
    if not ok or not format_enabled then
      return
    end

    -- Cancel the existing timer for this buffer if a new save happens
    if _G._delayed_format_timers[buf] then
      _G._delayed_format_timers[buf]:stop()
      if not _G._delayed_format_timers[buf]:is_closing() then
        _G._delayed_format_timers[buf]:close()
      end
    end

    local uv = vim.uv or vim.loop
    local timer = uv.new_timer()
    _G._delayed_format_timers[buf] = timer

    timer:start(
      5000,
      0,
      vim.schedule_wrap(function()
        -- Cleanup the timer reference
        if _G._delayed_format_timers[buf] == timer then
          _G._delayed_format_timers[buf] = nil
        end
        if not timer:is_closing() then
          timer:close()
        end

        if vim.api.nvim_buf_is_valid(buf) then
          -- Call LazyVim's format with force=true so it uses your configured formatters
          pcall(function()
            require("lazyvim.util").format.format({ buf = buf, force = true })
          end)

          -- Save the formatting changes silently without triggering autocmds again
          vim.api.nvim_buf_call(buf, function()
            vim.cmd("silent! noautocmd write")
          end)
        end
      end)
    )
  end,
})
