#!/usr/bin/env python
import argparse,logging,os,timeit,glob
import numpy as np
logger = logging.getLogger(__name__)


def main():
   ''' simple starter program that can be copied for use when starting a new script. '''
   logging_format = '%(asctime)s %(levelname)s:%(name)s:%(message)s'
   logging_datefmt = '%Y-%m-%d %H:%M:%S'
   logging_level = logging.INFO
   
   parser = argparse.ArgumentParser(description='')
   parser.add_argument('-p','--path',dest='path',help='path to files on which to recursively operate.',required=True)
   parser.add_argument('--ntimeits',dest='ntimeits',help='number times to run the test to measure',default=100,type=int)

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
      raise Exception('path does not exist: %s' % args.path)

   ########
   ### Measure GLOB speed
   ###########################
   def globit(string):

      def foo():
         glob.glob(string)
      return foo

   timer = timeit.Timer(globit(args.path + '/*'))
   x = timer.repeat(100,args.ntimeits)

   logger.info('%20s = %10.5f %10.5f %10.5f','globit',np.min(x),np.mean(x),np.max(x))

   #######
   ### Measure os.path.exists speed
   ###############################
   filelist = glob.glob(args.path + '/*')

   def existit(filelist):
      
      def foo():
         for file in filelist:
            os.path.exists(file)
      return foo

   timer = timeit.Timer(existit(filelist))
   x = timer.repeat(100,args.ntimeits)

   logger.info('%20s = %10.5f %10.5f %10.5f','existit',np.min(x),np.mean(x),np.max(x))

   #######
   ### Measure os.path.exists speed
   ###############################
   def fstatit(string):
      
      def foo():
         for file in filelist:
            f = os.open(file,os.O_RDONLY)
            os.fstat(f)
            os.close(f)
      return foo

   timer = timeit.Timer(fstatit(filelist))
   x = timer.repeat(100,args.ntimeits)

   logger.info('%20s = %10.5f %10.5f %10.5f','fstatit',np.min(x),np.mean(x),np.max(x))






if __name__ == "__main__":
   main()