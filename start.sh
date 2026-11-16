#!/bin/sh

killall conky

# echo "jumping to target directory"
cd "$(dirname "$0")"

DEBUG_MESSAGE="false" conky --config=conky.config.lua
#
# NOTE:
#   To retrieve `DEBUG_MESSAGE` using Conky's Lua, use the following code:
#   local my_val = os.getenv('DEBUG_MESSAGE') or 'false'
#   I don't really understand how boolean values ​​are handled in Lua.
#
# NOTE:
#   Arguments that may be useful when launching Conky.
#   -C, --print-config print the builtin default config to stdout
#   -q, --quiet        quiet mode
#   -D, --debug        increase logging output, e.g. -DD for tracing messages
#

exit
