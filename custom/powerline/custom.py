# vim:fileencoding=utf-8:noet

import subprocess

from powerline.theme import requires_segment_info


@requires_segment_info
def mode(pl, segment_info):
  return '{0:2}'.format(segment_info['mode'])


def branch(pl):
  status = subprocess.check_output('__git_ps1')
  return status[2:-1] if status else None
