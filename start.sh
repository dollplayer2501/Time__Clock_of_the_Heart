#!/bin/sh

killall conky

# echo "jumping to target directory"
cd "$(dirname "$0")"

MY_ARG="custom_super_cool_value" conky --config=conky_config.lua
# NOTE:
#  To retrieve `MY_ARG` using Conky's Lua, use the following code:
#  local my_val = os.getenv('MY_ARG') or 'default_value'

exit
