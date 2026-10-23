--
--
--

require 'cairo'
require 'cairo_xlib'

require './conky_global_const'
require './conky_functions'
require './conky_sub_parse'
require './conky_sub_line'
require './conky_sub_text'

require './conky_my_config'


--
--
--
function conky_main()

  --
  -- Basic settings
  --

  local gConst = get_const()
  local gConfig = get_config(gConst)
  local gParse = get_conky_parse()

  dofile(gConfig.Color_scheme)
  local gColor = get_color()

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

  local local_hhmmss_to_sec = function(_hour24, _minutes, _seconds)
    _seconds = tonumber(_seconds) or 0
    return (_hour24 * 60 * 60) + (_minutes * 60) + _seconds
  end

  local local_degree_radian = function(_degree)
    local tmp_degree = (360 == _degree) and 0 or _degree
    return math.rad(tmp_degree)
  end

  local local_triming = function(_str)
    return (string.gsub(_str, '^%s*(.-)%s*$', '%1'))
  end

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

  local tmp_seconds = local_hhmmss_to_sec(gConfig.Hand.Marks.Hour24, gConfig.Hand.Marks.Minutes, gConfig.Hand.Marks.Seconds)
  local hand_radian = local_degree_radian(360 * (tmp_seconds / const_one_day_seconds))


  --
  -- Where does the current time fall on a 24-hour clock?
  --

  local tmp_seconds = local_hhmmss_to_sec(gParse.Now.Hour24, gParse.Now.Minute)
  local now_radian = local_degree_radian(360 * (tmp_seconds / const_one_day_seconds))

  local array_times = {}
  array_times = {}
  for idx_hour24 = 0, 23, 1 do
    array_times[idx_hour24 + 1] = {}

    for idx_minutes = 0, 59, 1 do
      array_times[idx_hour24 + 1][idx_minutes + 1] = {}

      for idx_seconds = 0, 59, 1 do
        local tmp_seconds = local_hhmmss_to_sec(idx_hour24, idx_minutes)
        local tmp_radian = local_degree_radian(360 * (tmp_seconds / const_one_day_seconds))
        array_times[idx_hour24 + 1][idx_minutes + 1][idx_seconds + 1] = {
          radian = tmp_radian - now_radian + hand_radian,
        }
      end
    end
  end


  --
  -- Draw Hand
  --

  draw_line_hand(cr, const_line_cap,
    gConfig.Clock24.Center, gConfig.Clock24.Radius,
    gConfig.Hand.Radius, hand_radian,
    gConfig.Hand.Width, gColor.Hand.Marks)


  --
  -- Draw Line, Information
  --

  local tmp_point_random = math.floor(gParse.Now.Second / gConfig.Info.Update_interval) * 1

  -- Starting point of the information display area
  local info_point_i = {
    xx = gConfig.Info.Info.Point.xx + tmp_point_random,
    yy = gConfig.Info.Info.Point.yy + tmp_point_random,
  }

  -- The intersection of hand and the clock frame. In other words, the current time.
  local info_point_h = {
    xx = gConfig.Clock24.Center.xx + (math.sin(hand_radian) * gConfig.Clock24.Radius),
    yy = gConfig.Clock24.Center.yy - (math.cos(hand_radian) * gConfig.Clock24.Radius),
  }

  -- The superfluous point midway between the above.
  local info_point_m = {
    xx = gConfig.Clock24.Center.xx + ((math.sin(hand_radian) * gConfig.Clock24.Radius) + gConfig.Info.Middle.Adjust.xx),
    yy = gConfig.Clock24.Center.yy - ((math.cos(hand_radian) * gConfig.Clock24.Radius) + gConfig.Info.Middle.Adjust.yy),
  }

  drawing_point(cr, info_point_i.xx, info_point_i.yy, gConfig.Info.Point_size, gColor.Info.Point)
  drawing_point(cr, info_point_h.xx, info_point_h.yy, gConfig.Info.Point_size, gColor.Info.Point)
  drawing_point(cr, info_point_m.xx, info_point_m.yy, gConfig.Info.Point_size, gColor.Info.Point)

  drawing_line(cr,
    info_point_h.xx, info_point_h.yy, info_point_m.xx, info_point_m.yy,
    gConfig.Info.Line.Width, const_line_cap,
    gColor.Info.Line)

  drawing_line(cr,
    info_point_m.xx, info_point_m.yy, info_point_i.xx, info_point_i.yy,
    gConfig.Info.Line.Width, const_line_cap,
    gColor.Info.Line)


  --
  -- Draw Text, Information
  --

  cairo_save(cr)


  -- Time, HH:MM

  local tmp_string = gParse.Now.time_short
  local extents_hhmm = draw_text_time_hhmm(cr, const_font_slant, const_font_weight,
    gConfig.Info.Text.Time_hhmm.Size, gConfig.Info.Text.Face, tmp_string,
    info_point_i, local_degree_radian(gConfig.Info.Text.Angle_degree),
    gConfig.Info.Text.Time_hhmm.Adjust, gColor.Info.Text)

  -- Time, SS

  local tmp_string = string.format(':%02d', gParse.Now.Second)
  draw_text_time_ss(cr,
    gConfig.Info.Text.Time_ss.Size, tmp_string,
    gConfig.Info.Text.Time_hhmm.Adjust, extents_hhmm.x_advance, gConfig.Info.Text.Time_ss.Adjust)

  --

  local tmp_gap_yy = (-1 * extents_hhmm.y_bearing / 2) + gConfig.Info.Text.Full_date.Adjust.yy

  -- Full date

  local tmp_string = gParse.Now.date_full
  draw_text_full_date(cr,
    gConfig.Info.Text.Full_date.Size, tmp_string,
    gConfig.Info.Text.Time_hhmm.Adjust.xx, gConfig.Info.Text.Full_date.Adjust, tmp_gap_yy)

  --
  -- Many font settings are carried over as-is from the previous section, so they have not been explicitly specified here.
  --

  if true == gConfig.Info.Text.Other.Other_display_flag then
    --
    -- Package update info
    --   NOTE:
    --     I use EndeavourOS, in other words, it is based on Arch Linux.
    --

    local tmp_string = string.format('All packages are %d, no need to update!', gParse.Packages.packman_Q)
    if 0 < gParse.Packages.checkupdates then
      tmp_string = string.format('%d out of %d packages require updating.', gParse.Packages.checkupdates, gParse.Packages.packman_Q)
    end
    tmp_gap_yy = tmp_gap_yy + gConfig.Info.Text.Other.First_gap_yy

    draw_text_others(cr,
      gConfig.Info.Text.Other.Size, tmp_string,
      gConfig.Info.Text.Full_date.Adjust.xx, gConfig.Info.Text.Other.Adjust_xx,
      tmp_gap_yy)
  end


  --
  -- **This is dangerous territory.**
  -- The reason is that I am running Fish shell functions and Python scripts that I created myself.
  --

  if true == gConfig.Info.Text.Other.Other_display_flag and true == gConfig.Info.Text.Other.Special_display_flag then

    -- Time elapsed since the PC was started

    local tmp_string = string.format('%s, %s uptime.', gParse.Commands.Special.uptime, local_triming(gParse.Commands.Normal.hostname))
    tmp_gap_yy = tmp_gap_yy + gConfig.Info.Text.Other.Second_gap_yy

    draw_text_others(cr,
      gConfig.Info.Text.Other.Size, tmp_string,
      gConfig.Info.Text.Full_date.Adjust.xx, gConfig.Info.Text.Other.Adjust_xx,
      tmp_gap_yy)

    -- Time elapsed since login

    local tmp_string = string.format('%s, %s login.', gParse.Commands.Special.login, local_triming(gParse.Commands.Normal.whoami))
    tmp_gap_yy = tmp_gap_yy + gConfig.Info.Text.Other.Second_gap_yy

    draw_text_others(cr,
      gConfig.Info.Text.Other.Size, tmp_string,
      gConfig.Info.Text.Full_date.Adjust.xx, gConfig.Info.Text.Other.Adjust_xx,
      tmp_gap_yy)
  end

  --

  cairo_restore(cr)


  --
  -- Marks and Numbers
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
