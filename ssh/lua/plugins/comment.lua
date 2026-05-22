return {
  "numToStr/Comment.nvim",
  opts = {},
  keys = {
    -- Normal mode mappings
    {
      "<C-/>",
      function()
        require("Comment.api").toggle.linewise.current()
      end,
      mode = "n",
      silent = true,
      desc = "Comment toggle current line",
    },
    {
      "<C-_>",
      function()
        require("Comment.api").toggle.linewise.current()
      end,
      mode = "n",
      silent = true,
      desc = "Comment toggle current line (Terminal fallback)",
    },

    -- Visual mode mappings
    {
      "<C-/>",
      "<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<cr>",
      mode = "v",
      silent = true,
      desc = "Comment toggle selection",
    },
    {
      "<C-_>",
      "<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<cr>",
      mode = "v",
      silent = true,
      desc = "Comment toggle selection (Terminal fallback)",
    },

    -- Insert mode mappings
    {
      "<C-/>",
      "<cmd>lua require('Comment.api').toggle.linewise.current()<cr>",
      mode = "i",
      silent = true,
      desc = "Comment toggle current line",
    },
    {
      "<C-_>",
      "<cmd>lua require('Comment.api').toggle.linewise.current()<cr>",
      mode = "i",
      silent = true,
      desc = "Comment toggle current line (Terminal fallback)",
    },
  },
}
