M = {}

local log_file = vim.fn.expand("$HOME") .. "/tmp/gonvim.log"

M.log = function(...)
  local fp = assert(io.open(log_file, "a"))
  local str = ""

  local args = {...}
  for i, arg in ipairs(args) do
    if type(arg) == "table" then
      args[i] = vim.inspect(arg)
    else
      args[i] = tostring(arg)
    end
  end

  fp:write(table.concat(args, " ") .. "\n")
  fp:close()
end

return M
