M = {}

local log = require("go.log")
local outbuffer = require("go.outbuffer")

local buf, win, job

local function reset()
  if job ~= nil then
    vim.fn.jobstop(job)
    job = nil
  end
  if win ~= nil then
    vim.api.nvim_win_close(win, true)
    win = nil
    buf = nil
  end
end

local function open_window()
  buf = vim.api.nvim_create_buf(false, true) -- create new emtpy buffer

  vim.api.nvim_buf_set_option(buf, 'bufhidden', 'wipe')
  vim.api.nvim_buf_set_option(buf, 'modifiable', false)
  vim.api.nvim_create_autocmd("BufWipeout", {
    buffer = buf,
    callback = reset,
  })

  local width = vim.api.nvim_get_option("columns")
  local height = vim.api.nvim_get_option("lines")
  local win_height = math.ceil(height * 0.8 - 4)
  local win_width = math.ceil(width * 0.8)
  local row = math.ceil((height - win_height) / 2 - 1)
  local col = math.ceil((width - win_width) / 2)

  local opts = {
    style = "minimal",
    relative = "editor",
    width = win_width,
    height = win_height,
    row = row,
    col = col
  }

  win = vim.api.nvim_open_win(buf, true, opts)

  vim.api.nvim_buf_set_keymap(
    buf, 'n', 'q', "", 
    { nowait = true, noremap = true, silent = true, callback = reset })
  vim.api.nvim_buf_set_keymap(
    buf, 'n', '<ESC>', "", 
    { nowait = true, noremap = true, silent = true, callback = reset })
end

local function process_output(line)
  if buf == nil then
    return
  end

  vim.api.nvim_buf_set_option(buf, 'modifiable', true)
  vim.api.nvim_buf_set_lines(buf, -1, -1, false, {line})
  vim.api.nvim_buf_set_option(buf, 'modifiable', false)

  local line_count = vim.api.nvim_buf_line_count(buf)
  vim.api.nvim_win_set_cursor(win, {line_count, 0})
end

-- run executes an external command asynchronously and displays the output in a
-- floating window.
M.run = function(cmd, opts) 
  reset()
  open_window()

  local out_buf = outbuffer.new()
  local err_buf = outbuffer.new()

  local job_opts = vim.tbl_extend("keep", {
    on_stdout = function(c, d, n) outbuffer.process(out_buf, d, process_output) end,
    on_stderr = function(c, d, n) outbuffer.process(err_buf, d, process_output) end,
  }, opts or {})

  job = vim.fn.jobstart(cmd, job_opts)
end

return M
