#!/bin/sh

killall conky

# echo "jumping to target directory"
cd "$(dirname "$0")"

DEBUG_MESSAGE="false" conky --config=conky.config.lua
# NOTE:
#   To retrieve `DEBUG_MESSAGE` using Conky's Lua, use the following code:
#   local my_val = os.getenv('DEBUG_MESSAGE') or 'false'
#   I don't really understand how boolean values ​​are handled in Lua.

exit
