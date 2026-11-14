--
--
--

function sub_clock_func(_cr, _gConst, _gParse, _gConfig, _gColor,
    _const_line_cap, _const_font_slant, _const_font_weight,
    _hour24_now_hour, _hour24_next_hour, _array_times)


  local local_change_angle_of_radian = function(_now_radian, _change_degree)
    local tmp_deg = math.deg(_now_radian)
    tmp_deg = tmp_deg - _change_degree

    if tmp_deg < 0 then tmp_deg = tmp_deg + 360 end
    if tmp_deg >= 360 then tmp_deg = tmp_deg - 360 end

    return math.rad(tmp_deg)
  end


  for idx_hour24 = 1, 24, 1 do

    --
    -- 24 Hours Marks
    --

    -- 24 Hours Marks, normal setting

    local tmp_radius = _gConfig.Clock24.Hour24.Marks.Normal.Radius
    local tmp_width = _gConfig.Clock24.Hour24.Marks.Normal.Width
    local tmp_color = _gColor.Clock24.Hour24.Marks.Normal

    if idx_hour24 - 1 == _hour24_now_hour then

      -- 24 Hours Marks, now setting

      tmp_radius = _gConfig.Clock24.Hour24.Marks.Now.Radius
      tmp_width = _gConfig.Clock24.Hour24.Marks.Now.Width
      tmp_color = _gColor.Clock24.Hour24.Marks.Now

    elseif idx_hour24 - 1 == _hour24_next_hour then

      -- 24 Hours Marks, next setting

      tmp_radius = _gConfig.Clock24.Hour24.Marks.Next.Radius
      tmp_width = _gConfig.Clock24.Hour24.Marks.Next.Width
      tmp_color = _gColor.Clock24.Hour24.Marks.Next
    end

    draw_line_marks(_cr, _const_line_cap,
      _gConfig.Clock24.Center, _gConfig.Clock24.Radius, _array_times[idx_hour24][1][1].radian,
      tmp_radius, tmp_width, tmp_color)


    --
    -- 30 Minutes Marks
    --

    local tmp_width = idx_hour24 - 1 == _hour24_now_hour
      and _gConfig.Clock24.Minutes30.Marks.Width.Now
      or  _gConfig.Clock24.Minutes30.Marks.Width.Other

    local tmp_color = idx_hour24 - 1 == _hour24_now_hour
      and _gColor.Clock24.Minutes30.Marks.Now
      or  _gColor.Clock24.Minutes30.Marks.Other

    draw_line_marks(_cr, _const_line_cap,
      _gConfig.Clock24.Center, _gConfig.Clock24.Radius, _array_times[idx_hour24][30 + 1][1].radian,
      _gConfig.Clock24.Minutes30.Marks.Radius, tmp_width, tmp_color)


    --
    -- 15 Minutes Marks
    --

    local tmp_width = idx_hour24 - 1 == _hour24_now_hour
      and _gConfig.Clock24.Minutes15.Marks.Width.Now
      or  _gConfig.Clock24.Minutes15.Marks.Width.Other

    local tmp_color = idx_hour24 - 1 == _hour24_now_hour
      and _gColor.Clock24.Minutes15.Marks.Now
      or  _gColor.Clock24.Minutes15.Marks.Other

    tmp_array = {15, 45}
    for ii = 1, #tmp_array, 1 do
      draw_line_marks(_cr, _const_line_cap,
        _gConfig.Clock24.Center, _gConfig.Clock24.Radius, _array_times[idx_hour24][tmp_array[ii] + 1][1].radian,
        _gConfig.Clock24.Minutes15.Marks.Radius, tmp_width, tmp_color)
    end

    --
    -- 10 Minutes Marks
    --

    local tmp_width = idx_hour24 - 1 == _hour24_now_hour
      and _gConfig.Clock24.Minutes10.Marks.Width.Now
      or  _gConfig.Clock24.Minutes10.Marks.Width.Other

    local tmp_color = idx_hour24 - 1 == _hour24_now_hour
      and _gColor.Clock24.Minutes10.Marks.Now
      or  _gColor.Clock24.Minutes10.Marks.Other

    tmp_array = {10, 20, 40, 50}
    for ii = 1, #tmp_array, 1 do
      draw_line_marks(_cr, _const_line_cap,
        _gConfig.Clock24.Center, _gConfig.Clock24.Radius, _array_times[idx_hour24][tmp_array[ii] + 1][1].radian,
        _gConfig.Clock24.Minutes10.Marks.Radius, tmp_width, tmp_color)
    end


    --
    -- 5 Minutes Marks
    --

    local tmp_width = idx_hour24 - 1 == _hour24_now_hour
      and _gConfig.Clock24.Minutes05.Marks.Width.Now
      or  _gConfig.Clock24.Minutes05.Marks.Width.Other

    local tmp_color = idx_hour24 - 1 == _hour24_now_hour
      and _gColor.Clock24.Minutes05.Marks.Now
      or  _gColor.Clock24.Minutes05.Marks.Other

    tmp_array = {5, 25, 35, 55}
    for ii = 1, #tmp_array, 1 do
      draw_line_marks(_cr, _const_line_cap,
        _gConfig.Clock24.Center, _gConfig.Clock24.Radius, _array_times[idx_hour24][tmp_array[ii] + 1][1].radian,
        _gConfig.Clock24.Minutes05.Marks.Radius, tmp_width, tmp_color)
    end


    --
    -- 1 Minute Marks
    --

    local tmp_width = idx_hour24 - 1 == _hour24_now_hour
      and _gConfig.Clock24.Minutes01.Marks.Width.Now
      or  _gConfig.Clock24.Minutes01.Marks.Width.Other

    local tmp_color = idx_hour24 - 1 == _hour24_now_hour
      and _gColor.Clock24.Minutes01.Marks.Now
      or  _gColor.Clock24.Minutes01.Marks.Other

    tmp_array = {
       1,  2,  3,  4,  6,  7,  8 , 9,
      11, 12, 13, 14, 16, 17, 18, 19,
      21, 22, 23, 24, 26, 27, 28, 29,
      31, 32, 33, 34, 36, 37, 38, 39,
      41, 42, 43, 44, 46, 47, 48, 49,
      51, 52, 53, 54, 56, 57, 58, 59,
    }
    for ii = 1, #tmp_array, 1 do
      draw_line_marks(_cr, _const_line_cap,
        _gConfig.Clock24.Center, _gConfig.Clock24.Radius, _array_times[idx_hour24][tmp_array[ii] + 1][1].radian,
        _gConfig.Clock24.Minutes01.Marks.Radius, tmp_width, tmp_color)
    end


    --
    -- 24 Hours Numbers
    --

    -- Get display angle
    local hour24_radian_base = _array_times[idx_hour24][1][1].radian
    local hour24_radian_adjust = local_change_angle_of_radian(hour24_radian_base, 90)

    -- Get display position
    local hour24_position = {
        xx = _gConfig.Clock24.Center.xx + (math.sin(hour24_radian_base) * _gConfig.Clock24.Radius),
        yy = _gConfig.Clock24.Center.yy - (math.cos(hour24_radian_base) * _gConfig.Clock24.Radius),
      }


    cairo_save(_cr)


    -- 24 Hours Numbers, normal setting

    local tmp_size = _gConfig.Clock24.Hour24.Number.Normal.Size
    local tmp_face = _gConfig.Clock24.Hour24.Number.Normal.Face
    local tmp_adjust = _gConfig.Clock24.Hour24.Number.Normal.Adjust
    local tmp_color = _gColor.Clock24.Hour24.Number.Normal

    if idx_hour24 - 1 == _hour24_now_hour then

      -- 24 Hours Numbers, now setting

      tmp_size = _gConfig.Clock24.Hour24.Number.Now.Size
      tmp_face = _gConfig.Clock24.Hour24.Number.Now.Face
      tmp_adjust = _gConfig.Clock24.Hour24.Number.Now.Adjust
      tmp_color = _gColor.Clock24.Hour24.Number.Now

    elseif idx_hour24 - 1 == _hour24_next_hour then

      -- 24 Hours Numbers, next setting

      tmp_size = _gConfig.Clock24.Hour24.Number.Next.Size
      tmp_face = _gConfig.Clock24.Hour24.Number.Next.Face
      tmp_adjust = _gConfig.Clock24.Hour24.Number.Next.Adjust
      tmp_color = _gColor.Clock24.Hour24.Number.Next

    end

    draw_text_hour24(_cr, _const_font_slant, _const_font_weight,
      tmp_size, tmp_face,
      string.format("%02d", idx_hour24 - 1),
      hour24_position, hour24_radian_adjust, tmp_adjust,
      tmp_color)


    cairo_restore(_cr)

  end

end
