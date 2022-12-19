if vim.fn.has "nvim-0.7.0" ~= 1 then
  vim.api.nvim_err_writeln "go.nvim requires at least nvim-0.7.0"
  return
end

if vim.g.loaded_gonvim == 1 then
  return
end
vim.g.loaded_gonvim = 1

vim.opt_local.tabstop = 2
vim.opt_local.shiftwidth = 2
vim.opt_local.softtabstop = 2

require("which-key").register({
  c = {
    name = "Coding",
    --a = { "<cmd>GoAlt<cr>", "Go alternate file" },
    --e = { "<cmd>GoIfErr<cr>", "Add if err" },
    --b = { "<cmd>GoBuild<cr>", "Build" },
    --i = { "<cmd>GoImport<cr>", "Add imports" },
    t = {
      name = "Testing",
      --n = { "<cmd>GoTest -n<cr>", "Run nearest test" },
      p = { "<cmd>GoTest<cr>", "Run package tests" },
      --t = { "<cmd>GoTest -f<cr>", "Run file tests" },
      --c = { "<cmd>GoCoverage<cr>", "Test coverage" },
    }
  }
}, { prefix = "<leader>", mode = "n", { silent = true } })

local myGoGroup = vim.api.nvim_create_augroup("MyGoGroup", {})
vim.api.nvim_create_autocmd("BufWritePre", {
  callback = function()
    require('go.lsp').organize_imports()
    vim.lsp.buf.format()
  end,
  group = myGoGroup,
  buffer = vim.fn.bufnr()
})

vim.api.nvim_create_user_command("GoTest", function()
  require("go.tests").run_tests()
end, {})
