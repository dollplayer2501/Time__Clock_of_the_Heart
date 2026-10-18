--
--
--

function get_color()

  local main1_color = '#00ff00'
  local main2_color = '#00aa00'
  local sub1_color  = '#888888'
  local sub2_color  = '#cccccc'

  return {
    Hand = {
      Marks                         = setting_color_hex_to_rgba(sub2_color, 0.8),
    },
    Clock24 ={
      Hour24 = {
        Marks = {
          Now                       = setting_color_hex_to_rgba(main2_color, 1.0),
          Next                      = setting_color_hex_to_rgba(sub1_color, 0.8),
          Normal                    = setting_color_hex_to_rgba(sub1_color, 0.8),
        },
        Number = {
          Now                       = setting_color_hex_to_rgba(main1_color, 0.9),
          Next                      = setting_color_hex_to_rgba(main1_color, 0.9),
          Normal                    = setting_color_hex_to_rgba(main1_color, 0.9),
        },
      },
      Minutes30 = {
        Marks                       = setting_color_hex_to_rgba(sub1_color, 0.8),
      },
      Minutes10 = {
        Marks                       = setting_color_hex_to_rgba(sub1_color, 0.8),
      },
      Minutes05 = {
        Marks                       = setting_color_hex_to_rgba(sub1_color, 0.8),
      },
      Minutes01 = {
        Marks                       = setting_color_hex_to_rgba(sub1_color, 0.8),
      },
    },
    Info = {
      Point                         = setting_color_hex_to_rgba(sub2_color, 1.0),
      Line                          = setting_color_hex_to_rgba(sub2_color, 1.0),
      Text                          = setting_color_hex_to_rgba(main1_color, 1.0),
    },
    Debug                           = setting_color_hex_to_rgba('#ff00ff', 0.7),
  }
end
