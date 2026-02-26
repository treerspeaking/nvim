-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
--
-- vim.keymap.del("n", "<C-/>")
-- Remove the default LazyVim terminal toggle mapped to <C-/>
-- pcall(vim.keymap.del, { "n", "t" }, "<c-/>")
-- pcall(vim.keymap.del, { "n", "t" }, "<c-_>")
-- vim.keymap.del({ "n", "i", "v" }, "<F1>")
--
local map = LazyVim.safe_keymap_set
-- vim.keymap.del("n", "<F1>", { silent = true })
map("x", "<C-j>", "<Esc>", { desc = "switch mode to Normal: Ctrl + J" })
map("v", "<C-j", "<Esc>", { desc = "switch mode to Normal: Ctrl + J" })

map({ "n", "v" }, "d", '"_d', { desc = "Delete (no clipboard)" })
map({ "n", "v" }, "D", '"_D', { desc = "Delete to line end (no clipboard)" })
map({ "n", "x" }, ";", "$", { desc = "To End of line" })
map({ "n", "x" }, "f", "^", { desc = "Jump to first non-blank" })
