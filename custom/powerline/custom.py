# vim:fileencoding=utf-8:noet

import subprocess

def branch(pl):
  status = subprocess.check_output('gitps1')
  return status[2:-1] if status else None
