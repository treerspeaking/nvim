return {
  "nvim-lualine/lualine.nvim",
  optional = true,
  opts = function(_, opts)
    if not vim.g.trouble_lualine then
      table.insert(opts.sections.lualine_c, { "navic", color_correction = "dynamic" })
    end
    table.insert(opts.sections.lualine_x, 1, {
      "venv-selector",
      cond = function()
        return vim.bo.filetype == "python"
      end,
    })
    -- opts.log_level = "trace"
  end,
}

