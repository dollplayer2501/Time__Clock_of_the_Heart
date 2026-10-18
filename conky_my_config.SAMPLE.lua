--
-- If the filename of this file is `conky_my_config.SAMPLE.lua`,
-- it must be renamed to `conky_my_config.lua` before use.
--

function get_config(_gConst)

  local resolution_xx = 1920
  local resolution_yy = 1080

  return {

    Color_scheme               = 'conky_my_color.lua',

    Environment = {
      Resolusion = {
        xx                     = resolution_xx,
        yy                     = resolution_yy,
      },
      Angle                    = 0,
    },

    --

    Hand = {
      Marks = {
        -- Assuming a 24-hour clock where the peak is at the zero position,
        -- at what specific time—hours, minutes, and seconds—should the current time be set?
        Hour24                 = 12,
        Minutes                = 43,
        Seconds                = 0,
      },
      Radius = {
        From                   = -400,
        To                     = 200,
      },
      Width                    = 4,
    },

    Clock24 = {
      Center = {
        xx                     = (resolution_xx / 2) + 400,
        yy                     = (resolution_yy / 2) - 1600,
      },
      Radius                   = 2000,
      Hour24 = {
        Marks = {
          Now = {
            Radius = {
              From             = -200,
              To               = 100,
            },
            Width              = 4,
          },
          Next = {
            Radius = {
              From             = -100,
              To               = 100,
            },
            Width              = 2,
          },
          Normal = {
            Radius = {
              From             = -80,
              To               = 80,
            },
            Width              = 2,
          },
        },
        Number = {
          Now = {
            Size               = 700,
            Face               = _gConst.Font.Face.Ptolemy.Regular,
          Adjust = {
              xx               = -100,
              yy               = 0,
            },
          },
          Next = {
            Size               = 140,
            Face               = _gConst.Font.Face.Ptolemy.Regular,
            Adjust = {
              xx               = 0,
              yy               = 0,
            },
          },
          Normal = {
            Size               = 120,
            Face               = _gConst.Font.Face.Ptolemy.Regular,
            Adjust = {
              xx               = 0,
              yy               = 0,
            },
          },
        },
      },
      Minutes30 = {
        Marks = {
          Radius = {
            From               = -40,
            To                 = 40,
          },
          Width                = 2,
        },
      },
      Minutes10 = {
        Marks = {
          Radius = {
            From               = -15,
            To                 = 15,
          },
          Width                = 2,
        },
      },
      Minutes05 = {
        Marks = {
          Radius = {
            From               = -10,
            To                 = 10,
          },
          Width                = 2,
        },
      },
      Minutes01 = {
        Marks = {
          Radius = {
            From               = -5,
            To                 = 5,
          },
          Width                = 2,
        },
      },
    },

    Info = {
      Update_interval          = 5,
      Point_size               = 4,
      Info = {
        Point = {
          xx                   = 800,
          yy                   = 150,
        },
      },
      Middle = {
        Adjust = {
          xx                   = -400,
          yy                   = 500,
        },
      },
      Line = {
        Width                  = 2,
      },
      Text = {
        Angle_degree           = -2,
        Face                   = _gConst.Font.Face.Bernardo_Moda.Contrast,
        Time_hhmm = {
          Size                 = 380,
          Adjust = {
            xx                 = 10,
            yy                 = 80,
          },
        },
        Time_ss = {
          Size                 = 160,
          Adjust = {
            xx                 = 10,
            yy                 = -10,
          },
        },
        Full_date = {
          Size                 = 90,
          Adjust = {
            xx                 = 10,
            yy                 = 50,
          },
        },
        Other = {
          Other_display_flag   = false,
          Special_display_flag = false,
          Adjust_xx            = 20,
          First_gap_yy         = 120,
          Second_gap_yy        = 40,
          Face                 = _gConst.Font.Face.Embolism_Spark.Regular,
          Size                 = 50,
        },
      },
    },
  }
end
