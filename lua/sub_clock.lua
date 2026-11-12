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
    if idx_hour24 - 1 == _hour24_now_hour then
      --
      -- 24 Hours Marks, now
      --
      draw_line_marks(_cr, _const_line_cap,
        _gConfig.Clock24.Center, _gConfig.Clock24.Radius, _array_times[idx_hour24][1][1].radian,
        _gConfig.Clock24.Hour24.Marks.Now.Radius, _gConfig.Clock24.Hour24.Marks.Now.Width,
        _gColor.Clock24.Hour24.Marks.Now)

    elseif idx_hour24 - 1 == _hour24_next_hour then
      --
      -- 24 Hours Marks, next
      --
      draw_line_marks(_cr, _const_line_cap,
        _gConfig.Clock24.Center, _gConfig.Clock24.Radius, _array_times[idx_hour24][1][1].radian,
        _gConfig.Clock24.Hour24.Marks.Next.Radius, _gConfig.Clock24.Hour24.Marks.Next.Width,
        _gColor.Clock24.Hour24.Marks.Next)

    else
      --
      -- 24 Hours Marks, normal
      --
      draw_line_marks(_cr, _const_line_cap,
        _gConfig.Clock24.Center, _gConfig.Clock24.Radius, _array_times[idx_hour24][1][1].radian,
        _gConfig.Clock24.Hour24.Marks.Normal.Radius, _gConfig.Clock24.Hour24.Marks.Normal.Width,
        _gColor.Clock24.Hour24.Marks.Normal)
    end


    --
    -- 30 Minutes Marks
    --

    draw_line_marks(_cr, _const_line_cap,
      _gConfig.Clock24.Center, _gConfig.Clock24.Radius, _array_times[idx_hour24][30 + 1][1].radian,
      _gConfig.Clock24.Minutes30.Marks.Radius, _gConfig.Clock24.Minutes30.Marks.Width,
      _gColor.Clock24.Minutes30.Marks)


    --
    -- 10 Minutes Marks
    --

    tmp_array = {10, 20, 40, 50}
    for ii = 1, #tmp_array, 1 do
      draw_line_marks(_cr, _const_line_cap,
        _gConfig.Clock24.Center, _gConfig.Clock24.Radius, _array_times[idx_hour24][tmp_array[ii] + 1][1].radian,
        _gConfig.Clock24.Minutes10.Marks.Radius, _gConfig.Clock24.Minutes10.Marks.Width,
        _gColor.Clock24.Minutes10.Marks)
    end


    --
    -- 5 Minutes Marks
    --

    tmp_array = {5, 15, 25, 35, 45, 55}
    for ii = 1, #tmp_array, 1 do
      draw_line_marks(_cr, _const_line_cap,
        _gConfig.Clock24.Center, _gConfig.Clock24.Radius, _array_times[idx_hour24][tmp_array[ii] + 1][1].radian,
        _gConfig.Clock24.Minutes05.Marks.Radius, _gConfig.Clock24.Minutes05.Marks.Width,
        _gColor.Clock24.Minutes05.Marks)
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
      draw_line_marks(_cr, _const_line_cap,
        _gConfig.Clock24.Center, _gConfig.Clock24.Radius, _array_times[idx_hour24][tmp_array[ii] + 1][1].radian,
        _gConfig.Clock24.Minutes01.Marks.Radius, _gConfig.Clock24.Minutes01.Marks.Width,
        _gColor.Clock24.Minutes01.Marks)
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

    if idx_hour24 - 1 == _hour24_now_hour then

      --
      -- Now
      --
      draw_text_hour24(_cr, _const_font_slant, _const_font_weight,
        _gConfig.Clock24.Hour24.Number.Now.Size, _gConfig.Clock24.Hour24.Number.Now.Face,
        string.format("%02d", idx_hour24 - 1),
        hour24_position, hour24_radian_adjust, _gConfig.Clock24.Hour24.Number.Now.Adjust,
        _gColor.Clock24.Hour24.Number.Now)

    elseif idx_hour24 - 1 == _hour24_next_hour then

      --
      -- Next
      --
      draw_text_hour24(_cr, _const_font_slant, _const_font_weight,
        _gConfig.Clock24.Hour24.Number.Next.Size, _gConfig.Clock24.Hour24.Number.Next.Face,
        string.format("%02d", idx_hour24 - 1),
        hour24_position, hour24_radian_adjust, _gConfig.Clock24.Hour24.Number.Next.Adjust,
        _gColor.Clock24.Hour24.Number.Next)

    else

      --
      -- Normal
      --
      draw_text_hour24(_cr, _const_font_slant, _const_font_weight,
        _gConfig.Clock24.Hour24.Number.Normal.Size, _gConfig.Clock24.Hour24.Number.Normal.Face,
        string.format("%02d", idx_hour24 - 1),
        hour24_position, hour24_radian_adjust, _gConfig.Clock24.Hour24.Number.Normal.Adjust,
        _gColor.Clock24.Hour24.Number.Normal)

    end

    cairo_restore(_cr)

  end

end
