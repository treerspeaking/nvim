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
    table.insert(opts.routes, {
      filter = {
        event = "lsp",
        kind = "progress",
        cond = function(message)
          local p = message.opts.progress or {}
          return p.client == "jdtls" and (p.title == "Validate documents" or p.title == "Publish Diagnostics")
        end,
      },
      opts = { skip = true },
    })
  end,
}
