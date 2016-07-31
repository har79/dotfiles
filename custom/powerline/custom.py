# vim:fileencoding=utf-8:noet

import subprocess


def branch(pl):
  status = subprocess.check_output('__git_ps1')
  return status[2:-1] if status else None


def loginstatus(pl):
  try:
    output = subprocess.check_output('loginstatus', stderr=subprocess.STDOUT)
    return output
  except subprocess.CalledProcessError as e:
    return e.output
