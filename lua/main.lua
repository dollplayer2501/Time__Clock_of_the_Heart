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
local info_disp_timer = -1

--
-- Variables that holds a surface for caching purposes
--
local bg_surface = nil  -- Generated only once at startup
local min_surface = nil -- Generation and updating on a per-unit-time basis (e.g., for clock faces)
local last_minute = nil -- Used to refresh the screen at one-minute intervals.
local cached_width = 0
local cached_height = 0


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

  local start_ms = measure_start(gConfig.Measurement.Disp_flg)

  --
  -- Const
  --

  local const_one_day_seconds = 24 * 60 * 60
  local const_line_cap = gConst.Line.Cap.Square
  local const_font_slant = gConst.Font.Slant.Normal
  local const_font_weight = gConst.Font.Weight.Normal

  --
  -- Calculate Time, hour and relative day
  --
  -- NOTE:
  --   The following are being obtained:
  --   - The current time, as well as the times 4 hours prior and 3 hours ahead.
  --   - Do these span across different days?  --
  --   3 and 4 are fixed values, as this is the only range that gets displayed.
  --
  -- TODO: 2026-11-19
  --   - Using literals feels wrong.
  --   - Should I rewrite it to be more efficient?
  --

  local hour24_now_hh = gParse.Now.Hour24
  -- NOTE:
  --   `*_dd = 0`  is the current day,
  --   `*_dd = -1` is the previous day.
  --   `*_dd = 1`  is the following day,
  local hour24_now_dd = 0

  --
  -- Time elapsed so far (up to 4 hours ago)
  -- If the value is greater than the current time, it refers to the previous day
  --
  local hour24_prev_1_hh = (hour24_now_hh - 1) % 24
  local hour24_prev_1_dd = (hour24_now_hh < hour24_prev_1_hh) and -1 or 0
  local hour24_prev_2_hh = (hour24_now_hh - 2) % 24
  local hour24_prev_2_dd = (hour24_now_hh < hour24_prev_2_hh) and -1 or 0
  local hour24_prev_3_hh = (hour24_now_hh - 3) % 24
  local hour24_prev_3_dd = (hour24_now_hh < hour24_prev_3_hh) and -1 or 0
  local hour24_prev_4_hh = (hour24_now_hh - 4) % 24
  local hour24_prev_4_dd = (hour24_now_hh < hour24_prev_4_hh) and -1 or 0

  --
  -- The time period ahead, up to 3 hours from now
  -- If the value is less than the current time, it refers to the following day
  --
  local hour24_next_1_hh = (hour24_now_hh + 1) % 24
  local hour24_next_1_dd = (hour24_now_hh > hour24_next_1_hh) and 1 or 0
  local hour24_next_2_hh = (hour24_now_hh + 2) % 24
  local hour24_next_2_dd = (hour24_now_hh > hour24_next_2_hh) and 1 or 0
  local hour24_next_3_hh = (hour24_now_hh + 3) % 24
  local hour24_next_3_dd = (hour24_now_hh > hour24_next_3_hh) and 1 or 0

  local dic_times = {
      { dd = hour24_prev_4_dd, tt = hour24_prev_4_hh, }, -- 1
      { dd = hour24_prev_3_dd, tt = hour24_prev_3_hh, }, -- 2
      { dd = hour24_prev_2_dd, tt = hour24_prev_2_hh, }, -- 3
      { dd = hour24_prev_1_dd, tt = hour24_prev_1_hh, }, -- 4
      { dd = hour24_now_dd,    tt = hour24_now_hh,    }, -- 5: Now
      { dd = hour24_next_1_dd, tt = hour24_next_1_hh, }, -- 6: Next
      { dd = hour24_next_2_dd, tt = hour24_next_2_hh, }, -- 7
      { dd = hour24_next_3_dd, tt = hour24_next_3_hh, }, -- 8
    }

  --
  -- Calculate Hand
  --

  local hand_seconds = hhmmss_to_sec(gConfig.Hand.Marks.Hour24, gConfig.Hand.Marks.Minutes, gConfig.Hand.Marks.Seconds)
  local hand_radian = degree_to_radian(360 * (hand_seconds / const_one_day_seconds))

  --
  -- Where does the current time fall on a 24-hour clock?
  --
  -- NOTE:
  --   - If seconds were included, the clock would be in a state of constant motion.
  --     To avoid this, the calculation is intentionally limited to the minute level.
  --   - Lua array indices are 1-based, not 0-based.
  --
  -- TODO: 2026-11-19
  --   Or, give it a try?
  --   Update the clock face in 10-second or 30-second increments.
  --   Instead of 1-second intervals, only the radian positions corresponding to 10-second intervals are required.
  --

  local now_seconds = hhmmss_to_sec(gParse.Now.Hour24, gParse.Now.Minute)
  local now_radian = degree_to_radian(360 * (now_seconds / const_one_day_seconds))

  local array_times = {}
  for idx = 1, 8, 1 do
    array_times[idx] = {}
    for idx_minutes = 0, 59, 1 do
      array_times[idx][idx_minutes + 1] = {}

      local tmp_seconds = hhmmss_to_sec(dic_times[idx].tt, idx_minutes)
      local tmp_radian = degree_to_radian(360 * (tmp_seconds / const_one_day_seconds))
      array_times[idx][idx_minutes + 1] = {
        radian = tmp_radian - now_radian + hand_radian,
      }
    end
  end

  --

  local elapsed_ms_middle = measure_stop(gConfig.Measurement.Disp_flg, start_ms)

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
      array_times, dic_times)

    last_minute = current_minute
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
  -- Draw Line and Point, Information
  --
  local tmp_flg = false

  if true == info_disp_flg then
    if 0 >= gConfig.Info.Disp_timer then
      tmp_flg = true
    else
      local elapsed = os.time() - info_disp_timer
      if elapsed <= gConfig.Info.Disp_timer then
        tmp_flg = true
      else
        info_disp_flg = false
        info_disp_timer = -1
      end
    end
  end

  if true == tmp_flg then
    sub_special_func(cr, gConst, gParse, gConfig, gColor,
      const_line_cap, const_font_slant, const_font_weight,
      hand_radian)
  end

  --
  -- 24 hour clock, Marks and Numbers
  --
  -- Instantly paste the "1-minute cache"
  -- (this is the only part that takes 59 seconds!)
  --
  cairo_set_source_surface(cr, min_surface, 0, 0)
  cairo_paint(cr)

  --

  local elapsed_ms_last = measure_stop(gConfig.Measurement.Disp_flg, start_ms)
  measure_display(gConfig.Measurement.Disp_flg, cr, elapsed_ms_middle, elapsed_ms_last)

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
  --   2026-11-18: Since it’s only drawn once—at startup—this is going to require a fairly major overhaul.
  --
  -- TODO: 2026-11-14
  --   Adding behavior triggered by mouse hover
  --   2026-11-18: Same as above. Also, the implementation might turn out to be unexpectedly troublesome.
  --   2026-11-19: Add a border in an accent color around this white ring?
  --

  if event.type == 'button_down' and event.button == 'left' then

    local dx = event.x - hand_pos_xx
    local dy = event.y - hand_pos_yy

    if (dx * dx + dy * dy) <= (hand_radius * hand_radius) then
      if true == info_disp_flg then
        info_disp_flg = false
        info_disp_timer = -1
      else
        info_disp_flg = true
        info_disp_timer = os.time()
      end
    end
    return true
  end

  return false
end
