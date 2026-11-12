--
--
--

require 'cairo'
require 'cairo_xlib'


--
-- Global settings for capturing mouse events
--
local hand_pos_xx = -1
local hand_pos_yy = -1
local hand_radius = -1
local display_flag = false


function get_current_path()
  --
  -- NOTE:
  --   This file itself is located in the `./lua/` directory.
  --   The directory one level above this serves as the base directory for this theme.
  --   Therefore, I will use that as our reference point.
  --
  local tmp_str_1 = debug.getinfo(1, "S").source:gsub("^@", "")
  local tmp_str_2 = tmp_str_1:match("^(.*[/\\])") or "./"
  return tmp_str_2:match("^(.*[/\\])[^/\\]+[/\\]$") or tmp_str_2
end


local display_message_green = function(_message)
  --
  -- NOTE:
  --   Output is suppressed via environment variables set at the time Conky is launched.
  --
  local tmp_str = os.getenv('DEBUG_MESSAGE') or 'false'
  if 'true' == string.lower(tmp_str) then
    print("\27[32m" .. _message .."\27[0m")
  end
end


--
-- Load various files, retrieving the package path
--

local current_path = get_current_path()
display_message_green(' Current directory:' .. current_path)

package.path = current_path .. 'lua/?.lua;'
            .. current_path .. 'config/?.lua;'
            .. package.path
display_message_green(' Package directory:' .. package.path)

--

require './lua/const'
require './lua/functions'
require './lua/sub_parse'
require './lua/sub_line'
require './lua/sub_text'
require './lua/sub_clock'
require './lua/sub_special'


--
-- NOTE:
--   In terms of the logic for this theme,
--   the default `./config/color_default.lua` and `./config/config_default.lua` are assumed to always exist;
--   however, if `./config/color_me.lua` and/or `./config/config_me.lua` are present,
--   it will be loaded instead, and the default items will not be loaded.
--
local check_file_exist = function(_full_path)
  local file = io.open(_full_path, 'r')
  if file then
    file:close()
    return true
  else
    return false
  end
end

--
-- Configuration, default or my customization?
--
require './config/config_default'
if true == check_file_exist(current_path .. 'config/config_me.lua') then
  require './config/config_me'
  display_message_green(" The user's configuration file, `./config/config_me.lua`, exists.")
else
  display_message_green(" The user's configuration file, `./config/config_me.lua`, does not exist.")
end

--
-- Color Scheme, default or my customization?
--
require './config/color_default'
if true == check_file_exist(current_path .. 'config/color_me.lua') then
  require './config/color_me'
  display_message_green(" The user's configuration file, `./config/color_me.lua`, exists.")
else
  display_message_green(" The user's configuration file, `./config/color_me.lua`, does not exist.")
end


-- -----------------------------------------------------------
--
-- -----------------------------------------------------------
function conky_main()

  --
  -- Basic settings
  --

  local gConst = get_const()
  local gParse = get_conky_parse()
  local gConfig = get_config(gConst)
  local gColor = get_color()


  --
  -- Something like a good-luck charm.
  --

  if conky_window == nil then
    return
  end

  local surface = conky_surface()
  if not surface then return end
  local cr = cairo_create(surface)
  cairo_rotate(cr, gConfig.Environment.Angle * (math.pi / 180))


  --
  -- Const
  --

  local const_one_day_seconds = 24 * 60 * 60
  local const_line_cap = gConst.Line.Cap.Square
  local const_font_slant = gConst.Font.Slant.Normal
  local const_font_weight = gConst.Font.Weight.Normal

  local hour24_now_hour = gParse.Now.Hour24
  local hour24_next_hour = (23 == gParse.Now.Hour24) and 0 or gParse.Now.Hour24 + 1


  --
  -- Calculate Hand
  --

  local tmp_seconds = hhmmss_to_sec(gConfig.Hand.Marks.Hour24, gConfig.Hand.Marks.Minutes, gConfig.Hand.Marks.Seconds)
  local hand_radian = degree_to_radian(360 * (tmp_seconds / const_one_day_seconds))


  --
  -- Where does the current time fall on a 24-hour clock?
  --
  -- NOTE:
  --   - If seconds were included, the clock would be in a state of constant motion.
  --     To avoid this, the calculation is intentionally limited to the minute level.
  --   - Lua array indices are 1-based, not 0-based.
  --

  local tmp_seconds = hhmmss_to_sec(gParse.Now.Hour24, gParse.Now.Minute)
  local now_radian = degree_to_radian(360 * (tmp_seconds / const_one_day_seconds))

  local array_times = {}
  for idx_hour24 = 0, 23, 1 do
    array_times[idx_hour24 + 1] = {}

    for idx_minutes = 0, 59, 1 do
      array_times[idx_hour24 + 1][idx_minutes + 1] = {}

      for idx_seconds = 0, 59, 1 do
        local tmp_seconds = hhmmss_to_sec(idx_hour24, idx_minutes)
        local tmp_radian = degree_to_radian(360 * (tmp_seconds / const_one_day_seconds))
        array_times[idx_hour24 + 1][idx_minutes + 1][idx_seconds + 1] = {
          radian = tmp_radian - now_radian + hand_radian,
        }
      end
    end
  end


  --
  -- Draw Line, Hand
  --

  hand_pos_xx, hand_pos_yy, hand_radius = draw_line_hand(cr, const_line_cap,
    gConfig.Clock24.Center, gConfig.Clock24.Radius,
    gConfig.Hand.Radius, hand_radian,
    gConfig.Hand.Width, gConfig.Hand.Point_size, gColor.Hand.Marks)


  --
  -- Draw Line and Point, Information
  --

  if true == display_flag then
    sub_special_func(cr, gConst, gParse, gConfig, gColor,
      const_line_cap, const_font_slant, const_font_weight,
      hand_radian)
  end


  --
  -- Marks and Numbers
  --

  sub_clock_func(cr, gConst, gParse, gConfig, gColor,
    const_line_cap, const_font_slant, const_font_weight,
    hour24_now_hour, hour24_next_hour, array_times)


  --
  --
  --

  cairo_destroy(cr)
  cairo_surface_destroy(cs)
  cr = nil
end


-- -----------------------------------------------------------
--
-- -----------------------------------------------------------
function conky_on_mouse(event)

  --
  -- TODO: 2026-11-12
  --   Should a mouse click toggle the color of this circle?
  --

  if event.type == "button_down" and event.button == "left" then
    -- print("clicked at " .. event.x .. ", " .. event.y)

    local dx = event.x - hand_pos_xx
    local dy = event.y - hand_pos_yy

    if (dx * dx + dy * dy) <= (hand_radius * hand_radius) then
      if true == display_flag then
        display_flag = false
      else
        display_flag = true
      end
    end
    return true
  end

  return false
end
