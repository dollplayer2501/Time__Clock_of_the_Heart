--
-- If the filename of this file is `conky_my_config.SAMPLE.lua`,
-- it must be renamed to `conky_my_config.lua` before use.
--

function get_config(_gConst)

  local resolution_xx = 1920
  local resolution_yy = 1080

  return {

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
        -- at what specific time—hours, minutes should the current time be set?
        Hour24                 = 12,
        Minutes                = 43,
      },
      Radius = {
        From                   = -400,
        To                     = 200,
      },
      Point_size               = 20,
      Width                    = 2,
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
            Width              = 4,
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
            Size               = 300,
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
            From               = -60,
            To                 = 60,
          },
          Width = {
            Now                = 4,
            Other              = 2,
          },
        },
      },
      Minutes15 = {
        -- NOTE: Let’s use Minutes05 as a reference point, NOT Minutes10
        Marks = {
          Radius = {
            From               = -15,
            To                 = 15,
          },
          Width = {
            Now                = 4,
            Other              = 2,
          },
        },
      },
      Minutes10 = {
        Marks = {
          Radius = {
            From               = -30,
            To                 = 30,
          },
          Width = {
            Now                = 4,
            Other              = 2,
          },
        },
      },
      Minutes05 = {
        Marks = {
          Radius = {
            From               = -15,
            To                 = 15,
          },
          Width = {
            Now                = 4,
            Other              = 2,
          },
        },
      },
      Minutes01 = {
        Marks = {
          Radius = {
            From               = -5,
            To                 = 5,
          },
          Width = {
            Now                = 4,
            Other              = 2,
          },
        },
      },
    },

    Info = {
      Disp_timer               = 20, -- If set to -1, it will not disappear until a mouse click occurs.
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
          Disp_flg             = true,
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
          Japanese_calendar = {
            Disp_flg           = false,
            Font_size          = 55,
          },
        },
        Other = {
          Other_disp_flg       = false,
          Special_disp_flg     = false,
          Adjust_xx            = 20,
          First_gap_yy         = 120,
          Second_gap_yy        = 40,
          Size                 = 50,
        },
      },
    },

    Measurement = {
      Disp_flg                 = false,
    },
  }
end
