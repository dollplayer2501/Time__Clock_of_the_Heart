--
--
--

function get_const()

  return {

    Text = {
      Align = {
        Left                            = 'left',
        Right                           = 'right',
      },
    },

    Line = {
      Cap = {
        Butt                            = CAIRO_LINE_CAP_BUTT,
        Square                          = CAIRO_LINE_CAP_SQUARE,
        Round                           = CAIRO_LINE_CAP_ROUND,
      },
    },

    Font = {
      Face = {
        Bernardo_Moda = {
          Regular                       = 'Bernardo Moda',
          Bold                          = 'Bernardo Moda Bold',
          Contrast                      = 'Bernardo Moda Contrast',
          Semibold                      = 'Bernardo Moda Semibold',
        },
        Ptolemy = {
          Regular                       = 'Ptolemy',
        },
        Embolism_Spark = {
          Regular                       = 'Embolism Spark',
        },
        -- NOTE: This font, Raleway is not being used.
        Raleway = {
          Thin                          = 'Raleway Thin',
          Light                         = 'Raleway Light',
          Regular                       = 'Raleway',
          Bold                          = 'Raleway Bold',
        },
      },
      Slant = {
        Normal                          = CAIRO_FONT_SLANT_NORMAL,
        Italic                          = CAIRO_FONT_SLANT_ITALIC,
        Oblique                         = CAIRO_FONT_SLANT_OBLIQUE,
      },
      Weight = {
        Normal                          = CAIRO_FONT_WEIGHT_NORMAL,
        Bold                            = CAIRO_FONT_WEIGHT_BOLD,
      },
    },
  }
end
