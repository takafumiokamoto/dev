vim.o.guifont = 'CaskaydiaMono NFM:i:h11'
vim.keymap.set({ 'n', 'v' }, '<C-v>', [["+p]])
vim.keymap.set('i', '<C-v>', '<C-r>+')
vim.g.neovide_title_background_color = string.format('%x', vim.api.nvim_get_hl(0, { id = vim.api.nvim_get_hl_id_by_name 'Normal' }).bg)
vim.g.neovide_title_text_color = '#C792EA'
-- vim.g.neovide_fullscreen = true
vim.g.neovide_input_ime = true
local animation = false
if animation then
  vim.g.neovide_cursor_animate_in_insert_mode = true
  vim.g.neovide_cursor_animate_command_line = true
  vim.g.neovide_cursor_smooth_blink = true
  vim.g.neovide_cursor_vfx_mode = 'railgun'
  -- vim.g.neovide_cursor_vfx_mode = "pixiedust"
  -- vim.g.neovide_cursor_vfx_mode = "torpedo"
else
  vim.g.neovide_position_animation_length = 0
  vim.g.neovide_cursor_animation_length = 0.00
  vim.g.neovide_cursor_trail_size = 0
  vim.g.neovide_cursor_animate_in_insert_mode = false
  vim.g.neovide_cursor_animate_command_line = false
  vim.g.neovide_scroll_animation_far_lines = 0
  vim.g.neovide_scroll_animation_length = 0.00
end
