local wezterm = require 'wezterm'

return {
	default_prog = {'/run/current-system/sw/bin/fish', '--login', '--command', 'nvim'},
	enable_tab_bar = false,
	font = wezterm.font('JetBrainsMono Nerd Font Mono'),
	harfbuzz_features = {'calt=0', 'clig=0', 'liga=0'},
	keys = {
		{key = 'f', mods = 'CMD|CTRL', action = 'ToggleFullScreen'},
		{key = 'n', mods = 'CMD', action = 'SpawnWindow'},
		{key = 'q', mods = 'CMD', action = 'DisableDefaultAssignment'},
		{key = 's', mods = 'CMD', action = wezterm.action {SendString = ':silent wall\n'}},
		{key = 't', mods = 'CMD', action = wezterm.action {SendString = ':tabnew\n'}},
		{key = 'w', mods = 'CMD', action = wezterm.action {SendString = ':tabclose\n'}},
		{key = 'w', mods = 'CMD|SHIFT', action = wezterm.action {SendString = ':qall\n'}},
		{key = '-', mods = 'CTRL', action = wezterm.action {SendString = '\x1f'}},
	},
	native_macos_fullscreen_mode = true,
	send_composed_key_when_left_alt_is_pressed = true,
	send_composed_key_when_right_alt_is_pressed = true,
}
