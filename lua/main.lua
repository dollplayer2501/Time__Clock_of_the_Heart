--
--
--

require 'cairo'
require 'cairo_xlib'

--

require './lua/const'
require './lua/functions'
require './lua/sub_parse'
require './lua/sub_line'
require './lua/sub_text'
require './lua/sub_clock'
require './lua/sub_special'

--
-- Make a decision between
-- './config/config_default.lua' and './config/config_me.lua',
-- './config/color_default.lua' and './config/color_me.lua'.
--

require './lua/main_pre'
local file_config_flg, file_color_flg = main_pre_func()

if true == file_config_flg then
  require './config/config_me'
else
  require './config/config_default'
end

if true == file_color_flg then
  require './config/color_me'
else
  require './config/color_default'
end


--
-- Global settings for capturing mouse events
--
local hand_pos_xx = -1
local hand_pos_yy = -1
local hand_radius = -1
local display_flag = false


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
        --
        -- TODO: 2026-11-16
        --   The script is not currently running on a second-by-second basis.
        --   Therefore, an array based on seconds might not be necessary.
        --
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
  -- 24 hour clock, Marks and Numbers
  --

  sub_clock_func(cr, gConst, gParse, gConfig, gColor,
    const_line_cap, const_font_slant, const_font_weight,
    hour24_now_hour, hour24_next_hour, array_times)


  --
  -- Cleanup
  --

  cairo_destroy(cr)
  cairo_surface_destroy(cs)
  cr = nil
end


-- -----------------------------------------------------------
-- NOTE:
--   Lua: Mouse Events · brndnmtthws/conky Wiki
--   https://github.com/brndnmtthws/conky/wiki/Lua:-Mouse-Events
-- -----------------------------------------------------------
function conky_on_mouse(event)

  --
  -- TODO: 2026-11-12
  --   Should a mouse click toggle the color of this circle?
  --
  -- TODO: 2026-11-14
  --   Adding behavior triggered by mouse hover
  --
  -- TODO: 2026-11-16
  --   When it’s in a visible state,
  --   implementing logic to have it disappear automatically—for example, after 10 seconds.
  --

  if event.type == 'button_down' and event.button == 'left' then

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
