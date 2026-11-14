--
--
--

local local_triming = function(_str)
  return (string.gsub(_str, '^%s*(.-)%s*$', '%1'))
end


function sub_special_func(_cr, _gConst, _gParse, _gConfig, _gColor,
    _const_line_cap, _const_font_slant, _const_font_weight,
    _hand_radian)

  --
  -- NOTE:
  --   This function is intended to be executed.
  --   Please control whether or not it is executed from the `main` side.
  --


  local tmp_point_random = math.floor(_gParse.Now.Second / _gConfig.Info.Update_interval) * 1

  -- Starting point of the information display area
  local info_point_i = {
    xx = _gConfig.Info.Info.Point.xx + tmp_point_random,
    yy = _gConfig.Info.Info.Point.yy + tmp_point_random,
  }

  -- The intersection of hand and the clock frame. In other words, the current time.
  local info_point_h = {
    xx = _gConfig.Clock24.Center.xx + (math.sin(_hand_radian) * _gConfig.Clock24.Radius),
    yy = _gConfig.Clock24.Center.yy - (math.cos(_hand_radian) * _gConfig.Clock24.Radius),
  }

  -- The superfluous point midway between the above.
  local info_point_m = {
    xx = _gConfig.Clock24.Center.xx + ((math.sin(_hand_radian) * _gConfig.Clock24.Radius) + _gConfig.Info.Middle.Adjust.xx),
    yy = _gConfig.Clock24.Center.yy - ((math.cos(_hand_radian) * _gConfig.Clock24.Radius) + _gConfig.Info.Middle.Adjust.yy),
  }


  --
  -- Draw Line and Point
  --

  draw_line_info(_cr, _const_line_cap,
    _gConfig.Clock24.Center, _gConfig.Clock24.Radius,
    info_point_i, info_point_h, info_point_m,
    _gConfig.Info.Point_size, _gConfig.Info.Line.Width,
    _gColor.Info.Point, _gColor.Info.Line)


  cairo_save(_cr)


  --
  -- Draw Text, Information
  --

  -- Time, HH:MM

  local tmp_string = _gParse.Now.time_short
  local extents_hhmm = draw_text_time_hhmm(_cr, _const_font_slant, _const_font_weight,
    _gConfig.Info.Text.Time_hhmm.Size, _gConfig.Info.Text.Face, tmp_string,
    info_point_i, degree_to_radian(_gConfig.Info.Text.Angle_degree),
    _gConfig.Info.Text.Time_hhmm.Adjust, _gColor.Info.Text)

  -- Time, SS

  --
  -- TODO: 2026-11-14
  --   Make the display of seconds (on/off) configurable.
  --   Since the text is quite large and updates every second, the display of seconds occasionally skips a beat.
  --

  local tmp_string = string.format(':%02d', _gParse.Now.Second)
  draw_text_time_ss(_cr,
    _gConfig.Info.Text.Time_ss.Size, tmp_string,
    _gConfig.Info.Text.Time_hhmm.Adjust, extents_hhmm.x_advance, _gConfig.Info.Text.Time_ss.Adjust)

  --

  local tmp_gap_yy = (-1 * extents_hhmm.y_bearing / 2) + _gConfig.Info.Text.Full_date.Adjust.yy

  -- Full date

  --
  -- TODO: 2026-11-14
  --   For me—since I am Japanese—I would like a flag to toggle the display of the Japanese era name.
  --   It should be displayed as: "Saturday, November 14, 2026/R8"
  --   I think it would be fine for the "R8" part to be displayed in a smaller font.
  --   Given this, it might be necessary to shift this section slightly to the left.
  --

  local tmp_string = _gParse.Now.date_full
  draw_text_full_date(_cr,
    _gConfig.Info.Text.Full_date.Size, tmp_string,
    _gConfig.Info.Text.Time_hhmm.Adjust.xx, _gConfig.Info.Text.Full_date.Adjust, tmp_gap_yy)

  --
  -- Many font settings are carried over as-is from the previous section, so they have not been explicitly specified here.
  --

  if true == _gConfig.Info.Text.Other.Other_display_flag then
    --
    -- Package update info
    --   NOTE:
    --     I use EndeavourOS, in other words, it is based on Arch Linux.
    --

    local tmp_string = string.format('All packages are %d, no need to update!', _gParse.Commands.Packages.packman_Q)
    if 0 < _gParse.Commands.Packages.checkupdates then
      tmp_string = string.format('%d out of %d packages require updating.',
        _gParse.Commands.Packages.checkupdates, _gParse.Commands.Packages.packman_Q)
    end
    tmp_gap_yy = tmp_gap_yy + _gConfig.Info.Text.Other.First_gap_yy

    draw_text_others(_cr,
      _gConfig.Info.Text.Other.Size, tmp_string,
      _gConfig.Info.Text.Full_date.Adjust.xx, _gConfig.Info.Text.Other.Adjust_xx,
      tmp_gap_yy)
  end

  if true == _gConfig.Info.Text.Other.Other_display_flag and true == _gConfig.Info.Text.Other.Special_display_flag then

    -- Time elapsed since the PC was started

    local tmp_string = string.format('%s, %s uptime.',
        _gParse.Commands.Special.uptime, local_triming(_gParse.Commands.Normal.hostname))
    tmp_gap_yy = tmp_gap_yy + _gConfig.Info.Text.Other.Second_gap_yy

    draw_text_others(_cr,
      _gConfig.Info.Text.Other.Size, tmp_string,
      _gConfig.Info.Text.Full_date.Adjust.xx, _gConfig.Info.Text.Other.Adjust_xx,
      tmp_gap_yy)

    -- Time elapsed since login

    local tmp_string = string.format('%s, %s login.',
        _gParse.Commands.Special.login, local_triming(_gParse.Commands.Normal.whoami))
    tmp_gap_yy = tmp_gap_yy + _gConfig.Info.Text.Other.Second_gap_yy

    draw_text_others(_cr,
      _gConfig.Info.Text.Other.Size, tmp_string,
      _gConfig.Info.Text.Full_date.Adjust.xx, _gConfig.Info.Text.Other.Adjust_xx,
      tmp_gap_yy)

  end

  cairo_restore(_cr)
end
