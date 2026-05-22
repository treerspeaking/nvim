-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
--
-- vim.o.tabstop = 4 -- Number of spaces a tab counts for
-- vim.o.softtabstop = 4 -- Number of spaces for a tab during editing
-- vim.o.shiftwidth = 4 -- Number of spaces for each indent level
vim.o.expandtab = true -- Convert tabs to spaces

-- Use OSC 52 for clipboard synchronization over SSH
vim.opt.clipboard = "unnamedplus"
vim.g.clipboard = {
  name = 'OSC 52',
  copy = {
    ['+'] = require('vim.ui.clipboard.osc52').copy('+'),
    ['*'] = require('vim.ui.clipboard.osc52').copy('*'),
  },
  paste = {
    ['+'] = require('vim.ui.clipboard.osc52').paste('+'),
    ['*'] = require('vim.ui.clipboard.osc52').paste('*'),
  },
}
