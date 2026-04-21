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
vim.keymap.set("x", "<C-j>", "<Esc>", { desc = "switch mode to Normal: Ctrl + J" })
vim.keymap.set("v", "<C-j", "<Esc>", { desc = "switch mode to Normal: Ctrl + J" })
-- vim.keymap.set("t", "<C-j>", [[<C-\><C-n>]], { desc = "Switch mode to Normal" })
vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { desc = "Exit terminal mode with Escape" })
vim.keymap.set({ "n", "v" }, "d", '"_d', { desc = "Delete (no clipboard)" })
vim.keymap.set({ "n", "v" }, "D", '"_D', { desc = "Delete to line end (no clipboard)" })
vim.keymap.set({ "n", "x" }, ";", "$", { desc = "To End of line" })
vim.keymap.set({ "n", "x" }, "f", "^", { desc = "Jump to first non-blank" })
vim.keymap.set("n", "<C-e>", "<C-e>j", { desc = "Scroll down and move cursor down" })
vim.keymap.set("n", "<C-y>", "<C-y>k", { desc = "Scroll up and move cursor up" })
vim.keymap.set("n", "<C-q>", "<C-y>k", { desc = "Scroll up and move cursor up" })

-- Scroll with Shift + Arrow keys
-- We use pcall(vim.keymap.del, ...) to ensure any existing mappings are removed first if they exist
pcall(vim.keymap.del, "n", "<S-Down>")
pcall(vim.keymap.del, "n", "<S-Up>")
pcall(vim.keymap.del, "i", "<S-Down>")
pcall(vim.keymap.del, "i", "<S-Up>")
pcall(vim.keymap.del, "v", "<S-Down>")
pcall(vim.keymap.del, "v", "<S-Up>")

vim.keymap.set("n", "<S-Down>", "<C-e>j", { desc = "Scroll down and move cursor down" })
vim.keymap.set("n", "<S-Up>", "<C-y>k", { desc = "Scroll up and move cursor up" })
-- vim.keymap.set("n", "<C-Down>", "<C-e>j", { desc = "Scroll down and move cursor down" })
-- vim.keymap.set("n", "<C-Up>", "<C-y>k", { desc = "Scroll up and move cursor up" })

-- Optional: Remove the residual visual mode mapping from LazyVim
pcall(vim.keymap.del, "v", "<C-q>")
-- map("t", "<space>ft", '<Cmd>execute v:count . "ToggleTerm"<CR>', { noremap = true, desc = "Toggle Terminal" })
