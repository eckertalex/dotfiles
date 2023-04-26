for _, source in ipairs({
  "mvim.options",
  "mvim.lazy",
  "mvim.autocmds",
  -- "mvim.keymaps",
}) do
  local status_ok, fault = pcall(require, source)
  if not status_ok then
    vim.api.nvim_err_writeln("Failed to load " .. source .. "\n\n" .. fault)
  end
end
