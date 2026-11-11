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
  -- Anonymous functions
  --

  local local_change_angle_of_radian = function(_now_radian, _change_degree)
    local tmp_deg = math.deg(_now_radian)
    tmp_deg = tmp_deg - _change_degree

    if tmp_deg < 0 then tmp_deg = tmp_deg + 360 end
    if tmp_deg >= 360 then tmp_deg = tmp_deg - 360 end

    return math.rad(tmp_deg)
  end


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
  -- TODO: 2026-11-12
  --   This logic will be moved elsewhere?
  --

  for idx_hour24 = 1, 24, 1 do

    --
    -- 24 Hours Marks
    --
    if idx_hour24 - 1 == hour24_now_hour then
      --
      -- 24 Hours Marks, now
      --
      draw_line_marks(cr, const_line_cap,
        gConfig.Clock24.Center, gConfig.Clock24.Radius, array_times[idx_hour24][1][1].radian,
        gConfig.Clock24.Hour24.Marks.Now.Radius, gConfig.Clock24.Hour24.Marks.Now.Width,
        gColor.Clock24.Hour24.Marks.Now)

    elseif idx_hour24 - 1 == hour24_next_hour then
      --
      -- 24 Hours Marks, next
      --
      draw_line_marks(cr, const_line_cap,
        gConfig.Clock24.Center, gConfig.Clock24.Radius, array_times[idx_hour24][1][1].radian,
        gConfig.Clock24.Hour24.Marks.Next.Radius, gConfig.Clock24.Hour24.Marks.Next.Width,
        gColor.Clock24.Hour24.Marks.Next)

    else
      --
      -- 24 Hours Marks, normal
      --
      draw_line_marks(cr, const_line_cap,
        gConfig.Clock24.Center, gConfig.Clock24.Radius, array_times[idx_hour24][1][1].radian,
        gConfig.Clock24.Hour24.Marks.Normal.Radius, gConfig.Clock24.Hour24.Marks.Normal.Width,
        gColor.Clock24.Hour24.Marks.Normal)
    end


    --
    -- 30 Minutes Marks
    --

    draw_line_marks(cr, const_line_cap,
      gConfig.Clock24.Center, gConfig.Clock24.Radius, array_times[idx_hour24][30 + 1][1].radian,
      gConfig.Clock24.Minutes30.Marks.Radius, gConfig.Clock24.Minutes30.Marks.Width,
      gColor.Clock24.Minutes30.Marks)


    --
    -- 10 Minutes Marks
    --

    tmp_array = {10, 20, 40, 50}
    for ii = 1, #tmp_array, 1 do
      draw_line_marks(cr, const_line_cap,
        gConfig.Clock24.Center, gConfig.Clock24.Radius, array_times[idx_hour24][tmp_array[ii] + 1][1].radian,
        gConfig.Clock24.Minutes10.Marks.Radius, gConfig.Clock24.Minutes10.Marks.Width,
        gColor.Clock24.Minutes10.Marks)
    end


    --
    -- 5 Minutes Marks
    --

    tmp_array = {5, 15, 25, 35, 45, 55}
    for ii = 1, #tmp_array, 1 do
      draw_line_marks(cr, const_line_cap,
        gConfig.Clock24.Center, gConfig.Clock24.Radius, array_times[idx_hour24][tmp_array[ii] + 1][1].radian,
        gConfig.Clock24.Minutes05.Marks.Radius, gConfig.Clock24.Minutes05.Marks.Width,
        gColor.Clock24.Minutes05.Marks)
    end


    --
    -- 1 Minute Marks
    --

    tmp_array = {
       1,  2,  3,  4,  6,  7,  8 , 9,
      11, 12, 13, 14, 16, 17, 18, 19,
      21, 22, 23, 24, 26, 27, 28, 29,
      31, 32, 33, 34, 36, 37, 38, 39,
      41, 42, 43, 44, 46, 47, 48, 49,
      51, 52, 53, 54, 56, 57, 58, 59,
    }
    for ii = 1, #tmp_array, 1 do
      draw_line_marks(cr, const_line_cap,
        gConfig.Clock24.Center, gConfig.Clock24.Radius, array_times[idx_hour24][tmp_array[ii] + 1][1].radian,
        gConfig.Clock24.Minutes01.Marks.Radius, gConfig.Clock24.Minutes01.Marks.Width,
        gColor.Clock24.Minutes01.Marks)
    end


    --
    -- 24 Hours Numbers
    --

    -- Get display angle
    local hour24_radian_base = array_times[idx_hour24][1][1].radian
    local hour24_radian_adjust = local_change_angle_of_radian(hour24_radian_base, 90)

    -- Get display position
    local hour24_position = {
        xx = gConfig.Clock24.Center.xx + (math.sin(hour24_radian_base) * gConfig.Clock24.Radius),
        yy = gConfig.Clock24.Center.yy - (math.cos(hour24_radian_base) * gConfig.Clock24.Radius),
      }


    cairo_save(cr)

    if idx_hour24 - 1 == hour24_now_hour then

      --
      -- Now
      --
      draw_text_hour24(cr, const_font_slant, const_font_weight,
        gConfig.Clock24.Hour24.Number.Now.Size, gConfig.Clock24.Hour24.Number.Now.Face,
        string.format("%02d", idx_hour24 - 1),
        hour24_position, hour24_radian_adjust, gConfig.Clock24.Hour24.Number.Now.Adjust,
        gColor.Clock24.Hour24.Number.Now)

    elseif idx_hour24 - 1 == hour24_next_hour then

      --
      -- Next
      --
      draw_text_hour24(cr, const_font_slant, const_font_weight,
        gConfig.Clock24.Hour24.Number.Next.Size, gConfig.Clock24.Hour24.Number.Next.Face,
        string.format("%02d", idx_hour24 - 1),
        hour24_position, hour24_radian_adjust, gConfig.Clock24.Hour24.Number.Next.Adjust,
        gColor.Clock24.Hour24.Number.Next)

    else

      --
      -- Normal
      --
      draw_text_hour24(cr, const_font_slant, const_font_weight,
        gConfig.Clock24.Hour24.Number.Normal.Size, gConfig.Clock24.Hour24.Number.Normal.Face,
        string.format("%02d", idx_hour24 - 1),
        hour24_position, hour24_radian_adjust, gConfig.Clock24.Hour24.Number.Normal.Adjust,
        gColor.Clock24.Hour24.Number.Normal)

    end

    cairo_restore(cr)

  end


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
