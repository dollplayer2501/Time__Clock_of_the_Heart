--
--
--

--
-- NOTE:
--   This function performs an update only once per minute.
--
function sub_clock_func(_width, _height, _surface,
    _gConst, _gParse, _gConfig, _gColor,
    _line_cap, _font_slant, _font_weight,
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

    draw_line_marks(cr, _line_cap,
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

    draw_line_marks(cr, _line_cap,
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
      draw_line_marks(cr, _line_cap,
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
      draw_line_marks(cr, _line_cap,
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
      draw_line_marks(cr, _line_cap,
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
      draw_line_marks(cr, _line_cap,
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
    local hour24_position = getting_two_points(
        _gConfig.Clock24.Center, hour24_radian_base, _gConfig.Clock24.Radius)


    cairo_save(cr)


    -- 24 Hours Numbers, normal setting

    local tmp_size = _gConfig.Clock24.Hour24.Number.Normal.Size
    local tmp_face = _gConfig.Clock24.Hour24.Number.Normal.Face
    local tmp_adjust = _gConfig.Clock24.Hour24.Number.Normal.Adjust
    local tmp_color = _gColor.Clock24.Hour24.Number.Normal

    if 5 == idx then

      -- 24 Hours Numbers, now setting

      local tmp_delta = _gConfig.Clock24.Hour24.Number.Now.Size.Max - _gConfig.Clock24.Hour24.Number.Now.Size.Min
      tmp_size = _gConfig.Clock24.Hour24.Number.Now.Size.Max - (tmp_delta * (_gParse.Now.Minute / 60))

      tmp_face = _gConfig.Clock24.Hour24.Number.Now.Face
      tmp_adjust = _gConfig.Clock24.Hour24.Number.Now.Adjust
      tmp_color = _gColor.Clock24.Hour24.Number.Now

    elseif 6 == idx then

      -- 24 Hours Numbers, next setting

      local tmp_delta = _gConfig.Clock24.Hour24.Number.Next.Size.Max - _gConfig.Clock24.Hour24.Number.Next.Size.Min
      tmp_size = _gConfig.Clock24.Hour24.Number.Next.Size.Min + (tmp_delta * (_gParse.Now.Minute / 60))

      tmp_face = _gConfig.Clock24.Hour24.Number.Next.Face
      tmp_adjust = _gConfig.Clock24.Hour24.Number.Next.Adjust
      tmp_color = _gColor.Clock24.Hour24.Number.Next

    end

    draw_text_hour24(cr, _font_slant, _font_weight,
      tmp_size, tmp_face,
      string.format('%02d', _dic_times[idx].tt),
      hour24_position, hour24_radian_adjust, tmp_adjust,
      tmp_color)

    cairo_restore(cr)
  end

  -- Once drawing is complete, destroy only the context (keep the surface!)
  cairo_destroy(cr)

  return _surface
end


--
--
--
function sub_clock_ring(_cr,
    _now_second, _now_minute, _array_times,
    _clock24_center_, _clock24_radius,
    _radius_adjust, _width, _radius_, _line_cap, _color)

  --
  -- NOTE:
  --   Basic approach:
  --   1. The starting point of the time that has already elapsed is determined from the array.
  --   2. The end point of the upcoming period is determined based on the overall indices of the array.
  --   Consequently,
  --   there is no need to explicitly account for cases that span across days,
  --   as the array itself is structured to encompass such transitions.
  --

  local current_second_past = _now_second
  local hand_base_past = _now_minute
  local tmp_index_L_past = 5
  local tmp_index_S_past = hand_base_past - current_second_past
  if hand_base_past < current_second_past then
    tmp_index_L_past = 4
    tmp_index_S_past = 60 - (current_second_past - hand_base_past)
  end

  --

  local tmp_radian_past = _array_times[tmp_index_L_past][tmp_index_S_past + 1].radian
  local tmp_index_past = _array_times[tmp_index_L_past][tmp_index_S_past + 1].index

  local tmp_index_future = tmp_index_past + 60
  local tmp_radian_future = nil
  for idx = 1, 8, 1 do
    for idx_minutes = 0, 59, 1 do
      if tmp_index_future == _array_times[idx][idx_minutes + 1].index then
        tmp_radian_future = _array_times[idx][idx_minutes + 1].radian
        goto continue
      end
    end
  end
  ::continue::

  --

  drawing_ring(_cr,
    _clock24_center_.xx, _clock24_center_.yy,
    _clock24_radius + _radius_adjust,
    tmp_radian_past - (math.pi / 2), tmp_radian_future - (math.pi / 2),
    _width, _line_cap,
    _color)

  --

  local past_pos_start = getting_two_points(
      _clock24_center_, tmp_radian_past, _clock24_radius + _radius_.From)
  local past_pos_end = getting_two_points(
      _clock24_center_, tmp_radian_past, _clock24_radius + _radius_.To)

  drawing_line(_cr,
    past_pos_start.xx, past_pos_start.yy, past_pos_end.xx, past_pos_end.yy,
    _width, _line_cap,
    _color)

  --

  local future_pos_start = getting_two_points(
      _clock24_center_, tmp_radian_future, _clock24_radius + _radius_.From)
  local future_pos_end = getting_two_points(
      _clock24_center_, tmp_radian_future, _clock24_radius + _radius_.To)

  drawing_line(_cr,
    future_pos_end.xx, future_pos_end.yy,
    future_pos_start.xx, future_pos_start.yy,
    _width / 2, _line_cap,
    _color)

end

