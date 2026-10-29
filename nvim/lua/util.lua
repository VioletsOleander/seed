local Util = {}

--- Execute the given function and warn on error.
---
---@param func function The function to execute.
---@return boolean ok Whether the execution is successful.
Util.safely = function(func)
  local ok, err = xpcall(func, function(err)
    return debug.traceback(err .. "\n", 2)
  end)

  if not ok then
    vim.notify("Error during safe execution: " .. err, vim.log.levels.WARN)
  end

  return ok
end

return Util
