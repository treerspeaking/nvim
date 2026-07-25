-- Snippetize: turn existing text into snippet tabstops you can Tab through.
--
-- vim.snippet only *inserts* templated text, so we read the target region,
-- rebuild it as an LSP snippet string where each WORD becomes a numbered
-- tabstop `${i:word}`, delete the region, then vim.snippet.expand() it back in
-- place. The first field lands selected in Select mode; <Tab> / <S-Tab>
-- (already mapped by LazyVim while a snippet is active) walk between them.
--
-- Only "words" become tabstops: a run of letters/digits that may contain
-- internal "." "_" "-" (so Item.13.21 or 2026-07-24 stay whole). Surrounding
-- punctuation -- ( ) [ ] { } : ; ' " , . ... -- is kept as literal text and is
-- NOT selectable. Everything between tabstops is snippet-escaped so stray
-- "$" "}" "\" in your text can't corrupt the expansion.

local M = {}

-- A word: starts with an alphanumeric, then any alnum / . / _ / - .
local WORD = "%w[%w%._%-]*"
-- Cell separator for the `!` variant: two or more spaces.
local CELL_SEP = "%s%s+"

-- Escape the three snippet-special characters so text is inserted literally.
local function esc(s)
  return (s:gsub("[\\%$}]", "\\%0"))
end

-- Wrap each WORD in `text` as a tabstop; gaps and punctuation are emitted
-- literally (escaped). Trailing connector chars (. _ -) are pushed OUT of the
-- tabstop, so "word." -> "${n:word}." and "3.14" -> "${n:3.14}".
-- `n` is the running tabstop counter; returns the fragment and the new counter.
local function wrap_words(text, n)
  local out, pos = {}, 1
  while pos <= #text do
    local ws, we = text:find(WORD, pos)
    if not ws then
      out[#out + 1] = esc(text:sub(pos)) -- trailing literal remainder
      break
    end
    if ws > pos then
      out[#out + 1] = esc(text:sub(pos, ws - 1)) -- literal gap before the word
    end
    local core, tail = text:sub(ws, we):match("^(.-)([%._%-]*)$")
    n = n + 1
    out[#out + 1] = ("${%d:%s}"):format(n, esc(core))
    if tail ~= "" then
      out[#out + 1] = esc(tail) -- trailing . _ - kept literal, not selectable
    end
    pos = we + 1
  end
  return table.concat(out), n
end

-- Split `text` on 2+ spaces; each cell (may contain single spaces / punctuation)
-- becomes one tabstop. Original separators are preserved.
local function wrap_cells(text, n)
  local out, pos = {}, 1
  while true do
    local ss, se = text:find(CELL_SEP, pos)
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

local function wrapper(bang)
  return bang and wrap_cells or wrap_words
end

local function no_fields()
  vim.notify("Snippetize: no words found", vim.log.levels.WARN)
end

-- Snippetize the whole current line.
function M.normal(bang)
  local row = vim.api.nvim_win_get_cursor(0)[1]
  local snip, n = wrapper(bang)(vim.api.nvim_get_current_line(), 0)
  if n == 0 then
    return no_fields()
  end
  vim.api.nvim_buf_set_lines(0, row - 1, row, false, { "" })
  vim.api.nvim_win_set_cursor(0, { row, 0 })
  vim.snippet.expand(snip)
end

-- Snippetize whole lines srow..erow, tabstops numbered in reading order.
function M.lines(srow, erow, bang)
  local wrap = wrapper(bang)
  local lines = vim.api.nvim_buf_get_lines(0, srow - 1, erow, false)
  local n = 0
  for i, l in ipairs(lines) do
    lines[i], n = wrap(l, n)
  end
  if n == 0 then
    return no_fields()
  end
  vim.api.nvim_buf_set_lines(0, srow - 1, erow, false, { "" })
  vim.api.nvim_win_set_cursor(0, { srow, 0 })
  vim.snippet.expand(table.concat(lines, "\n"))
end

-- Snippetize just a charwise selection on a single line (column-precise).
function M.charsel(bang)
  local s, e = vim.fn.getpos("'<"), vim.fn.getpos("'>")
  local srow, scol, ecol = s[2], s[3], e[3]
  local line = vim.api.nvim_buf_get_lines(0, srow - 1, srow, false)[1] or ""
  ecol = math.min(ecol, #line)
  local before, mid, after = line:sub(1, scol - 1), line:sub(scol, ecol), line:sub(ecol + 1)
  local snip, n = wrapper(bang)(mid, 0)
  if n == 0 then
    return no_fields()
  end
  vim.api.nvim_buf_set_lines(0, srow - 1, srow, false, { before .. after })
  vim.api.nvim_win_set_cursor(0, { srow, #before }) -- expand where `mid` began
  vim.snippet.expand(snip)
end

-- Dispatch a visual selection: charwise single line -> column-precise;
-- linewise or multi-line -> whole-line range.
function M.visual(bang)
  local srow, erow = vim.fn.line("'<"), vim.fn.line("'>")
  if vim.fn.visualmode() == "v" and srow == erow then
    M.charsel(bang)
  else
    M.lines(srow, erow, bang)
  end
end

-- :Snippetize        -> words (letters/digits + internal . _ -) become tabstops
-- :Snippetize!       -> cells separated by 2+ spaces become tabstops
-- With a range (e.g. :'<,'>Snippetize) it works over whole lines.
vim.api.nvim_create_user_command("Snippetize", function(o)
  if o.range == 2 then
    M.lines(o.line1, o.line2, o.bang)
  else
    M.normal(o.bang)
  end
end, {
  bang = true,
  range = true,
  desc = "Words -> Tab-through snippet tabstops (! = 2+ space cells)",
})

-- <leader>S : snippetize the current line (normal) / selection (visual).
-- The <Esc> in the visual map commits the '< '> marks before we read them.
vim.keymap.set(
  "n",
  "<leader>S",
  "<Cmd>lua require('config.snippetize').normal(false)<CR>",
  { desc = "Snippetize line (words)" }
)
vim.keymap.set(
  "x",
  "<leader>S",
  "<Esc><Cmd>lua require('config.snippetize').visual(false)<CR>",
  { desc = "Snippetize selection (words)" }
)

return M
