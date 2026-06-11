local pack_path = vim.fn.stdpath 'data' .. '/pack/plugins/start'

local plugins = {
  'nvim-treesitter',
  'nvim-treesitter-context',
  'nvim-colorizer.lua',
  'todo-comments.nvim',
  'nvim-web-devicons',
  'plenary.nvim',
  'which-key.nvim',
  'telescope.nvim',
  'telescope-fzf-native.nvim',
  'telescope-ui-select.nvim',
  'nui.nvim',
  'neo-tree.nvim',
  'mini.icons',
  'mini.nvim',
  'snacks.nvim',
  'gitsigns.nvim',
  'nvim-autopairs',
  'conform.nvim',
  'mason.nvim',
  'mason-lspconfig.nvim',
  'mason-tool-installer.nvim',
  'fidget.nvim',
  'blink.cmp',
  'blink.lib',
  'LuaSnip',
  'lazydev.nvim',
  'nvim-lspconfig',
  'tiny-inline-diagnostic.nvim',
  'nvim-dap',
  'nvim-dap-ui',
  'nvim-nio',
  'telescope-dap.nvim',
  'nvim-unstack',
  'nvim-tmux-navigation',
  'mason-conform',
  'opencode.nvim',
}

for _, plugin in ipairs(plugins) do
  local plugin_path = pack_path .. '/' .. plugin
  if vim.fn.isdirectory(plugin_path) == 1 then
    vim.opt.rtp:prepend(plugin_path)
  end
end
