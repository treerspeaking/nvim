-- Snippetize: turn existing text into snippet tabstops you can Tab through.
--
-- How it works: vim.snippet only *inserts* templated text, so we read the
-- target region, rebuild it as an LSP snippet string where each field becomes
-- a numbered tabstop `${i:field}`, delete the region, then vim.snippet.expand()
-- it back in place. The first field lands selected in Select mode; <Tab> /
-- <S-Tab> (already mapped by LazyVim while a snippet is active) walk between
-- them. Original separators are preserved exactly.

local M = {}

-- Escape the three snippet-special characters so field text is inserted literally.
local function esc(s)
  return (s:gsub("[\\%$}]", "\\%0"))
end

-- Split `text` on `sep_pat`, wrapping each field in a numbered tabstop while
-- keeping the original separators intact. Returns the snippet string + count.
local function build(text, sep_pat)
  local out, n, pos = {}, 0, 1
  while true do
    local ss, se = text:find(sep_pat, pos)
    local field = text:sub(pos, ss and ss - 1 or nil)
    if #field > 0 then
      n = n + 1
      out[#out + 1] = ("${%d:%s}"):format(n, esc(field))
    end
    if not ss then
      break
    end
    out[#out + 1] = text:sub(ss, se) -- keep the exact separator
    pos = se + 1
  end
  return table.concat(out), n
end

-- Snippetize the whole current line.
-- sep_pat defaults to "%s+" = one-or-more spaces (so "two spaces between
-- words" splits into separate fields).
function M.line(sep_pat)
  sep_pat = sep_pat or "%s+"
  local row = vim.api.nvim_win_get_cursor(0)[1]
  local line = vim.api.nvim_get_current_line()
  local snip, n = build(line, sep_pat)
  if n == 0 then
    return vim.notify("Snippetize: no fields found on this line", vim.log.levels.WARN)
  end
  vim.api.nvim_buf_set_lines(0, row - 1, row, false, { "" })
  vim.api.nvim_win_set_cursor(0, { row, 0 })
  vim.snippet.expand(snip)
end

-- Snippetize just the current charwise visual selection (single line).
function M.selection(sep_pat)
  sep_pat = sep_pat or "%s+"
  local s, e = vim.fn.getpos("'<"), vim.fn.getpos("'>")
  local srow, scol, erow, ecol = s[2], s[3], e[2], e[3]
  if srow ~= erow then
    return vim.notify("Snippetize: select within a single line", vim.log.levels.WARN)
  end
  local line = vim.api.nvim_get_current_line()
  ecol = math.min(ecol, #line)
  local before, mid, after = line:sub(1, scol - 1), line:sub(scol, ecol), line:sub(ecol + 1)
  local snip, n = build(mid, sep_pat)
  if n == 0 then
    return vim.notify("Snippetize: no fields found in selection", vim.log.levels.WARN)
  end
  vim.api.nvim_buf_set_lines(0, srow - 1, srow, false, { before .. after })
  vim.api.nvim_win_set_cursor(0, { srow, #before }) -- expand where `mid` began
  vim.snippet.expand(snip)
end

-- :Snippetize   -> fields separated by any whitespace ("%s+")
-- :Snippetize!  -> cells separated by 2+ spaces (a field may contain single
--                  spaces), useful for aligned table-like text
-- Works on the current line, or the visual selection when given a range.
vim.api.nvim_create_user_command("Snippetize", function(o)
  local sep = o.bang and "%s%s+" or "%s+"
  if o.range > 0 then
    M.selection(sep)
  else
    M.line(sep)
  end
end, {
  bang = true,
  range = true,
  desc = "Fields -> Tab-through snippet tabstops (! = 2+ space cells)",
})

-- <leader>S : snippetize line (normal) or selection (visual).
--   add ! by using the command directly (:Snippetize!) for 2+ space cells.
vim.keymap.set("n", "<leader>S", "<Cmd>Snippetize<CR>", { desc = "Snippetize line (Tab-through fields)" })
vim.keymap.set("x", "<leader>S", ":Snippetize<CR>", { desc = "Snippetize selection (Tab-through fields)" })

return M
