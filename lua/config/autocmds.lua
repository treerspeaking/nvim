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
  callback = function(args)
    -- sidekick.nvim runs AI CLIs in terminals; don't type into their prompt
    if vim.b[args.buf].sidekick_cli or vim.bo[args.buf].filetype == "sidekick_terminal" then
      return
    end

    local venv_selector = require("venv-selector")
    local current_venv = venv_selector.venv()

    if current_venv ~= nil and current_venv ~= "" then
      local env_name = vim.fn.fnamemodify(current_venv, ":t")

      local command
      if venv_selector.source() == "workspace" then
        command = string.format("source %s/bin/activate\r", env_name)
      else
        command = string.format("conda activate %s\r", env_name)
      end

      local term_chan = vim.b[args.buf].terminal_job_id

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

local delayed_format_group = vim.api.nvim_create_augroup("DelayedFormat", { clear = true })

local function check_format_condition(buf)
  if not vim.api.nvim_buf_is_valid(buf) then
    return false
  end

  -- Ignore special buffers (like neo-tree, terminal) or unmodifiable buffers
  if vim.bo[buf].buftype ~= "" or not vim.bo[buf].modifiable then
    return false
  end

  -- Check if formatting is currently enabled via <leader>uf toggle
  local ok, format_enabled = pcall(function()
    return require("lazyvim.util").format.enabled(buf)
  end)
  if not ok or not format_enabled then
    return false
  end

  return true
end

local function do_format(buf)
  if not check_format_condition(buf) then
    return
  end

  -- Call LazyVim's format without force=true so it doesn't warn if no formatter exists
  pcall(function()
    require("lazyvim.util").format.format({ buf = buf })
  end)

  -- Save the formatting changes silently without triggering autocmds again
  -- only if the buffer was actually modified (e.g. by the formatter)
  if vim.bo[buf].modified then
    vim.api.nvim_buf_call(buf, function()
      vim.cmd("silent! noautocmd write")
    end)
  end
end

-- auto format after 30 seconds if the uf is on
vim.api.nvim_create_autocmd({ "BufWritePost", "InsertEnter", "InsertLeave", "TextChanged", "TextChangedI" }, {
  group = delayed_format_group,
  callback = function(args)
    local buf = args.buf

    if not check_format_condition(buf) then
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
      30000, -- Timer changes
      0,
      vim.schedule_wrap(function()
        -- Cleanup the timer reference
        if _G._delayed_format_timers[buf] == timer then
          _G._delayed_format_timers[buf] = nil
        end
        if not timer:is_closing() then
          timer:close()
        end

        do_format(buf)
      end)
    )
  end,
})

-- Format immediately if we leave the buffer/vim and a timer is active
-- vim.api.nvim_create_autocmd({ "BufDelete", "BufUnload", "QuitPre" }, {
--   group = delayed_format_group,
--   callback = function(args)
--     local buf = args.buf
--     local timer = _G._delayed_format_timers[buf]
--     if timer then
--       timer:stop()
--       if not timer:is_closing() then
--         timer:close()
--       end
--       _G._delayed_format_timers[buf] = nil
--       do_format(buf)
--     end
--   end,
-- })
--
vim.api.nvim_create_autocmd({ "BufDelete", "QuitPre" }, {
  group = delayed_format_group,
  callback = function(args)
    local buf = args.buf
    local timer = _G._delayed_format_timers[buf]
    if timer then
      timer:stop()
      if not timer:is_closing() then
        timer:close()
      end
      _G._delayed_format_timers[buf] = nil
      do_format(buf)
    end
  end,
})

-- Format all buffers with pending timers before exiting Vim
vim.api.nvim_create_autocmd("VimLeavePre", {
  group = delayed_format_group,
  callback = function()
    for buf, timer in pairs(_G._delayed_format_timers) do
      if timer then
        timer:stop()
        if not timer:is_closing() then
          timer:close()
        end
        _G._delayed_format_timers[buf] = nil
        do_format(buf)
      end
    end
  end,
})
