-- Directly return if current buffer is for floating window
if vim.bo.buftype == "nofile" then
  -- Wrapping will not consider concealed markdown links, causing werid look if there exists
  -- concealed markdown links.
  vim.wo.wrap = false
  return
end

vim.bo.completeopt = "menu,popup"
-- No autowarp text and comment.
vim.opt.formatoptions:remove({ "t", "c" })
vim.b.completion = false
