# vim:fileencoding=utf-8:noet

import subprocess

def branch(pl):
  status = subprocess.check_output('__git_ps1')
  return status[2:-1] if status else None

def loginstatus(pl):
  err = subprocess.call(['loginstatus'])
  return '' if err else None
