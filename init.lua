-- ============================================================
-- SECTION 1: FOUNDATION
-- Core Neovim settings, leaders, options, basic keymaps, basic autocmds
-- ============================================================
do
  vim.g.mapleader = ' '
  vim.g.maplocalleader = ' '
  vim.g.have_nerd_font = true

  vim.o.number = true
  vim.o.relativenumber = true
  vim.opt.modeline = false
  vim.g.loaded_netrw = 1
  vim.g.loaded_netrwPlugin = 1

  vim.o.mouse = 'a'
  vim.o.showmode = false

  vim.schedule(function()
    vim.o.clipboard = 'unnamedplus'
  end)

  vim.o.breakindent = true
  vim.o.undofile = true

  vim.o.ignorecase = true
  vim.o.smartcase = true

  vim.o.signcolumn = 'yes'
  vim.o.updatetime = 250
  vim.o.timeoutlen = 300

  vim.o.splitright = true
  vim.o.splitbelow = true

  vim.o.list = true
  vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

  vim.o.inccommand = 'split'
  vim.o.cursorline = true
  vim.o.scrolloff = 14

  vim.o.confirm = true

  vim.o.tabstop = 4
  vim.o.shiftwidth = 4
  vim.o.expandtab = true
  vim.opt.winborder = 'rounded'

  require 'keymaps'

  vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking (copying) text',
    group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
    callback = function()
      vim.hl.on_yank()
    end,
  })

  vim.diagnostic.config {
    update_in_insert = false,
    severity_sort = true,
    float = { border = 'rounded', source = 'if_many' },
    underline = { severity = { min = vim.diagnostic.severity.WARN } },
    virtual_text = true,
    jump = {
      on_jump = function(_, bufnr)
        vim.diagnostic.open_float {
          bufnr = bufnr,
          scope = 'cursor',
          focus = false,
        }
      end,
    },
  }

  vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })
  vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
  vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
  vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
  vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
  vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })
end

-- ============================================================
-- SECTION 2: PLUGIN LOADING
-- Load plugins from pack directory
-- ============================================================
do
  local pack_path = vim.fn.stdpath 'data' .. '/pack/plugins/start'
  local lazy_path = vim.fn.stdpath 'data' .. '/lazy'

  vim.pack.add { { src = 'https://github.com/catppuccin/nvim', name = 'catppuccin' } }

  if vim.fn.isdirectory(lazy_path) == 1 then
    local handle = vim.loop.fs_scandir(lazy_path)
    if handle then
      while true do
        local name, type = vim.loop.fs_scandir_next(handle)
        if not name then
          break
        end
        if type == 'directory' then
          local plugin_dir = pack_path .. '/' .. name
          if vim.fn.isdirectory(plugin_dir) == 0 then
            vim.fn.system { 'ln', '-sf', lazy_path .. '/' .. name, plugin_dir }
          end
        end
      end
    end
  end

  vim.opt.rtp:prepend(vim.fn.stdpath('data') .. '/site/pack/core/opt')
  require 'plugins'

  vim.opt.rtp:prepend(pack_path .. '/nvim')
  vim.cmd.colorscheme 'catppuccin-mocha'
end

require 'plugins.ui'

require 'plugins.lsp'

require 'plugins.coding'

require 'plugins.syntax'

require 'plugins.git'

require 'plugins.utils'
