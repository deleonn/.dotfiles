-- Eviline config for lualine
-- Author: shadmansaleh
-- Credit: glepnir
local lualine = require('lualine')

local function get_theme_colors()
  local normal = vim.api.nvim_get_hl(0, { name = 'Normal' })
  local normal_bg = normal.bg and string.format('#%06x', normal.bg) or '#202328'
  local normal_fg = normal.fg and string.format('#%06x', normal.fg) or '#bbc2cf'

  local function get_hl_color(group, attr, default)
    local hl = vim.api.nvim_get_hl(0, { name = group })
    local color = hl[attr]
    return color and string.format('#%06x', color) or default
  end

  return {
    bg       = normal_bg,
    fg       = normal_fg,
    yellow   = get_hl_color('DiagnosticWarn',  'fg', '#ECBE7B'),
    cyan     = get_hl_color('DiagnosticInfo',  'fg', '#008080'),
    darkblue = get_hl_color('Comment',         'fg', '#081633'),
    green    = get_hl_color('DiagnosticOk',    'fg', '#98be65'),
    orange   = get_hl_color('DiagnosticWarn',  'fg', '#FF8800'),
    violet   = get_hl_color('Statement',       'fg', '#a9a1e1'),
    magenta  = get_hl_color('Keyword',         'fg', '#c678dd'),
    blue     = get_hl_color('Function',        'fg', '#51afef'),
    red      = get_hl_color('DiagnosticError', 'fg', '#ec5f67'),
  }
end

local colors = get_theme_colors()

local conditions = {
  buffer_not_empty = function()
    return vim.fn.empty(vim.fn.expand('%:t')) ~= 1
  end,
  hide_in_width = function()
    return vim.fn.winwidth(0) > 80
  end,
  check_git_workspace = function()
    local filepath = vim.fn.expand('%:p:h')
    local gitdir = vim.fn.finddir('.git', filepath .. ';')
    return gitdir and #gitdir > 0 and #gitdir < #filepath
  end,
}

-- DAP background overrides
local DAP_BG = {
  stopped = '#1a2e1e',
  running = '#2b2510',
}

local function setup(dap_state)
  local bg = (dap_state and DAP_BG[dap_state]) or colors.bg

  local config = {
    options = {
      component_separators = '',
      section_separators = '',
      theme = {
        normal   = { c = { fg = colors.fg, bg = bg } },
        inactive = { c = { fg = colors.fg, bg = bg } },
      },
    },
    sections = {
      lualine_a = {}, lualine_b = {}, lualine_y = {}, lualine_z = {},
      lualine_c = {}, lualine_x = {},
    },
    inactive_sections = {
      lualine_a = {}, lualine_b = {}, lualine_y = {}, lualine_z = {},
      lualine_c = {}, lualine_x = {},
    },
  }

  local function ins_left(component)
    table.insert(config.sections.lualine_c, component)
  end

  local function ins_right(component)
    table.insert(config.sections.lualine_x, component)
  end

  ins_left {
    function() return '▊' end,
    color = function()
      local mode_color = {
        n = colors.red,   i = colors.green,  v = colors.blue,
        [''] = colors.blue, V = colors.blue, c = colors.magenta,
        no = colors.red,  s = colors.orange, S = colors.orange,
        [''] = colors.orange, ic = colors.yellow, R = colors.violet,
        Rv = colors.violet, cv = colors.red, ce = colors.red,
        r = colors.cyan, rm = colors.cyan, ['r?'] = colors.cyan,
        ['!'] = colors.red, t = colors.red,
      }
      return { fg = mode_color[vim.fn.mode()] }
    end,
    padding = { right = 1 },
  }

  ins_left {
    'filename',
    cond = conditions.buffer_not_empty,
    color = { fg = colors.magenta, gui = 'bold' },
    path = 1,
  }

  ins_left { 'location' }

  ins_left {
    'diagnostics',
    sources = { 'nvim_diagnostic' },
    symbols = { error = ' ', warn = ' ', info = ' ' },
    diagnostics_color = {
      color_error = { fg = colors.red },
      color_warn  = { fg = colors.yellow },
      color_info  = { fg = colors.cyan },
    },
  }

  ins_left {
    function()
      local session = require('dap').session()
      if not session then return '' end
      if session.stopped_thread_id then return ' Stopped' end
      return '⏵ Running'
    end,
    cond = function() return require('dap').session() ~= nil end,
    color = function()
      local session = require('dap').session()
      if session and session.stopped_thread_id then
        return { fg = colors.green, gui = 'bold' }
      end
      return { fg = colors.yellow, gui = 'bold' }
    end,
  }

  ins_right {
    'o:encoding',
    fmt  = string.upper,
    cond = conditions.hide_in_width,
    color = { fg = colors.green, gui = 'bold' },
  }

  ins_right {
    'fileformat',
    fmt           = string.upper,
    icons_enabled = false,
    color         = { fg = colors.green, gui = 'bold' },
  }

  ins_right {
    'branch',
    icon  = '',
    color = { fg = colors.violet, gui = 'bold' },
  }

  ins_right {
    'diff',
    symbols = { added = ' ', modified = '✱', removed = ' ' },
    diff_color = {
      added    = { fg = colors.green },
      modified = { fg = colors.orange },
      removed  = { fg = colors.red },
    },
    cond = conditions.hide_in_width,
  }

  lualine.setup(config)
end

-- Called by nvimdap.lua listeners to re-render with a tinted background.
-- state: 'running' | 'stopped' | nil (no session)
_G.set_lualine_dap_state = setup

setup()
