-- Pylsp configuration for Neovim
-- Disabled E501 warnings (line too long) and set line length to 120

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('pylsp-config', { clear = true }),
  callback = function(event)
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if client and client.name == 'pylsp' then
      client.server_capabilities.documentFormattingProvider = false
    end
  end,
})
