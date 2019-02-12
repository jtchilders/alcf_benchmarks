#!/usr/bin/env python
import argparse,logging,glob
import numpy as np
logger = logging.getLogger(__name__)


def main():
   ''' simple starter program that can be copied for use when starting a new script. '''
   logging_format = '%(asctime)s %(levelname)s:%(name)s:%(message)s'
   logging_datefmt = '%Y-%m-%d %H:%M:%S'
   logging.basicConfig(level=logging.INFO,format=logging_format,datefmt=logging_datefmt)

   parser = argparse.ArgumentParser(description='')
   parser.add_argument('-i','--input',dest='input',type=str,help='input',required=True,nargs='*')
   parser.add_argument('--debug', dest='debug', default=False, action='store_true', help="Set Logger to DEBUG")
   parser.add_argument('--error', dest='error', default=False, action='store_true', help="Set Logger to ERROR")
   parser.add_argument('--warning', dest='warning', default=False, action='store_true', help="Set Logger to ERROR")
   parser.add_argument('--logfilename',dest='logfilename',default=None,help='if set, logging information will go to file')
   args = parser.parse_args()

   if args.debug and not args.error and not args.warning:
      # remove existing root handlers and reconfigure with DEBUG
      for h in logging.root.handlers:
         logging.root.removeHandler(h)
      logging.basicConfig(level=logging.DEBUG,
                          format=logging_format,
                          datefmt=logging_datefmt,
                          filename=args.logfilename)
      logger.setLevel(logging.DEBUG)
   elif not args.debug and args.error and not args.warning:
      # remove existing root handlers and reconfigure with ERROR
      for h in logging.root.handlers:
         logging.root.removeHandler(h)
      logging.basicConfig(level=logging.ERROR,
                          format=logging_format,
                          datefmt=logging_datefmt,
                          filename=args.logfilename)
      logger.setLevel(logging.ERROR)
   elif not args.debug and not args.error and args.warning:
      # remove existing root handlers and reconfigure with WARNING
      for h in logging.root.handlers:
         logging.root.removeHandler(h)
      logging.basicConfig(level=logging.WARNING,
                          format=logging_format,
                          datefmt=logging_datefmt,
                          filename=args.logfilename)
      logger.setLevel(logging.WARNING)
   else:
      # set to default of INFO
      for h in logging.root.handlers:
         logging.root.removeHandler(h)
      logging.basicConfig(level=logging.INFO,
                          format=logging_format,
                          datefmt=logging_datefmt,
                          filename=args.logfilename)

   log_files = []
   for g in args.input:
      log_files += glob.glob(g)
   log_files = sorted(log_files)

   output_data = []

   for log_file in log_files:
      logger.info('processing %s',log_file)
      parts = log_file.split('.')
      jobid = parts[0]
      config = get_config(parts[1])
      lines = open(log_file).readlines()

      singularity_image = False

      rank_data = {}
      nranks = 1
      nepochs = 1

      import_times = []
      epoch_times = []
      test_loss = 0.
      test_acc = 0.

      for line in lines:
         try:
            if 'HOROVOD MNIST' in line and 'Singularity' in line:
               singularity_image = True
            elif line.startswith('mpi rank'):
               parts = line.split()
               # rank = int(parts[2])
               nranks = int(parts[4].replace(';',''))
               import_time = float(parts[-1])
               import_times.append(import_time)
            elif line.startswith('Epoch'):
               parts = line.split()
               parts = parts[1].split('/')
               # epoch = int(parts[0])
               nepochs = int(parts[1])
            elif line.find('===] - ') >= 0:
               start = line.find('===] - ') + len('===] - ')
               end = line.find('s',start)
               epoch_time = int(line[start:end])
               epoch_times.append(epoch_time)
            elif line.startswith('Test loss:'):
               parts = line.split()
               test_loss = float(parts[2][:7])
            elif line.startswith('Test accuracy:'):
               parts = line.split()
               test_acc = float(parts[2])

         except Exception as e:
            logger.exception('received exception for line: %s',line)
            
      # assert(len(waittimes) == len(runtimedata['run_time']))

      try:
         log_data = {}
         log_data['import_times'] = get_mean_sigma(import_times)
         log_data['epoch_times'] = get_mean_sigma(epoch_times)
         log_data['test_loss'] = test_loss
         log_data['test_acc'] = test_acc
         log_data['nranks'] = nranks
         log_data['nepochs'] = nepochs
         log_data['jobid'] = jobid
         log_data['singularity'] = singularity_image
         log_data['config'] = config

         output_data.append(log_data)
         logger.info('data: %s',log_data)
      except:
         logger.exception('exception processing file %s',log_file)
         


   print('jobid\tnranks\tnepochs\tsingularity\tnodes\tlfssize\tlfscount\timport_times\t\tepoch_times\ttest_loss\ttest_acc')
   for output in output_data:
      try:
         string = '%10s' % output['jobid'] + '\t'
         string += '%10i' % output['nranks'] + '\t'
         string += '%10i' % output['nepochs'] + '\t'
         string += '%10i' % int(output['singularity']) + '\t'
         if output['config'] is not None:
            string += '%10s' % output['config']['nodes'] + '\t'
            string += '%10s' % output['config']['lfssize'] + '\t'
            string += '%10s' % output['config']['lfscount'] + '\t'
         else:
            string += '\t\t\t'
         string += '%10.4f' % output['import_times']['mean'] + '\t'
         string += '%10.4f' % output['import_times']['sigma'] + '\t'
         string += '%10.4f' % output['epoch_times']['mean'] + '\t'
         string += '%10.4f' % output['epoch_times']['sigma'] + '\t'
         string += '%10.4f' % output['test_loss'] + '\t'
         string += '%10.4f' % output['test_acc']
         print(string)
      except:
         logger.exception('error printing %s',output)
         raise


def get_config(output_string):
   if '_' in output_string:
      parts = output_string.split('_')
      nodes = None
      lfscount = None
      lfssize = None
      for part in parts:  # _512k_50c_4n
         if part[-1] == 'n':
            nodes = int(part[:-1])
         elif part[-1] == 'c':
            lfscount = int(part[:-1])
         elif part[-1] == 'k':
            lfssize = int(part[:-1])*1024
         elif part[-1] == 'm':
            lfssize = int(part[:-1])*1024*1024

      return {'nodes':nodes,'lfscount':lfscount,'lfssize':lfssize}

   return None


def get_mean_sigma(data):
   if len(data) == 0: return {'mean':0.,'sigma':0.}
   sum = 0.
   sum2 = 0.
   for i in range(len(data)):
      sum += data[i]
      sum2 += data[i]*data[i]

   n = float(len(data))
   output = {}
   mean = sum / n
   output['mean'] = mean
   output['sigma'] = np.sqrt((1./n)*sum2 - mean*mean)
   return output
   
   


if __name__ == "__main__":
   main()
