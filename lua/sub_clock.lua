--
--
--

function sub_clock_func(_width, _height, _surface,
    _gConst, _gParse, _gConfig, _gColor,
    _const_line_cap, _const_font_slant, _const_font_weight,
    _array_times, _dic_times)

  local local_change_angle_of_radian = function(_now_radian, _change_degree)
    local tmp_deg = math.deg(_now_radian)
    tmp_deg = tmp_deg - _change_degree

    if tmp_deg < 0 then tmp_deg = tmp_deg + 360 end
    if tmp_deg >= 360 then tmp_deg = tmp_deg - 360 end

    return math.rad(tmp_deg)
  end

  --
  -- Discard any existing cache (as a precaution, e.g., for window resizing)
  --
  if _surface ~= nil then
    cairo_surface_destroy(_surface)
  end

  --
  -- Create a transparent RGBA surface in memory
  --
  _surface = cairo_image_surface_create(CAIRO_FORMAT_ARGB32, _width, _height)
  local cr = cairo_create(_surface)

  --

  for idx = 1, 8, 1 do

    --
    -- 24 Hours Marks
    --

    -- 24 Hours Marks, normal setting

    local tmp_radius = _gConfig.Clock24.Hour24.Marks.Normal.Radius
    local tmp_width = _gConfig.Clock24.Hour24.Marks.Normal.Width
    local tmp_color = _gColor.Clock24.Hour24.Marks.Normal

    if 5 == idx then

      -- 24 Hours Marks, now setting

      tmp_radius = _gConfig.Clock24.Hour24.Marks.Now.Radius
      tmp_width = _gConfig.Clock24.Hour24.Marks.Now.Width
      tmp_color = _gColor.Clock24.Hour24.Marks.Now

    elseif 6 == idx then

      -- 24 Hours Marks, next setting

      tmp_radius = _gConfig.Clock24.Hour24.Marks.Next.Radius
      tmp_width = _gConfig.Clock24.Hour24.Marks.Next.Width
      tmp_color = _gColor.Clock24.Hour24.Marks.Next
    end

    draw_line_marks(cr, _const_line_cap,
      _gConfig.Clock24.Center, _gConfig.Clock24.Radius, _array_times[idx][1].radian,
      tmp_radius, tmp_width, tmp_color)

    --
    -- 30 Minutes Marks
    --

    local tmp_width = (5 == idx)
      and _gConfig.Clock24.Minutes30.Marks.Width.Now
      or  _gConfig.Clock24.Minutes30.Marks.Width.Other

    local tmp_color = (5 == idx)
      and _gColor.Clock24.Minutes30.Marks.Now
      or  _gColor.Clock24.Minutes30.Marks.Other

    draw_line_marks(cr, _const_line_cap,
      _gConfig.Clock24.Center, _gConfig.Clock24.Radius, _array_times[idx][30 + 1].radian,
      _gConfig.Clock24.Minutes30.Marks.Radius, tmp_width, tmp_color)

    --
    -- 15 Minutes Marks
    --
    -- NOTE:
    --   Follows the same approach as 5 minutes,
    --   though the logic may not be particularly meaningful.
    --

    local tmp_width = (5 == idx)
      and _gConfig.Clock24.Minutes15.Marks.Width.Now
      or  _gConfig.Clock24.Minutes15.Marks.Width.Other

    local tmp_color = (5 == idx)
      and _gColor.Clock24.Minutes15.Marks.Now
      or  _gColor.Clock24.Minutes15.Marks.Other

    tmp_array = {15, 45}
    for ii = 1, #tmp_array, 1 do
      draw_line_marks(cr, _const_line_cap,
        _gConfig.Clock24.Center, _gConfig.Clock24.Radius, _array_times[idx][tmp_array[ii] + 1].radian,
        _gConfig.Clock24.Minutes15.Marks.Radius, tmp_width, tmp_color)
    end

    --
    -- 10 Minutes Marks
    --

    local tmp_width = (5 == idx)
      and _gConfig.Clock24.Minutes10.Marks.Width.Now
      or  _gConfig.Clock24.Minutes10.Marks.Width.Other

    local tmp_color = (5 == idx)
      and _gColor.Clock24.Minutes10.Marks.Now
      or  _gColor.Clock24.Minutes10.Marks.Other

    tmp_array = {10, 20, 40, 50}
    for ii = 1, #tmp_array, 1 do
      draw_line_marks(cr, _const_line_cap,
        _gConfig.Clock24.Center, _gConfig.Clock24.Radius, _array_times[idx][tmp_array[ii] + 1].radian,
        _gConfig.Clock24.Minutes10.Marks.Radius, tmp_width, tmp_color)
    end

    --
    -- 5 Minutes Marks
    --

    local tmp_width = (5 == idx)
      and _gConfig.Clock24.Minutes05.Marks.Width.Now
      or  _gConfig.Clock24.Minutes05.Marks.Width.Other

    local tmp_color = (5 == idx)
      and _gColor.Clock24.Minutes05.Marks.Now
      or  _gColor.Clock24.Minutes05.Marks.Other

    tmp_array = {5, 25, 35, 55}
    for ii = 1, #tmp_array, 1 do
      draw_line_marks(cr, _const_line_cap,
        _gConfig.Clock24.Center, _gConfig.Clock24.Radius, _array_times[idx][tmp_array[ii] + 1].radian,
        _gConfig.Clock24.Minutes05.Marks.Radius, tmp_width, tmp_color)
    end

    --
    -- 1 Minute Marks
    --

    local tmp_width = (5 == idx)
      and _gConfig.Clock24.Minutes01.Marks.Width.Now
      or  _gConfig.Clock24.Minutes01.Marks.Width.Other

    local tmp_color = (5 == idx)
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
      draw_line_marks(cr, _const_line_cap,
        _gConfig.Clock24.Center, _gConfig.Clock24.Radius, _array_times[idx][tmp_array[ii] + 1].radian,
        _gConfig.Clock24.Minutes01.Marks.Radius, tmp_width, tmp_color)
    end

    --
    -- 24 Hours Numbers
    --

    -- Get display angle
    local hour24_radian_base = _array_times[idx][1].radian
    local hour24_radian_adjust = local_change_angle_of_radian(hour24_radian_base, 90)

    -- Get display position
    local hour24_position = {
        xx = _gConfig.Clock24.Center.xx + (math.sin(hour24_radian_base) * _gConfig.Clock24.Radius),
        yy = _gConfig.Clock24.Center.yy - (math.cos(hour24_radian_base) * _gConfig.Clock24.Radius),
      }

    cairo_save(cr)

    -- 24 Hours Numbers, normal setting

    --
    -- TODO: 2026-11-19
    --   Just jotting down an idea for a somewhat pointless implementation:
    --   make the text for the upcoming time increment larger at the 30, 40, and 50-minute marks—or, alternatively,
    --   have the text gradually increase in size in 10-minute intervals.
    --   In either case, the approach could simply involve defining a minimum and maximum font size,
    --   then calculating the specific size for any given moment.
    --

    local tmp_size = _gConfig.Clock24.Hour24.Number.Normal.Size
    local tmp_face = _gConfig.Clock24.Hour24.Number.Normal.Face
    local tmp_adjust = _gConfig.Clock24.Hour24.Number.Normal.Adjust
    local tmp_color = _gColor.Clock24.Hour24.Number.Normal

    if 5 == idx then

      -- 24 Hours Numbers, now setting

      tmp_size = _gConfig.Clock24.Hour24.Number.Now.Size
      tmp_face = _gConfig.Clock24.Hour24.Number.Now.Face
      tmp_adjust = _gConfig.Clock24.Hour24.Number.Now.Adjust
      tmp_color = _gColor.Clock24.Hour24.Number.Now

    elseif 6 == idx then

      -- 24 Hours Numbers, next setting

      tmp_size = _gConfig.Clock24.Hour24.Number.Next.Size
      tmp_face = _gConfig.Clock24.Hour24.Number.Next.Face
      tmp_adjust = _gConfig.Clock24.Hour24.Number.Next.Adjust
      tmp_color = _gColor.Clock24.Hour24.Number.Next

    end

    draw_text_hour24(cr, _const_font_slant, _const_font_weight,
      tmp_size, tmp_face,
      string.format("%02d", _dic_times[idx].tt),
      hour24_position, hour24_radian_adjust, tmp_adjust,
      tmp_color)

    cairo_restore(cr)
  end

  -- Once drawing is complete, destroy only the context (keep the surface!)
  cairo_destroy(cr)

  return _surface
end
