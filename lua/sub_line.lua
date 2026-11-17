--
--
--

function draw_line_hand(_width, _height, _bg_surface, _const_line_cap,
    _Clock24_Center_, _Clock24_Radius,
    _Hand_Radius_, _hand_radian, _Hand_Width, _Point_size, _Hand_Color)

  --
  -- Discard any existing cache (as a precaution, e.g., for window resizing)
  --
  if _bg_surface ~= nil then
    cairo_surface_destroy(_bg_surface)
  end

  --
  -- Create a transparent RGBA surface in memory
  --
  _bg_surface = cairo_image_surface_create(CAIRO_FORMAT_ARGB32, _width, _height)
  local cr_bg = cairo_create(_bg_surface)

  --

  local tmp_xx = _Clock24_Center_.xx + (math.sin(_hand_radian) * (_Clock24_Radius + _Hand_Radius_.From))
  local tmp_yy = _Clock24_Center_.yy - (math.cos(_hand_radian) * (_Clock24_Radius + _Hand_Radius_.From))

  drawing_point(cr_bg,
    tmp_xx, tmp_yy,
    _Point_size, _Hand_Color)

  drawing_line(cr_bg,
    tmp_xx, tmp_yy,
    _Clock24_Center_.xx + (math.sin(_hand_radian) * (_Clock24_Radius + _Hand_Radius_.To)),
    _Clock24_Center_.yy - (math.cos(_hand_radian) * (_Clock24_Radius + _Hand_Radius_.To)),
    _Hand_Width, _const_line_cap, _Hand_Color)

  -- Once drawing is complete, destroy only the context (keep the bg_surface!)
  cairo_destroy(cr_bg)

  return _bg_surface, tmp_xx, tmp_yy, _Point_size
end


function draw_line_info(_cr, _const_line_cap,
    _Clock24_Center_, _Clock24_Radius,
    _info_point_i_, _info_point_h_, _info_point_m_,
    _Info_point_size, _Info_Width,
    _Info_Color_point, _Info_Color_line)

  drawing_point(_cr, _info_point_i_.xx, _info_point_i_.yy, _Info_point_size, _Info_Color_point)
  drawing_point(_cr, _info_point_m_.xx, _info_point_m_.yy, _Info_point_size, _Info_Color_point)
  drawing_point(_cr, _info_point_h_.xx, _info_point_h_.yy, _Info_point_size, _Info_Color_point)

  drawing_line(_cr,
    _info_point_i_.xx, _info_point_i_.yy, _info_point_m_.xx, _info_point_m_.yy,
    _Info_Width, _const_line_cap, _Info_Color_line)

  drawing_line(_cr,
    _info_point_m_.xx, _info_point_m_.yy, _info_point_h_.xx, _info_point_h_.yy,
    _Info_Width, _const_line_cap, _Info_Color_line)
end


function draw_line_marks(_cr, _const_line_cap,
    _Clock24_Center_, _Clock24_Radius, _marks_radian,
    _Marks_Radius_, _Marks_Width, _Marks_Color)

  drawing_line(_cr,
    _Clock24_Center_.xx + (math.sin(_marks_radian) * (_Clock24_Radius + _Marks_Radius_.From)),
    _Clock24_Center_.yy - (math.cos(_marks_radian) * (_Clock24_Radius + _Marks_Radius_.From)),
    _Clock24_Center_.xx + (math.sin(_marks_radian) * (_Clock24_Radius + _Marks_Radius_.To)),
    _Clock24_Center_.yy - (math.cos(_marks_radian) * (_Clock24_Radius + _Marks_Radius_.To)),
    _Marks_Width, _const_line_cap, _Marks_Color)
end
