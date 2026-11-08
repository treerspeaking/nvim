return {
  "neovim/nvim-lspconfig",
  opts = {
    -- make sure mason installs the server
    servers = {
      tsc = {
        keys = {
          {
            "gD", -- The function is complete AI generated, will fix later
            function()
              local client = vim.lsp.get_clients({ bufnr = 0, name = "tsc" })[1]
              if not client then
                return
              end
              local params = vim.lsp.util.make_position_params(0, client.offset_encoding)
              client:request("custom/textDocument/sourceDefinition", params, function(err, result)
                if err then
                  return vim.notify(err.message, vim.log.levels.ERROR)
                end
                local locations = vim.islist(result) and result or { result }
                if #locations == 0 then
                  return vim.notify("No source definition found", vim.log.levels.INFO)
                end
                if #locations == 1 then
                  return vim.lsp.util.show_document(locations[1], client.offset_encoding, { focus = true })
                end
                vim.fn.setqflist({}, " ", {
                  title = "Source Definition",
                  items = vim.lsp.util.locations_to_items(locations, client.offset_encoding),
                })
                require("telescope.builtin").quickfix()
              end, 0)
            end,
            desc = "Goto Source Definition",
          },
        },
      },
    },
  },
}
