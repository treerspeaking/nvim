-- if true then
--  return {}
-- end

return {
  "folke/snacks.nvim",
  opts = {
    terminal = { enabled = false },
    picker = {
      ignored = true,
      sources = {
        files = { hidden = true },
        grep = { hidden = true },
        explorer = { hidden = true },
      },
    },
  },
  keys = {
    { "\\", "<leader>fe", desc = "Explorer NeoTree (Root Dir)", remap = true },
    term_terminal = {
      "<esc>",
      vim.cmd("stopinsert"),
      mode = "t",
      -- expr = true,
      desc = "Escape to normal mode",
    },
  },
}
