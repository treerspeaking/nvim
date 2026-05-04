return {
  "3rd/image.nvim",
  dependencies = {
    "vhyrro/luarocks.nvim", -- Handles luarocks installation automatically
  },
  event = "VeryLazy", -- Load when needed (e.g., opening markdown or images)
  opts = {
    backend = "kitty", -- Best performance if using Kitty terminal
    integrations = {
      markdown = {
        enabled = true,
        clear_in_insert_mode = false,
        download_remote_images = true,
        only_render_image_at_cursor = false, -- Set true if you want hover-only
        only_render_image_at_cursor_mode = "popup",
        filetypes = { "markdown", "vimwiki", "quarto" },
        floatingwindows = true,
      },
      html = {
        enabled = true,
      },
      css = {
        enabled = true,
      },
    },
    max_width_window_percentage = 45, -- Optional: limit image size
    max_height_window_percentage = 45,
  },
}
