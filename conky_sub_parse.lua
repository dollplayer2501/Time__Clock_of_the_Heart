--
--
--

function get_conky_parse()
  return {

    Now = {
      Hour24             = tonumber(os.date('%H')),  -- 00..23
      Hour12             = tonumber(os.date('%I')),  -- 01..12
      Minute             = tonumber(os.date('%M')),  -- 00..59
      Second             = tonumber(os.date('%S')),  -- 00..59
      am_pm              = os.date('%p'),  -- AM/PM
      weekday_long       = os.date('%A'),  -- Sunday...Saturday
      weekday_short      = os.date('%a'),  -- Sun..Sat
      weekday_number     = os.date('%w'),  -- 0..6, 0 is Sunday
      day                = os.date('%d'),  -- 01..31
      month_long         = os.date('%B'),  -- January..December
      month_short        = os.date('%b'),  -- Jan..Dec
      month_number       = os.date('%m'),  -- 01..12
      year               = os.date('%Y'),  -- 1970..

      date_full          = conky_parse('${time %A, %B %-d, %Y}'),
      date_short         = conky_parse('${time %a, %b %-d, %Y}'),
      time_full          = conky_parse('${time %H:%M:%S}'),
      time_short         = conky_parse('${time %H:%M}'),

      updates            = tonumber(conky_parse('${updates}')),
      cpu0               = tonumber(conky_parse('${cpu cpu0}')),
    },

    Commands = {
      Normal = {
        hostname         = conky_parse('${execi 600 hostname}'),
        whoami           = conky_parse('${execi 600 whoami}'),
      },
      Special = {
        uptime           = conky_parse("${execi 10 awk '{print $1}' /proc/uptime | my_python_sec_to_regular_time.py --vshort}"),
        login            = conky_parse("${execi 10 fish -c 'my_login_elapsed --second | my_python_sec_to_regular_time.py --vshort' }"),
      },
    },

    Packages = {
      checkupdates       = tonumber(conky_parse('${execi 600 checkupdates | wc -l}')),
      packman_Q          = tonumber(conky_parse('${execi 600 pacman -Q | wc -l}')),
    },
  }
end
