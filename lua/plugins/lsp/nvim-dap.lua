local dap = require('dap')
local ui = require('dapui')

local ok, telescope = pcall(require, 'telescope')
if ok then
  telescope.load_extension('dap')
end

require('dapui').setup()

dap.adapters.gdb = {
  type = 'executable',
  command = 'arm-none-eabi-gdb',
  args = { '-i', 'mi' },
}

dap.configurations.c = {
  {
    name = 'Debug STM32 (OpenOCD)',
    type = 'gdb',
    request = 'launch',
    program = function()
      return vim.fn.input('Path to elf: ', vim.fn.getcwd() .. '/build/', 'file')
    end,
    cwd = '${workspaceFolder}',
    stopAtBeginningOfMainSubprogram = true,
    target = 'localhost:3333',
    setupCommands = {
      {
        text = '-enable-pretty-printing',
        description = 'enable pretty printing',
        ignoreFailures = false,
      },
    },
  },
}

vim.keymap.set('n', '<leader>Dl', ':Telescope dap list_breakpoints<CR>', { desc = 'List Breakpoints' })
vim.keymap.set('n', '<leader>Dv', ':Telescope dap variables<CR>', { desc = 'Search Variables' })
vim.keymap.set('n', '<leader>Db', dap.toggle_breakpoint, { desc = 'Toggle [B]reakpoint' })
vim.keymap.set('n', '<leader>Dc', dap.run_to_cursor, { desc = 'Run to [C]ursor' })
vim.keymap.set('n', '<leader>De', function()
  require('dapui').eval(nil, { enter = true })
end, { desc = '[E]val variable' })

vim.keymap.set('n', '<leader>D<F1>', dap.continue, { desc = 'Continue' })
vim.keymap.set('n', '<leader>D<F2>', dap.step_into, { desc = 'Step into' })
vim.keymap.set('n', '<leader>D<F3>', dap.step_over, { desc = 'Step over' })
vim.keymap.set('n', '<leader>D<F4>', dap.step_out, { desc = 'Step out' })
vim.keymap.set('n', '<leader>D<F5>', dap.step_back, { desc = 'Step back' })
vim.keymap.set('n', '<leader>D<F0>', dap.restart, { desc = 'Restart' })

dap.listeners.before.attach.dapui_config = function()
  ui.open()
end
dap.listeners.before.launch.dapui_config = function()
  ui.open()
end
dap.listeners.before.event_terminated.dapui_config = function()
  ui.close()
end
dap.listeners.before.event_exited.dapui_config = function()
  ui.close()
end
