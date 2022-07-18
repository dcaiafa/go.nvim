if vim.fn.has "nvim-0.7.0" ~= 1 then
  vim.api.nvim_err_writeln "go.nvim requires at least nvim-0.7.0"
  return
end

if vim.g.loaded_gonvim == 1 then
  return
end
vim.g.loaded_gonvim = 1

vim.api.nvim_create_user_command("GoTest", function()
  require("go.tests").run_tests()
end, {})
