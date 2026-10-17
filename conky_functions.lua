--
--
--


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

function setting_source_rgba(_context, _color)
  cairo_set_source_rgba(_context, _color.red, _color.green, _color.blue, _color.alpha)
end


---
--- draw point
---
function drawing_point(_context,
    _point_x, _point_y, _size,
    _color)

  cairo_arc(_context, _point_x, _point_y, _size, 0, 2 * math.pi)
  setting_source_rgba(_context, _color)
  cairo_fill(_context)
end


--
-- draw line
--
function drawing_line(_context,
    _start_x, _start_y, _end_x, _end_y,
    _width, _line_cap,
    _color)

  cairo_new_path(_context)
  cairo_new_sub_path(_context)
  cairo_move_to(_context, _start_x, _start_y)
  cairo_line_to(_context, _end_x, _end_y)
  cairo_set_line_width(_context, _width)
  cairo_set_line_cap(_context, _line_cap)
  setting_source_rgba(_context, _color)
  cairo_stroke(_context)
end






--
-- set text extents
--
--[[
function _setting_text_extents(_context, _extents,
      _font_size,
      _text, _font_face, _font_slant, _font_weight)

    tolua.takeownership(_extents)

    cairo_select_font_face(_context, _font_face, _font_slant, _font_weight)
    cairo_set_font_size(_context, _font_size)
    cairo_text_extents(_context, _text, _extents)
end
]]

--
-- get text width
--
--[[
function getting_text_width(_context,
      _text,
      _font_size, _font_face, _font_slant, _font_weight)

    local extents = cairo_text_extents_t:create()

    _setting_text_extents(_context, extents,
        _font_size,
        _text, _font_face, _font_slant, _font_weight)

    return extents.width + extents.x_bearing
end
]]

--
-- draw text
--
--[[
function drawing_text(_context,
    _pos_x, _pos_y,
    _text,
    _align, _font_size,
    _font_face, _font_slant, _font_weight,
    _color)

    local gConst = get_const()
    local extents = cairo_text_extents_t:create()

    _setting_text_extents(_context, extents,
        _font_size,
        _text, _font_face, _font_slant, _font_weight)

    cairo_move_to(_context,
        (gConst.Text.Align.Right == _align) and (_pos_x - extents.width - extents.x_bearing) or _pos_x,
        _pos_y)

    setting_source_rgba(_context, _color)
    cairo_show_text(_context, _text)
end
]]

--
-- display text and get text width
--
--[[
function display_text_and_getting_width(_context,
    _pos_x, _pos_y,
    _text,
    _align, _font_size,
    _font_face, _font_slant, _font_weight,
    _color)

    drawing_text(_context,
        _pos_x, _pos_y,
        _text,
        _align, _font_size,
        _font_face, _font_slant, _font_weight,
        _color)

    return getting_text_width(_context,
        _text,
        _font_size, _font_face, _font_slant, _font_weight)
end
]]

