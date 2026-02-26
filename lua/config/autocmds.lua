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
