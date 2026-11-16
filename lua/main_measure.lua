--
-- NOTE:
--   In my environment, it’s around 20ms.
--

function measure_start(_display_flag)
  if true == _display_flag then
    return os.clock()
  end

  return nil
end


function measure_stop(_display_flag, _start_ms)
  if true == _display_flag then
    return (os.clock() - _start_ms) * 1000
  end

  return nil
end


function measure_display(_display_flag, _cr, _elapsed_ms)
  if true == _display_flag then
    --
    -- NOTE:
    --   Deliberately chosen not to handle this using a common function.
    --
    cairo_select_font_face(_cr, 'Monospace', CAIRO_FONT_SLANT_NORMAL, CAIRO_FONT_WEIGHT_BOLD)
    cairo_set_font_size(_cr, 14)
    cairo_set_source_rgba(_cr, 0.3, 1.0, 0.3, 1.0)
    cairo_move_to(_cr, 10, 20)
    cairo_show_text(_cr, string.format('Render: %.2f ms', _elapsed_ms))
  end
end

