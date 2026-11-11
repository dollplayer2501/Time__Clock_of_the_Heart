--
--
--

--
-- TODO: 2026-11-12
--   Can I improve the logic for converting degrees to radians?
--

--
--
--
function degree_to_radian(_degree)
  local tmp_degree = (360 == _degree) and 0 or _degree
  return math.rad(tmp_degree)
end


--
--
--
function changing_angle_to_radian(_angle)
  return (_angle - 90) * (math.pi / 180)
end


--
--
--
function hhmmss_to_sec(_hour24, _minutes, _seconds)
  _seconds = tonumber(_seconds) or 0
  return (_hour24 * 60 * 60) + (_minutes * 60) + _seconds
end


--
-- set color, hex to rgba
--
function setting_color_hex_to_rgba(_hex, _alpha)

  local color_red, color_green, color_blue = _hex:match('#?(..)(..)(..)')

  color_red, color_green, color_blue =
    tonumber(color_red, 16) / 255,
    tonumber(color_green, 16) / 255,
    tonumber(color_blue, 16) / 255

  color_red, color_green, color_blue =
    math.floor(color_red * 100) / 100,
    math.floor(color_green * 100) / 100,
    math.floor(color_blue * 100) / 100

  if _alpha == nil then
    return {
      red = color_red,
      green = color_green,
      blue = color_blue,
    }
  end

  return {
    red = color_red,
    green = color_green,
    blue = color_blue,
    alpha = _alpha,
  }
end


--
--
--
function setting_source_rgba(_cr, _color)
  cairo_set_source_rgba(_cr, _color.red, _color.green, _color.blue, _color.alpha)
end


---
--- draw point
---
function drawing_point(_cr,
    _point_x, _point_y, _size,
    _color)

  cairo_arc(_cr, _point_x, _point_y, _size, 0, 2 * math.pi)
  setting_source_rgba(_cr, _color)
  cairo_fill(_cr)
end


--
-- draw line
--
function drawing_line(_cr,
    _start_x, _start_y, _end_x, _end_y,
    _width, _line_cap,
    _color)

  cairo_new_path(_cr)
  cairo_new_sub_path(_cr)
  cairo_move_to(_cr, _start_x, _start_y)
  cairo_line_to(_cr, _end_x, _end_y)
  cairo_set_line_width(_cr, _width)
  cairo_set_line_cap(_cr, _line_cap)
  setting_source_rgba(_cr, _color)
  cairo_stroke(_cr)
end


--
-- get text width
--
function getting_text_width(_cr, _const_font_slant, _const_font_weight,
    _font_size, _font_face, _display_string)

  cairo_set_font_size(_cr, _font_size)
  cairo_select_font_face(_cr, _font_face, _const_font_slant, _const_font_weight)

  local tmp_extents = cairo_text_extents_t:create()
  cairo_text_extents(_cr, _display_string, tmp_extents)

-- NOTE:
--   local width = te.width
--   local height = te.height
--   local x_advance = te.x_advance  -- The amount of displacement in the X direction to the position where the next character is to be drawn
--                                   -- 次の文字を描画する位置までのX方向の移動量
--   local x_bearing = te.x_bearing  -- Distance from the left edge to the outline of the character
--                                   -- 左端から文字の輪郭までの距離
--   local y_bearing = te.y_bearing  -- Distance from the top edge to the outline of the characters
--                                   -- 上端から文字の輪郭までの距離
  return tmp_extents
end


--
-- draw ring
--
function drawing_ring(_cr,
    _center_x, _center_y, _radius, _start_angle, _end_angle,
    _width, _line_cap,
    _color)

  cairo_new_path(_cr)
  cairo_arc(_cr, _center_x, _center_y, _radius, _start_angle, _end_angle)
  cairo_set_line_width(_cr, _width)
  -- cairo_set_line_cap(_cr, _line_cap)
  setting_source_rgba(_cr, _color)
  cairo_stroke(_cr)
end
