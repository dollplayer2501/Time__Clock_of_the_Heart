--
--
--

function get_conky_parse()

  local current_path = get_current_path()

  local python_time = current_path .. 'python/sec_to_regular_time.py'
  local python_login = current_path .. 'python/login_elapsed.py'

  --
  -- NOTE:
  --   While a Python script with execution permissions would also be a viable option,
  --   I deliberately chose this approach instead.
  --
  local exec_uptime = "awk '{print $1}' /proc/uptime | python3 " .. python_time
  local exec_elapsed = "python3 " .. python_login .. " | python3 " .. python_time


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
      Packages = {
        checkupdates     = tonumber(conky_parse('${execi 600 checkupdates | wc -l}')),
        packman_Q        = tonumber(conky_parse('${execi 600 pacman -Q | wc -l}')),
      },
      Special = {
        uptime           = conky_parse("${execi 10 " .. exec_uptime .. "}"),
        login            = conky_parse("${execi 10 " .. exec_elapsed.. "}"),
      },
    },
  }
end
