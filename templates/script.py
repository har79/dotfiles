#! /usr/bin/env python2.7
# -*- coding: utf-8 -*-
# pylint: disable=C

""" TODO
"""

from __future__ import absolute_import, division, print_function, unicode_literals
from future_builtins import ascii, filter, hex, map, oct, zip

import inspect

__version__ = '0.1'

import logging
__logger__ = logging.getLogger(__name__)


logDepth = 0


def logFunction(f, log_prefix=''):
    def func(*args, **kargs):
   	 global logDepth
   	 #__logger__.debug('{}{}{}(args={}, kargs={})'.format('\t' * logDepth, log_prefix, f.__name__, args[1:], kargs))
   	 __logger__.debug('\t' * logDepth + log_prefix + f.__name__)
   	 logDepth += 1
   	 result = f(*args, **kargs)
   	 logDepth -= 1
   	 return result
    return func


def logClass(c):
    for name, method in inspect.getmembers(c, predicate=inspect.ismethod):
   	 setattr(c, name, logFunction(method, c.__name__ + '.'))
    return c


def logModule(m):
    for name, member in inspect.getmembers(m):
   	 if inspect.isclass(member):
   		 setattr(m, name, logClass(member))
   	 elif inspect.ismethod(member):
   		 setattr(m, name, logFunction(member))


def _main(args):
    pass


if __name__ == '__main__':
    # Module being run as script
    import argparse
    import itertools
    import os
    import textwrap
    import time
    import sys

    script_name = os.path.basename(sys.argv[0])

    # Format help description
    desc_sections = [
   	 ("""\
   		 """, # TODO description
   		 {})]

    def linesFromSections(sections):
   	 for section, kargs in sections:
   		 for para in textwrap.dedent(section).splitlines():
   			 lines = textwrap.TextWrapper(**kargs).wrap(para)
   			 if not lines:
   				 yield ''
   			 for line in lines:
   				 yield line

    desc = '\n'.join(linesFromSections(desc_sections))

    # Set up argument parser
    parser = argparse.ArgumentParser(formatter_class=argparse.RawDescriptionHelpFormatter, description=desc)
    # TODO arguments
    # Optional arguments
    parser.add_argument('-l', '--log', nargs='?', const='{}.log'.format(script_name), metavar='FILE',
   	 help='log to %(const)s or FILE')
    parser.add_argument('-q', '--quiet', action='count', default=0,
   	 help='reduce verbosity')
    parser.add_argument('-v', '--verbose', action='count', default=0,
   	 help='increase verbosity')
    parser.add_argument('-V', '--version', action='version', version='%(prog)s {}'.format(__version__))
    # Get arguments
    args = parser.parse_args()

    # Set up logger
    logging.raiseExceptions = False
    logging.captureWarnings(True)
    __logger__.setLevel(logging.DEBUG)
    # Add stderr output
    sh = logging.StreamHandler()
    sh.setLevel(logging.WARNING + (args.quiet - args.verbose) * 10)
    __logger__.addHandler(sh)
    # Add log file output if requested
    if args.log is not None:
   	 fh = logging.FileHandler(args.log)
   	 ff = logging.Formatter('%(asctime)s: [%(levelname)s] %(message)s', '%Y-%m-%dT%H:%M:%SZ')
   	 ff.converter = time.gmtime
   	 fh.setFormatter(ff)
   	 __logger__.addHandler(fh)
    # Clean up arguments
    del args.quiet, args.verbose, args.log
    __logger__.debug('Being run with arguments {}'.format(vars(args)))

    # Execute main body
    try:
   	 _main(args)
    except Exception:
   	 __logger__.exception('Exception occurred:')
   	 sys.exit(1)

else:
    # Module being imported
    # Prevent __logger__ complaining about having no handlers if logging not set up by importing code
    __logger__.addHandler(logging.NullHandler())

