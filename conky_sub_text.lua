--
--
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


function draw_text_hour24(_cr, _const_font_slant, _const_font_weight,
    _font_size, _font_face, _display_string,
    _display_position_, _display_radian, _font_adjust_, _font_color)

  local tmp_extents = getting_text_width(_cr, _const_font_slant, _const_font_weight,
      _font_size, _font_face, _display_string)
  local tmp_shift_xx = -1 * tmp_extents.width  / 2 - tmp_extents.x_bearing
  local tmp_shift_yy = -1 * tmp_extents.height / 2 - tmp_extents.y_bearing

  cairo_translate(_cr, _display_position_.xx, _display_position_.yy)
  cairo_rotate(_cr, _display_radian)
  cairo_move_to(_cr, _display_position_.xx, _display_position_.yy)
  cairo_move_to(_cr, tmp_shift_xx + _font_adjust_.xx, tmp_shift_yy + _font_adjust_.yy)
  setting_source_rgba(_cr, _font_color)
  cairo_show_text(_cr, _display_string)
end


function draw_text_time_hhmm(_cr, _const_font_slant, _const_font_weight,
    _font_size, _font_face, _display_string,
    _display_position_, _display_radian,
    _font_adjust_, _font_color)

  cairo_translate(_cr, _display_position_.xx, _display_position_.yy)
  cairo_rotate(_cr, _display_radian)
  cairo_move_to(_cr, _display_position_.xx, _display_position_.yy)
  cairo_move_to(_cr, _font_adjust_.xx, _font_adjust_.yy)

  setting_source_rgba(_cr, _font_color)
  cairo_select_font_face(_cr, _font_face, _const_font_slant, _const_font_weight)
  cairo_set_font_size(_cr, _font_size)
  cairo_show_text(_cr, _display_string)

  return getting_text_width(_cr, _const_font_slant, _const_font_weight,
      _font_size, _font_face, _display_string)
end


function draw_text_time_ss(_cr, _font_size, _display_string,
    _font_adjust_before_, _font_extents_before_x_advance, _font_adjust_now_)

  local tmp_shift_xx = _font_adjust_before_.xx + _font_extents_before_x_advance + _font_adjust_now_.xx
  local tmp_shift_yy = _font_adjust_before_.yy + _font_adjust_now_.yy

  cairo_move_to(_cr, tmp_shift_xx, tmp_shift_yy)
  cairo_set_font_size(_cr, _font_size)
  cairo_show_text(_cr, _display_string)
end


function draw_text_full_date(_cr, _font_size, _display_string,
    _font_adjust_before_xx, _font_adjust_now_, _gap_yy)

  local tmp_xx = _font_adjust_before_xx + _font_adjust_now_.xx
  local tmp_yy = _gap_yy + _font_adjust_now_.yy

  cairo_move_to(_cr, tmp_xx, tmp_yy)
  cairo_set_font_size(_cr, _font_size)
  cairo_show_text(_cr, _display_string)
end


function draw_text_others(_cr, _font_size, _display_string,
    _font_adjust_before_xx, _font_adjust_now_xx, _gyap_yy)

  cairo_move_to(_cr, _font_adjust_before_xx + _font_adjust_now_xx, _gyap_yy)
  cairo_set_font_size(_cr, _font_size)
  cairo_show_text(_cr, _display_string)
end
