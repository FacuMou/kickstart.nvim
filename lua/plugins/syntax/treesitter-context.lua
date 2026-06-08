require('treesitter-context').setup()

vim.keymap.set('n', 'ñ', function()
  require('treesitter-context').go_to_context(vim.v.count1)
end, { silent = true, desc = 'Go up in context' })
