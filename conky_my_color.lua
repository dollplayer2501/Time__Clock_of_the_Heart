--
--
--

function get_color()

  --
  --  #08052B #FF7F7F #7F3FBF #CC3980 #7FBAFF #7F3FBF #7F7FFF #CDCCDB
  --  #7FBAFF #FF7F7F #9999CC #FF7F7F #7F7FFF #7F3FBF #7F7FFF #E3E3EA
  --
  -- #08052B #221F45 #3B385E #555278 #6E6B91 #8784AA
  -- https://www.colors.tools/lighten-and-darken/

  local one_color = '#00ff00'
  local sub_color = '#00aa00'

--  local one_color = '#ff00ff'
--  local sub_color = '#aa00aa'

--  local one_color = '#ff7f7f'
--  local sub_color = '#7f7fff'

  return {
    Hand = {
      Marks                         = setting_color_hex_to_rgba(sub_color, 0.6),
      Text                          = setting_color_hex_to_rgba(one_color, 1.0),
    },
    Clock24 ={
      Hour24 = {
        Marks = {
          Now                       = setting_color_hex_to_rgba(sub_color, 0.8),
          Next                      = setting_color_hex_to_rgba(sub_color, 0.8),
          Normal                    = setting_color_hex_to_rgba(sub_color, 0.8),
        },
        Number = {
          Now                       = setting_color_hex_to_rgba(one_color, 0.6),
          Next                      = setting_color_hex_to_rgba(one_color, 0.8),
          Normal                    = setting_color_hex_to_rgba(sub_color, 0.8),
        },
      },
      Minutes = {
        Number                      = setting_color_hex_to_rgba(one_color, 1.0),
      },
      Seconds = {
        Number                      = setting_color_hex_to_rgba(one_color, 1.0),
      },
      Minutes30 = {
        Marks                       = setting_color_hex_to_rgba(sub_color, 0.8),
      },
      Minutes10 = {
        Marks                       = setting_color_hex_to_rgba(sub_color, 0.8),
      },
      Minutes05 = {
        Marks                       = setting_color_hex_to_rgba(sub_color, 0.8),
      },
      Minutes01 = {
        Marks                       = setting_color_hex_to_rgba(sub_color, 0.8),
      },
    },
    Info = {
      Point                         = setting_color_hex_to_rgba(sub_color, 1.0),
      Line                          = setting_color_hex_to_rgba(sub_color, 0.9),
      Text                          = setting_color_hex_to_rgba(one_color, 1.0),
    },
    Debug                           = setting_color_hex_to_rgba('#ff00ff', 0.7),
  }
end
