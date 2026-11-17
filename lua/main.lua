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
require './lua/main_measure'

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
local info_disp_flg = false

--
-- Variables that holds a surface for caching purposes
--
local bg_surface = nil -- Generated only once at startup
local cached_width = 0
local cached_height = 0

-- Cache for elements that update every minute
local min_surface = nil -- Generation and updating on a per-unit-time basis (e.g., for clock faces)
last_minute = ""


-- -----------------------------------------------------------
--
-- -----------------------------------------------------------
function conky_main()
  if conky_window == nil then return end

  --
  -- Basic settings
  --

  local gConst = get_const()
  local gParse = get_conky_parse()
  local gConfig = get_config(gConst)
  local gColor = get_color()

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

  local start_ms = measure_start(gConfig.Measurement.Disp_flg)

  --

  local conky_win_w = conky_window.width
  local conky_win_h = conky_window.height
  local current_minute = gParse.Now.Minute

  --
  -- Draw Line, Hand
  --
  -- Generate the cache only upon the initial execution or when the window size changes
  --
  if bg_surface == nil or
     cached_width ~= conky_win_w or
     cached_height ~= conky_win_h then

    bg_surface, hand_pos_xx, hand_pos_yy, hand_radius = draw_line_hand(conky_win_w, conky_win_h,
      bg_surface, const_line_cap,
      gConfig.Clock24.Center, gConfig.Clock24.Radius,
      gConfig.Hand.Radius, hand_radian,
      gConfig.Hand.Width, gConfig.Hand.Point_size, gColor.Hand.Marks)

    cached_width = conky_win_w
    cached_height = conky_win_h
  end

  --
  -- 24 hour clock, Marks and Numbers
  --
  -- Cache is updated only upon initial load, when the window size changes,
  -- or when the minute changes (i.e., when the seconds reach 00).
  --
  if min_surface == nil or
     current_minute ~= last_minute or
     cached_width ~= conky_win_w or
     cached_height ~= conky_win_h then

    min_surface = sub_clock_func(conky_win_w, conky_win_h, min_surface,
      gConst, gParse, gConfig, gColor,
      const_line_cap, const_font_slant, const_font_weight,
      hour24_now_hour, hour24_next_hour, array_times)

    last_minute = current_minute
    -- cached_width = conky_win_w
    -- cached_height = conky_win_h
  end

  --
  -- Something like a good-luck charm
  --

  local surface = conky_surface()
  if not surface then return end
  local cr = cairo_create(surface)
  cairo_rotate(cr, gConfig.Environment.Angle * (math.pi / 180))


  --
  -- Draw Line, Hand
  --
  -- Instantly apply the cached static background
  --

  cairo_set_source_surface(cr, bg_surface, 0, 0)
  cairo_paint(cr)


  --
  -- Draw Line, Hand
  --

--  hand_pos_xx, hand_pos_yy, hand_radius = draw_line_hand(cr, const_line_cap,
--    gConfig.Clock24.Center, gConfig.Clock24.Radius,
--    gConfig.Hand.Radius, hand_radian,
--    gConfig.Hand.Width, gConfig.Hand.Point_size, gColor.Hand.Marks)


  --
  -- Draw Line and Point, Information
  --

  if true == info_disp_flg then
    sub_special_func(cr, gConst, gParse, gConfig, gColor,
      const_line_cap, const_font_slant, const_font_weight,
      hand_radian)
  end


  --
  -- 24 hour clock, Marks and Numbers
  --

--  sub_clock_func(cr, gConst, gParse, gConfig, gColor,
--    const_line_cap, const_font_slant, const_font_weight,
--    hour24_now_hour, hour24_next_hour, array_times)


  --
  -- 24 hour clock, Marks and Numbers
  --
  -- Instantly paste the "1-minute cache"
  -- (this is the only part that takes 59 seconds!)
  --

  cairo_set_source_surface(cr, min_surface, 0, 0)
  cairo_paint(cr)




  --

  elapsed_ms = measure_stop(gConfig.Measurement.Disp_flg, start_ms)
  measure_display(gConfig.Measurement.Disp_flg, cr, elapsed_ms)


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
      if true == info_disp_flg then
        info_disp_flg = false
      else
        info_disp_flg = true
      end
    end
    return true
  end

  return false
end
