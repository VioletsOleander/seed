-- Directly return if current buffer is for floating window
if vim.bo.buftype == "nofile" then
  -- Wrapping will not consider concealed markdown links, causing werid look if there exists
  -- concealed markdown links.
  vim.wo.wrap = false
  return
end

vim.bo.completeopt = "menu,popup"
vim.b.completion = false
