M = {}

M.run_tests = function() 
  local test_directory = vim.fn.expand("%:p:h")
  require("go.run").run({"go", "test", "-v", "."}, { cwd = test_directory })
end

return M
