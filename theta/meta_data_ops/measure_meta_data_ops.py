#!/usr/bin/env python
import argparse,logging,os,timeit,glob
import numpy as np
from mpi4py import MPI
logger = logging.getLogger(__name__)


def main():
   ''' simple starter program that can be copied for use when starting a new script. '''
   logging_format = '%(asctime)s %(levelname)s:%(name)s:%(message)s'
   logging_datefmt = '%Y-%m-%d %H:%M:%S'
   logging_level = logging.INFO
   
   parser = argparse.ArgumentParser(description='')
   parser.add_argument('-p','--path',dest='path',help='path to files on which to recursively operate.',required=True)
   parser.add_argument('-n','--ntimeits',dest='ntimeits',help='number times to run the test to measure',default=10,type=int)
   parser.add_argument('-r','--nrepeats',dest='nrepeats',help='number times to repeat the test to measure',default=10,type=int)

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

   COMM = MPI.COMM_WORLD
   rank = COMM.Get_rank()
   nranks = COMM.Get_size()
   logging_format = '%(asctime)s %(levelname)s:' + '%05d' % rank + ':%(name)s:%(message)s'

   if rank > 0 and logging_level == logging.INFO:
      logging_level = logging.WARNING

   logging.basicConfig(level=logging_level,
                       format=logging_format,
                       datefmt=logging_datefmt,
                       filename=args.logfilename)

   logger.info('rank %s of %s',rank,nranks)
   logger.info('running on path: %s',args.path)
   logger.info('timeit tests: %s',args.ntimeits)
   logger.info('repeat timit: %s',args.ntimeits)

   if not os.path.exists(args.path):
      raise Exception('path does not exist: %s' % args.path)

   out_str = ''
   ########
   ### Measure GLOB speed
   ###########################
   logger.info('starting globit test')

   def globit(string):

      def foo():
         glob.glob(string)
      return foo

   timer = timeit.Timer(globit(args.path + '/*'))
   x = timer.repeat(args.nrepeats,args.ntimeits)

   min = float(np.min(x))
   mean = float(np.mean(x))
   max = float(np.max(x))

   global_min = COMM.allreduce(sendobj=min,op=MPI.MIN)
   try:
      global_mean = COMM.allreduce(sendobj=mean,op=MPI.SUM) / nranks
   except:
      logger.exception('received exception processing %s', mean)
      raise
   global_max = COMM.allreduce(sendobj=max,op=MPI.MAX)



   logger.info('%20s = %10.5f,%10.5f,%10.5f','globit',global_min,global_mean,global_max)
   out_str += '%s\t%s\t%s\t\t' % (global_min,global_mean,global_max)

   #######
   ### Measure os.path.exists speed
   ###############################
   logger.info('starting existit test')
   filelist = glob.glob(args.path + '/*')

   def existit(filelist):
      
      def foo():
         for file in filelist:
            os.path.exists(file)
      return foo

   timer = timeit.Timer(existit(filelist))
   x = timer.repeat(args.nrepeats,args.ntimeits)

   min = float(np.min(x))
   mean = float(np.mean(x))
   max = float(np.max(x))

   global_min = COMM.allreduce(sendobj=min,op=MPI.MIN)
   global_mean = COMM.allreduce(sendobj=mean,op=MPI.SUM) / nranks
   global_max = COMM.allreduce(sendobj=max,op=MPI.MAX)

   logger.info('%20s = %10.5f,%10.5f,%10.5f','existit',global_min,global_mean,global_max)
   out_str += '%s\t%s\t%s\t\t' % (global_min,global_mean,global_max)

   #######
   ### Measure os.path.exists speed
   ###############################
   logger.info('starting fstatit test')

   def fstatit(string):
      
      def foo():
         for file in filelist:
            f = os.open(file,os.O_RDONLY)
            os.fstat(f)
            os.close(f)
      return foo

   timer = timeit.Timer(fstatit(filelist))
   x = timer.repeat(args.nrepeats,args.ntimeits)

   min = float(np.min(x))
   mean = float(np.mean(x))
   max = float(np.max(x))

   global_min = COMM.allreduce(sendobj=min,op=MPI.MIN)
   global_mean = COMM.allreduce(sendobj=mean,op=MPI.SUM) / nranks
   global_max = COMM.allreduce(sendobj=max,op=MPI.MAX)
   
   logger.info('%20s = %10.5f,%10.5f,%10.5f','fstatit',global_min,global_mean,global_max)
   out_str += '%s\t%s\t%s\t\t' % (global_min,global_mean,global_max)

   if rank == 0:
      print(out_str)


if __name__ == "__main__":
   main()
