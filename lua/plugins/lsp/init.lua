local pack_path = vim.fn.stdpath('data') .. '/pack/plugins/start'

vim.opt.rtp:prepend(pack_path .. '/nvim-web-devicons')
vim.opt.rtp:prepend(pack_path .. '/fidget.nvim')
vim.opt.rtp:prepend(pack_path .. '/mason-lspconfig.nvim')
vim.opt.rtp:prepend(pack_path .. '/mason-tool-installer.nvim')
vim.opt.rtp:prepend(pack_path .. '/mason.nvim')
vim.opt.rtp:prepend(pack_path .. '/nvim-lspconfig')

require('mason').setup {}
require('fidget').setup {}

require('plugins.lsp.lazydev')
require('plugins.lsp.blink-cmp')
require('plugins.lsp.nvim-lspconfig')
require('plugins.lsp.tiny-inline-diagnostic')
require('plugins.lsp.nvim-dap')
