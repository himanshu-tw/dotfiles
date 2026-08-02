local wezterm = require 'wezterm'
local config = wezterm.config_builder()

-- [GNOME Snapping & Startup Maximization]
-- This event listener maximizes the window immediately on launch
-- while keeping it fully snappable via GNOME shortcuts (Super + Arrow Keys)
wezterm.on('window-config-reloaded', function(window, pane)
  window:maximize()
end)

-- [tmux Optimization: Clean Top Layout]
config.enable_tab_bar = false             
config.window_decorations = "INTEGRATED_BUTTONS|RESIZE" -- Keeps window snappable on GNOME
config.hide_tab_bar_if_only_one_tab = true 

-- [Window Padding & Enhanced Transparency]
-- config.window_background_opacity = 0.85   
config.window_padding = {
  left = 12,
  right = 12,
  top = 10,
  bottom = 10,
}

-- [Theme Configuration]
config.color_scheme = 'Tokyo Night'

-- [Font Settings]
config.font = wezterm.font_with_fallback({
  { family = "JetBrainsMono Nerd Font", weight = "Regular" },
})
config.font_size = 13.0
config.line_height = 1.12                 

-- [Cursor Settings]
config.default_cursor_style = 'SteadyBlock' 

-- [Scrolling]
config.scrollback_lines = 10000

return config
