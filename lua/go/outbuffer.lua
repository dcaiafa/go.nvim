M = {}

M.new = function()
  return {
    partial_line = nil
  }
end

M.process = function(buf, data, on_line)
  for i, line in ipairs(data) do
    if i == 1 then
      buf.partial_line = (buf.partial_line or "") .. line
    else 
      if buf.partial_line then 
        on_line(buf.partial_line)
        buf.partial_line = nil
      end
      if i ~= #data or line ~= '' then
        on_line(line)
      end
    end 
  end
end

return M
