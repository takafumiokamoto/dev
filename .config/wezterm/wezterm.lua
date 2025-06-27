local wezterm = require 'wezterm'

local config = {}

if wezterm.config_builder then
  config = wezterm.config_builder()
end

config.font =
  wezterm.font('CaskaydiaMono NFM', { weight = 'Bold', italic = true })
-- config.default_domain = 'WSL:Ubuntu'
config.default_prog = { 'pwsh.exe' }
config.hide_tab_bar_if_only_one_tab = true
config.use_ime = true
-- config.color_scheme = 'Catppuccin Frappe'
config.color_scheme = 'Palenight (Gogh)'
config.font_size = 12
config.window_close_confirmation = 'AlwaysPrompt'
config.enable_scroll_bar = true
config.initial_rows = 36
config.initial_cols = 120
config.default_cursor_style = 'BlinkingUnderline'
config.audible_bell = 'Disabled' 

return config
