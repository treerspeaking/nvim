return {
  "folke/noice.nvim",
  opts = function(_, opts)
    opts.routes = opts.routes or {}
    table.insert(opts.routes, {
      filter = {
        any = {
          { find = "image%.nvim" }, --ignore image nvim error
        },
      },
      opts = { skip = true },
    })
  end,
}
