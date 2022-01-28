local wezterm = require 'wezterm'

return {
	default_prog = {'/run/current-system/sw/bin/fish', '--login', '--command', 'nvim --cmd sleep'},
	disable_default_key_bindings = true,
	enable_tab_bar = false,
	font = wezterm.font('JetBrainsMono Nerd Font Mono'),
	harfbuzz_features = {"calt=0", "clig=0", "liga=0"},
	keys = {
    {key = 'n', mods = 'CMD', action = 'SpawnWindow'},
		{key = 's', mods = 'CMD', action = wezterm.action {SendString = ':wall\n'}},
		{key = 'w', mods = 'CMD', action = wezterm.action {SendString = ':qall\n'}},
	},
	native_macos_fullscreen_mode = true,
	send_composed_key_when_left_alt_is_pressed = true,
	send_composed_key_when_right_alt_is_pressed = true,
}
