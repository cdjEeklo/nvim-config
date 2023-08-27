local dap    = require('dap')
local dapui  = require('dapui')
local keymap = vim.keymap

-- open and close the windows automatically
dap.listeners.after.event_initialized['dapui_config'] = function() dapui.open() end
dap.listeners.before.event_terminated['dapui_config'] = function() dapui.close() end
dap.listeners.before.event_exited['dapui_config'] = function() dapui.close() end
 
keymap.set('n', '<space>b', function() return require('dap').toggle_breakpoint() end, { noremap=true, silent=true })
keymap.set('n', '<space>n', function() return require('dap').continue() end, { noremap=true, silent=true })
keymap.set('n', '<space>d', function() require('dap').repl.open() end, { noremap=true, silent=true })
-- TODO: add step_over() en step_into()

dap.adapters['pwa-node'] = {
  type = 'server',
  host = 'localhost',
  port = '${port}',
  executable = {
    command = 'node',
    args = {vim.fn.stdpath('data')..'mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js', '${port}'},
  }
}
dap.configurations.typescript = {
  {
    type = 'pwa-node',
    request = 'launch',
    name = "Launch file",
    runtimeExecutable = "deno",
    runtimeArgs = {
      "run",
      "--inspect-wait",
      "--allow-all"
    },
    program = "${file}",
    cwd = "${workspaceFolder}",
    attachSimplePort = 9229,
  },
}
