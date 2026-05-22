local dap = require("dap")
local widgets = require("dap.ui.widgets")
local ui = require("dapui")

vim.keymap.set('n', '<Leader>dq', function() dap.continue() end)
vim.keymap.set('n', '<Leader>dQ', function() ui.close() end)
vim.keymap.set('n', '<Leader>dW', function() ui.open() end)
vim.keymap.set('n', '<Leader>dw', function() dap.step_over() end)
vim.keymap.set('n', '<Leader>de', function() dap.step_into() end)
vim.keymap.set('n', '<Leader>dr', function() dap.step_out() end)
vim.keymap.set('n', '<Leader>db', function() dap.toggle_breakpoint() end)
vim.keymap.set('n', '<Leader>dB', function() dap.set_breakpoint() end)
vim.keymap.set('n', '<Leader>dlp', function() dap.set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end)
vim.keymap.set('n', '<Leader>do', function() dap.repl.open() end)
vim.keymap.set('n', '<Leader>dl', function() dap.run_last() end)
vim.keymap.set({'n', 'v'}, '<Leader>dh', function()
  widgets.hover()
end)
vim.keymap.set({'n', 'v'}, '<Leader>dp', function()
  widgets.preview()
end)
vim.keymap.set('n', '<Leader>df', function()
  widgets.centered_float(widgets.frames)
end)
vim.keymap.set('n', '<Leader>ds', function()
  widgets.centered_float(widgets.scopes)
end)
vim.keymap.set('n', '<Leader>d?', function() 
    require('dapui').eval(nil, { enter = true })
end)

dap.listeners.before.attach.dapui_config = function()
    ui.open()
end

dap.listeners.before.launch.dapui_config = function()
    ui.open()
end

-- dap.listeners.before.event_terminated.dapui_config = function()
--     ui.close()
-- end

-- dap.listeners.before.event_exited.dapui_config = function()
--     ui.close()
-- end

-- Signs: breakpoints and current execution line
vim.fn.sign_define('DapBreakpoint',         { text = '●', texthl = 'DapBreakpoint',         linehl = '',              numhl = '' })
vim.fn.sign_define('DapBreakpointCondition',{ text = '◆', texthl = 'DapBreakpointCondition', linehl = '',              numhl = '' })
vim.fn.sign_define('DapLogPoint',           { text = '◉', texthl = 'DapLogPoint',            linehl = '',              numhl = '' })
vim.fn.sign_define('DapStopped',            { text = '▶', texthl = 'DapStopped',             linehl = 'DapStoppedLine', numhl = '' })
vim.fn.sign_define('DapBreakpointRejected', { text = '○', texthl = 'DapBreakpointRejected',  linehl = '',              numhl = '' })

vim.api.nvim_set_hl(0, 'DapBreakpoint',         { fg = '#e51400' })
vim.api.nvim_set_hl(0, 'DapBreakpointCondition', { fg = '#f5a623' })
vim.api.nvim_set_hl(0, 'DapLogPoint',            { fg = '#61afef' })
vim.api.nvim_set_hl(0, 'DapStopped',             { fg = '#98c379' })
vim.api.nvim_set_hl(0, 'DapStoppedLine',         { bg = '#1e3a2a' })
vim.api.nvim_set_hl(0, 'DapBreakpointRejected',  { fg = '#666666' })

-- Disable auto-loading of .vscode/launch.json — it contains `restart: true` which
-- causes a tight reconnect loop in nvim-dap. We manage configs explicitly below.
dap.providers.configs["dap.launch.json"] = function() return {} end

local js_debug_path = vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js"

dap.adapters["pwa-node"] = {
  type = "server",
  host = "localhost",
  port = "${port}",
  executable = {
    command = "node",
    args = { js_debug_path, "${port}" },
  },
}

local js_attach = {
  {
    name = "Webapp Attach",
    type = "pwa-node",
    request = "attach",
    port = 9229,
    address = "localhost",
    skipFiles = { "<node_internals>/**", "node_modules/**" },
    sourceMaps = true,
    resolveSourceMapLocations = { "${workspaceFolder}/**", "!**/node_modules/**" },
    localRoot = "${workspaceFolder}",
    remoteRoot = "/app",
    smartStep = true,
  }
}

dap.configurations.javascript = js_attach
dap.configurations.typescript = js_attach
dap.configurations.typescriptreact = js_attach
dap.configurations.javascriptreact = js_attach

