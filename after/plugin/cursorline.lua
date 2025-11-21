vim.o.cursorline = true

-- Option 1: Let the theme define it (uncomment to use)
-- (No highlight override needed)

-- Option 2: Subtle underline using theme colors
vim.api.nvim_set_hl(0, "CursorLine", { underline = true })

-- Option 3: Blend with background using theme's cursorline color with transparency
-- vim.api.nvim_set_hl(0, "CursorLine", { bg = "NONE", blend = 10 })
