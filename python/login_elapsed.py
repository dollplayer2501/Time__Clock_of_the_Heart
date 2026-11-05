#!/usr/bin/env python3

"""
Use the `last` command to display the number of seconds that have elapsed since login.
"""

import subprocess
import sys


def run(cmd: str) -> str:
  return subprocess.run(
    cmd, shell = True, check = True, capture_output = True, text = True
  ).stdout.strip()


def main() -> int:
  login = run("last -1 -F $USER | awk 'NR==1{print $4, $5, $6, $7, $8}'")
  if not login:
    # Unable to retrieve login information
    print('0')
    return -1

  login_epoch = int(run(f'date -d "{login}" +%s'))
  now_epoch = int(run("date +%s"))

  print(now_epoch - login_epoch)
  return 0


if __name__ == "__main__":
  sys.exit(main())
