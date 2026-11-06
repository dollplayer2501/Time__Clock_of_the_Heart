#! /usr/bin/env python3

"""
Convert seconds into a time format.
Using a short-form time notation.
For example, "1wk 1d 1hr 1min".
"""

# 1 minute:           60 seconds
# 1 hour:          3,600 seconds
# 1 day:          86,400 seconds
# 1 week:        604,800 seconds
# 1 month:               Not yet implemented
# 1 year:                Not yet implemented
# Beyond that:           Not yet implemented


import argparse
import sys

from typing import Tuple


# Definition of seconds for each unit
SEC_IN_MINUTE = 60
SEC_IN_HOUR   = 60 * 60
SEC_IN_DAY    = 24 * SEC_IN_HOUR
SEC_IN_WEEK   =  7 * SEC_IN_DAY


def argument_handling() -> int:

  parser = argparse.ArgumentParser()
  parser.add_argument('number', type = str, nargs = '?', help = '')
  args = parser.parse_args()

  #
  # Via argument or pipe?
  #

  unknown_number = None

  if args.number is not None:
    unknown_number = args.number
  elif not sys.stdin.isatty():
    unknown_number = str(sys.stdin.read())
  else:
    # parser.error('seconds is required')
    return -1

  #
  # Is the argument value ​​valid?
  #

  total_seconds = None

  cleaned_value = unknown_number.replace(",", "")
  try:
    total_seconds = int(float(cleaned_value))
  except ValueError:
    # parser.error(f"seconds is number, `{unknown_number.strip()}` is not number")
    return -1

  return total_seconds


def seconds_to_time(total_seconds: int) -> tuple[int, int, int, int ,int]:

  # Calculation of weeks, days, hours, minutes, and seconds

  weeks = total_seconds // SEC_IN_WEEK
  rem = total_seconds % SEC_IN_WEEK

  days = rem // SEC_IN_DAY
  rem %= SEC_IN_DAY

  hours = rem // SEC_IN_HOUR
  rem %= SEC_IN_HOUR

  minutes = rem // SEC_IN_MINUTE
  seconds = rem % SEC_IN_MINUTE

  # print(weeks, days, hours, minutes, seconds)
  return weeks, days, hours, minutes, seconds


def set_display_string(
      total_seconds: int,
      weeks: int, days: int, hours: int, minutes: int, seconds: int) -> str:

  display_str = ''

  if total_seconds < SEC_IN_HOUR:

    display_str += (f"{minutes:2}min") if minutes > 0 else "0min"
    display_str += (f" {seconds:2}sec") if seconds > 0 else " 0sec"

  elif total_seconds < SEC_IN_DAY:

    display_str += f"{hours}hr"
    display_str += (f" {minutes:2}min") if minutes > 0 else " 0min"
    display_str += (f" {seconds:2}sec") if seconds > 0 else " 0sec"

  elif total_seconds < SEC_IN_WEEK:

    display_str += f"{days}d"
    display_str += (f" {hours:2}hr") if hours > 0 else " 0hr"
    display_str += (f" {minutes:2}min") if minutes > 0 else " 0min"

  else:

    display_str += f"{weeks}wk"
    display_str += (f" {days}d") if days > 0 else " 0d"
    display_str += (f" {hours:2}hr") if hours > 0 else " 0hr"
    display_str += (f" {minutes:2}min") if minutes > 0 else " 0min"

  return ' ' . join(display_str.split())


def main() -> int:

  total_seconds = argument_handling()
  if 0 > total_seconds:
    return total_seconds

  weeks, days, hours, minutes, seconds = seconds_to_time(total_seconds)

  print(set_display_string(total_seconds, weeks, days, hours, minutes, seconds))
  return 0


if __name__ == "__main__":
  sys.exit(main())

