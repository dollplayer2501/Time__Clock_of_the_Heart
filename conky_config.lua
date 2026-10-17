--
--
--

local resolution_xx = 1920
local resolution_yy = 1080

conky.config = {
                                            --
  -- Various settings

  background = true,                        -- forked to background
  cpu_avg_samples = 4,                      -- The number of samples to average for CPU monitoring.
  diskio_avg_samples = 10,                  -- The number of samples to average for disk I/O monitoring.
  double_buffer = true,                     -- Use the Xdbe extension? (eliminates flicker)
  if_up_strictness = 'address',             -- how strict if testing interface is up - up, link or address
  net_avg_samples = 2,                      -- The number of samples to average for net data
  no_buffers = true,                        -- Subtract (file system) buffers from used memory?
  temperature_unit = 'celsius',             -- fahrenheit or celsius
  text_buffer_size = 2048,                  -- size of buffer for display of content of large variables - default 256
  imlib_cache_size = 0,                     -- disable image cache to get a new spotify cover per song

  update_interval = 1.00,                   -- update interval

  -- Placement

  alignment = 'top_left',                   -- top_left, top_middle, top_right,
                                            -- middle_left, middle_middle, middle_right,none
                                            -- bottom_left, bottom_middle, bottom_right,

  gap_x = 12,                               -- pixels between right or left border
  gap_y = 12,                               -- pixels between bottom or left border

  minimum_height = resolution_yy,           -- minimum height of window
  minimum_width = resolution_xx,            -- minimum height of window
  maximum_width = resolution_xx,            -- maximum height of window

  -- Graphical

  border_inner_margin = 10,                 -- margin between border and text
  border_outer_margin = 1,                  -- margin between border and edge of window
  border_width = 1,                         -- border width in pixels

  default_bar_width = 280,                  -- default is 0 - full width
  default_bar_height = 10,                  -- default is 6
  default_gauge_height = 25,                -- default is 25
  default_gauge_width = 40,                 -- default is 40
  default_graph_height = 40,                -- default is 25
  default_graph_width = 153,                -- default is 0 - full width

  default_shade_color = '#ff00ff',          -- default shading colour
  default_outline_color = '#ff00ff',        -- default outline colour

  draw_borders = false,                     -- draw borders around text
  draw_graph_borders = true,                -- draw borders around graphs
  draw_shades = false,                      -- draw shades
  draw_outline = false,                     -- draw outline

  stippled_borders = 0,                     -- dashing the border

  -- Textual

  extra_newline = false,                    -- extra newline at the end - for asesome s wiboxes
  font = 'Sans:size=10',                    -- font for complete conky unless in code defined
  max_text_width = 0,                       -- 0 will make sure line does not get broken if width too smal
  max_user_text = 16384,                    -- max text in conky default 16384
  override_utf8_locale = true,              -- force UTF8 requires xft
  short_units = true,                       -- shorten units from KiB to k
  top_name_width = 21,                      -- width for $top name value default 15
  top_name_verbose = false,                 -- If true, top name shows the full command line of  each  process - Default value is false.
  uppercase = false,                        -- uppercase or not
  use_spacer = 'none',                      -- adds spaces around certain objects to align - default none
  use_xft = true,                           -- xft font - anti-aliased font
  xftalpha = 1,                             -- alpha of the xft font - between 0-1

  -- Windows

  own_window = true,                        -- create your own window to draw
  -- own_window_argb_value = 255,           -- real transparency - composite manager required 0-255
  -- own_window_argb_visual = true,         -- use ARGB - composite manager required
  own_window_class = 'Conky',               -- manually set the WM_CLASS name for use with xprop
  own_window_colour = '#00000000',            -- set colour if own_window_transparent no
  own_window_hints = 'undecorated,below,above,sticky,skip_taskbar,skip_pager',
                                            -- if own_window true - just hints - own_window_type sets it
  -- own_window_transparent = true,         -- if own_window_argb_visual is true sets background opacity 0%
  own_window_title = 'system_conky',        -- set the name manually  - default conky "hostname"
  own_window_type = 'override',             -- if own_window true options are: normal/override/dock/desktop/panel

  -- Others

  default_color = '#ff00ff',
  out_to_console = false,
  out_to_ncurses = false,
  out_to_stderr = false,
  out_to_x = true,
  show_graph_scale = false,
  show_graph_range = false,

  -- Lua

  lua_load =

    ' ./conky_main.lua ' ..
    ' ./conky_global_const.lua ' ..
    ' ./conky_functions.lua ' ..
    ' ./conky_sub_parse.lua ' ..
    ' ./conky_sub_line.lua ' ..
    ' ./conky_sub_text.lua ' ..
    ' ./conky_my_config.lua ' ..
    ' ./conky_my_color.lua ' ..

    ' ' , -- this section's last is conmma

  lua_draw_hook_post = 'main',

  --
  -- I still can't use this feature properly.
  --
  lua_mouse_hook = '',
  lua_shutdown_hook = '',
  lua_startup_hook = '',
}


conky.text = [[]]
