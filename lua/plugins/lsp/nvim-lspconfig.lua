require('fidget').setup {}

require('which-key').add { '<leader>l', group = '[L]SP' }

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
  callback = function(event)
    local map = function(keys, func, desc, mode)
      mode = mode or 'n'
      vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
    end

    map('<leader>ln', vim.lsp.buf.rename, '[R]e[n]ame')
    map('<leader>la', vim.lsp.buf.code_action, 'Code [A]ction', { 'n', 'x' })
    map('<leader>lr', require('telescope.builtin').lsp_references, '[R]eferences')
    map('<leader>li', require('telescope.builtin').lsp_implementations, '[I]mplementation')
    map('<leader>ld', require('telescope.builtin').lsp_definitions, '[D]efinition')
    map('<leader>lD', vim.lsp.buf.declaration, '[D]eclaration')
    map('<leader>lO', require('telescope.builtin').lsp_document_symbols, 'Open Document Symbols')
    map('<leader>lW', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace Symbols')
    map('<leader>lt', require('telescope.builtin').lsp_type_definitions, '[T]ype Definition')

    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if client and client:supports_method('textDocument/documentHighlight', event.buf) then
      local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
      vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.document_highlight,
      })
      vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.clear_references,
      })
      vim.api.nvim_create_autocmd('LspDetach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
        callback = function(event2)
          vim.lsp.buf.clear_references()
          vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
        end,
      })
    end

    if client and client:supports_method('textDocument/inlayHint', event.buf) then
      map('<leader>th', function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
      end, '[T]oggle Inlay [H]ints')
    end
  end,
})

---@type table<string, vim.lsp.Config>
local servers = {
  lua_ls = {
    on_init = function(client)
      client.server_capabilities.documentFormattingProvider = false

      if client.workspace_folders then
        local path = client.workspace_folders[1].name
        if path ~= vim.fn.stdpath 'config' and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc')) then
          return
        end
      end

      client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
        runtime = {
          version = 'LuaJIT',
          path = { 'lua/?.lua', 'lua/?/init.lua' },
        },
        workspace = {
          checkThirdParty = false,
          library = vim.tbl_extend('force', vim.api.nvim_get_runtime_file('', true), {
            '${3rd}/luv/library',
            '${3rd}/busted/library',
          }),
        },
      })
    end,
    ---@type lspconfig.settings.lua_ls
    settings = {
      Lua = {
        format = { enable = false },
      },
    },
  },
  pylsp = {
    settings = {
      pylsp = {
        plugins = {
          pycodestyle = { enabled = false },
          pyflakes = { enabled = false },
          mccabe = { enabled = false },
          flake8 = { enabled = true, ignore = { 'E501', 'E226' } },
        },
      },
    },
  },
}

require('mason').setup {}

local ensure_installed = vim.tbl_keys(servers or {})
vim.list_extend(ensure_installed, { 'stylua' })
require('mason-tool-installer').setup { ensure_installed = ensure_installed }

local capabilities = require('blink.cmp').get_lsp_capabilities()
for name, server in pairs(servers) do
  server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
  vim.lsp.config(name, server)
  vim.lsp.enable(name)
end
