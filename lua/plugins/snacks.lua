-- if true then
--  return {}
-- end

-- equalize window sizes, like the toggleterm on_open/on_close hooks
local function equalize()
  vim.schedule(function()
    vim.cmd("wincmd =")
  end)
end

return {
  "folke/snacks.nvim",
  opts = {
    zen = { enabled = false },
    terminal = { enabled = false },
    picker = {
      ignored = true,
      sources = {
        files = { hidden = true },
        grep = { hidden = true },
        explorer = {
          hidden = true,
          on_show = equalize,
          on_close = equalize,
        },
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
