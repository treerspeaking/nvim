return {
  "linux-cultist/venv-selector.nvim",
  cmd = "VenvSelect",
  opts = {
    options = {
      notify_user_on_venv_activation = true,
      log_level = "trace",
    },
    search = {
      miniforge_envs = {
        command = "$FD 'bin/python$' ~/miniforge3/envs --no-ignore-vcs --full-path --color never",
        type = "anaconda",
      },
      miniforge_base = {
        command = "$FD '/python$' ~/miniforge3/bin --no-ignore-vcs --full-path --color never",
        type = "anaconda",
      },
    },
  },
  --  Call config for Python files and load the cached venv automatically
  ft = "python",
  keys = { { "<leader>cv", "<cmd>:VenvSelect<cr>", desc = "Select VirtualEnv", ft = "python" } },
}
