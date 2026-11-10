-- Code inspired from https://github.com/okuuva/auto-save.nvim/blob/main/lua/auto-save/init.lua
local M = {}

local timers_by_buffer = {}

--- @param buf number
local function cancel_timer(buf)
  local timer = timers_by_buffer[buf]
  if timer ~= nil then
    timer:close()
    timers_by_buffer[buf] = nil
  end
end

--- @param lfn fun() The function to debounce
--- @param duration number The debounce duration
--- @return fun(buf: number) debounced The debounced function
local debounce = function(lfn, duration)
  local function inner_debounce(buf)
    -- instead of canceling the timer we could check if there is one already running for this buffer and restart it (`:again`)
    cancel_timer(buf)
    local timer = vim.defer_fn(function()
      timers_by_buffer[buf] = nil
      lfn()
    end, duration)
    timers_by_buffer[buf] = timer
  end
  return inner_debounce
end

M.debounce = debounce
M.cancel_timer = cancel_timer

return M
