#!/usr/bin/env python
import argparse,logging,os
import numpy as np
logger = logging.getLogger(__name__)


def main():
   ''' simple starter program that can be copied for use when starting a new script. '''
   logging_format = '%(asctime)s %(levelname)s:%(name)s:%(message)s'
   logging_datefmt = '%Y-%m-%d %H:%M:%S'
   logging_level = logging.INFO
   
   parser = argparse.ArgumentParser(description='')
   parser.add_argument('-p','--path',dest='path',help='path in which to write files',required=True)
   parser.add_argument('-n','--nfiles',dest='nfiles',help='number of files to write',required=True,type=int)
   parser.add_argument('-b','--bytes',dest='bytes',help='number of bytes per file',required=True,type=int)
   parser.add_argument('--fbase',dest='fbase',help='base filename',default='output')
   parser.add_argument('--debug', dest='debug', default=False, action='store_true', help="Set Logger to DEBUG")
   parser.add_argument('--error', dest='error', default=False, action='store_true', help="Set Logger to ERROR")
   parser.add_argument('--warning', dest='warning', default=False, action='store_true', help="Set Logger to ERROR")
   parser.add_argument('--logfilename',dest='logfilename',default=None,help='if set, logging information will go to file')
   args = parser.parse_args()

   if args.debug and not args.error and not args.warning:
      logging_level = logging.DEBUG
   elif not args.debug and args.error and not args.warning:
      logging_level = logging.ERROR
   elif not args.debug and not args.error and args.warning:
      logging_level = logging.WARNING

   logging.basicConfig(level=logging_level,
                       format=logging_format,
                       datefmt=logging_datefmt,
                       filename=args.logfilename)
   
   if not os.path.exists(args.path):
      os.makedirs(args.path)

   file_count_max = np.ceil(np.log10(args.nfiles))
   file_count_fmt = '_%%0%dd' % file_count_max
   for i in range(args.nfiles):

      fname = args.path + '/' + args.fbase + (file_count_fmt % i)

      np.savez(fname,np.random.bytes(args.bytes))
   



if __name__ == "__main__":
   main()
