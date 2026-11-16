--
--
--


function get_current_path()
  --
  -- NOTE:
  --   This file itself is located in the `./lua/` directory.
  --   The directory one level above this serves as the base directory for this theme.
  --   Therefore, I will use that as our reference point.
  --
  local tmp_str_1 = debug.getinfo(1, "S").source:gsub("^@", "")
  local tmp_str_2 = tmp_str_1:match("^(.*[/\\])") or "./"
  return tmp_str_2:match("^(.*[/\\])[^/\\]+[/\\]$") or tmp_str_2
end


function main_pre_func()

  local display_message_green = function(_message)
    --
    -- NOTE:
    --   Output is suppressed via environment variables set at the time Conky is launched.
    --
    local tmp_str = os.getenv('DEBUG_MESSAGE') or 'false'
    if 'true' == string.lower(tmp_str) then
      print("\27[32m" .. _message .."\27[0m")
    end
  end

  local check_file_exist = function(_full_path)
    local file = io.open(_full_path, 'r')
    if file then
      file:close()
      return true
    else
      return false
    end
  end


  --
  -- Load various files, retrieving the package path
  --

  local current_path = get_current_path()
  display_message_green(' Current directory:' .. current_path)

  package.path = current_path .. 'lua/?.lua;' ..
                 current_path .. 'config/?.lua;' ..
                 package.path
  display_message_green(' Package directory:' .. package.path)


  --
  -- NOTE:
  --   In terms of the logic for this theme,
  --   the default `./config/color_default.lua` and `./config/config_default.lua` are assumed to always exist;
  --   however, if `./config/color_me.lua` and/or `./config/config_me.lua` are present,
  --   it will be loaded instead, and the default items will not be loaded.
  --

  local file_config_flg, file_color_flg = nil, nil

  --
  -- Configuration, default or my customization?
  --
  if true == check_file_exist(current_path .. 'config/config_me.lua') then
    file_config_flg = true
    display_message_green(" The user's configuration file, `./config/config_me.lua`, exists.")
  else
    file_config_flg = false
    display_message_green(" The user's configuration file, `./config/config_me.lua`, does not exist.")
    display_message_green(" Therefore, using `./config/config_default.lua`.")

  end

  --
  -- Color Scheme, default or my customization?
  --
  if true == check_file_exist(current_path .. 'config/color_me.lua') then
    file_color_flg = true
    display_message_green(" The user's configuration file, `./config/color_me.lua`, exists.")
  else
    file_color_flg = false
    display_message_green(" The user's configuration file, `./config/color_me.lua`, does not exist.")
    display_message_green(" Therefore, using `./config/color_default.lua`.")
  end

  return file_config_flg, file_color_flg
end
