local wezterm = require("wezterm")
local mux = wezterm.mux
local config = wezterm.config_builder()

config.font_size = 11
config.font = wezterm.font("CaskaydiaMono NFM", { italic = true })
-- config.font = wezterm.font('Victor Mono SemiBold', { italic = true })
config.color_scheme = "Palenight (Gogh)"
config.hide_tab_bar_if_only_one_tab = true
config.audible_bell = "Disabled"
-- config.default_domain = 'WSL:Debian'
config.default_domain = "WSL:Ubuntu-24.04"
config.window_background_opacity = 1
-- config.win32_system_backdrop = 'Acrylic'
-- config.win32_system_backdrop = 'Tabbed'
-- config.win32_system_backdrop = 'Mica'
-- config.window_decorations = "RESIZE"
config.window_decorations = "RESIZE | TITLE"

-- maximize window on startup
wezterm.on("gui-startup", function(window)
	local tab, pane, window = mux.spawn_window(cmd or {})
	local gui_window = window:gui_window()
	gui_window:maximize()
end)

local action = wezterm.action
config.keys = {
	{
		key = "w",
		mods = "SHIFT|CTRL",
		action = wezterm.action({ CloseCurrentTab = { confirm = false } }),
	},
	{ key = "v", mods = "CTRL", action = wezterm.action({ PasteFrom = "Clipboard" }) },
}
config.mouse_bindings = {
	{
		event = { Down = { streak = 1, button = "Right" } },
		mods = "NONE",
		action = wezterm.action_callback(function(window, pane)
			local has_selection = window:get_selection_text_for_pane(pane) ~= ""
			if has_selection then
				window:perform_action(wezterm.action.CopyTo("ClipboardAndPrimarySelection"), pane)
				window:perform_action(wezterm.action.ClearSelection, pane)
			else
				window:perform_action(wezterm.action({ PasteFrom = "Clipboard" }), pane)
			end
		end),
	},
	{
		event = { Down = { streak = 1, button = { WheelUp = 1 } } },
		mods = "NONE",
		action = action.ScrollByLine(-3),
	},
	{
		event = { Down = { streak = 1, button = { WheelDown = 1 } } },
		mods = "NONE",
		action = action.ScrollByLine(3),
	},
}
return config
