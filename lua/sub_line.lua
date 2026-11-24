--
--
--

--
-- NOTE:
--   This function is executed only once at startup.
--
function draw_line_hand(_width, _height, _surface, _line_cap,
    _clock24_center_, _clock24_radius,
    _hand_radius_, _hand_radian, _hand_width, _point_size, _hand_color)

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

  local hand_pos = getting_two_points(
      _clock24_center_, _hand_radian, _clock24_radius + _hand_radius_.From)

  drawing_point(cr,
    hand_pos.xx, hand_pos.yy,
    _point_size, _hand_color)

  local tmp_pos = getting_two_points(
      _clock24_center_, _hand_radian, _clock24_radius + _hand_radius_.To)

  drawing_line(cr,
    hand_pos.xx, hand_pos.yy, tmp_pos.xx, tmp_pos.yy,
    _hand_width, _line_cap, _hand_color)

  -- Once drawing is complete, destroy only the context (keep the surface!)
  cairo_destroy(cr)

  return _surface, hand_pos.xx, hand_pos.yy, _point_size
end


function draw_line_info(_cr, _line_cap,
    _clock24_center_, _clock24_radius,
    _info_point_i_, _info_point_h_, _info_point_m_,
    _info_point_size, _info_width,
    _info_color_point, _info_color_line)

  drawing_point(_cr, _info_point_i_.xx, _info_point_i_.yy, _info_point_size, _info_color_point)
  drawing_point(_cr, _info_point_m_.xx, _info_point_m_.yy, _info_point_size, _info_color_point)
  drawing_point(_cr, _info_point_h_.xx, _info_point_h_.yy, _info_point_size, _info_color_point)

  drawing_line(_cr,
    _info_point_i_.xx, _info_point_i_.yy, _info_point_m_.xx, _info_point_m_.yy,
    _info_width, _line_cap, _info_color_line)

  drawing_line(_cr,
    _info_point_m_.xx, _info_point_m_.yy, _info_point_h_.xx, _info_point_h_.yy,
    _info_width, _line_cap, _info_color_line)
end


function draw_line_marks(_cr, _line_cap,
    _clock24_center_, _clock24_radius, _marks_radian,
    _marks_radius_, _marks_width, _marks_color)

  local tmp_from = getting_two_points(
      _clock24_center_, _marks_radian, _clock24_radius + _marks_radius_.From)
  local tmp_to   = getting_two_points(
      _clock24_center_, _marks_radian, _clock24_radius + _marks_radius_.To)

  drawing_line(_cr,
    tmp_from.xx, tmp_from.yy, tmp_to.xx, tmp_to.yy,
    _marks_width, _line_cap,
    _marks_color)
end
