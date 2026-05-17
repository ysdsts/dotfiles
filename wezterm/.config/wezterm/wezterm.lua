local wezterm = require 'wezterm'
local config = wezterm.config_builder()
local mux = wezterm.mux
local tabline = wezterm.plugin.require("https://github.com/michaelbrusegard/tabline.wez")

tabline.setup({
    options = { theme = "Catppuccin Mocha" },
})

wezterm.on('gui-startup', function(cmd)
	local tab, pane, window = mux.spawn_window(cmd or {})
	window:gui_window():set_inner_size(3800, 2500)
	window:gui_window():set_position(700, 200)
end)

config.automatically_reload_config = true
config.use_fancy_tab_bar = false
config.color_scheme = 'Catppuccin Mocha'
config.window_background_opacity = 0.8
config.macos_window_background_blur = 20
config.font = wezterm.font("Firge35Nerd Console")
config.font_size = 14.0
config.key_tables = require('keybinds').key_tables
--config.enable_tab_bar = false
--config.window_decorations = "RESIZE"
config.window_close_confirmation = "AlwaysPrompt"
config.pane_focus_follows_mouse = true
config.default_cursor_style = "BlinkingBlock"

return config

