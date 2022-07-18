M = {}

-- client returns the golsp client attached to the current buffer, if any.
local function client()
  local clients = vim.lsp.buf_get_clients(0)
  for _, client in pairs(clients) do
    if client.name == "gopls" then
      return client
    end
  end
  return nil
end
M.client = client

function M.organize_imports() 
  local cli = client()
  if not cli then
    return
  end

  -- Execute code action on gopls.
  local params = vim.lsp.util.make_range_params()
  params.context = { only = { "source.organizeImports" } }

  -- If successful, it returns the list of edits to apply to the workspace.
  local results = vim.lsp.buf_request_sync(
      0, "textDocument/codeAction", params, 5000)
  for _, result in pairs(results) do
    for _, result2 in pairs(result.result or {}) do
      if result2.edit and not vim.tbl_isempty(result2.edit) then
        vim.lsp.util.apply_workspace_edit(
            result2.edit, cli.offset_encoding)
      end
    end
  end
end

return M
