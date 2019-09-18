#!/usr/bin/env python
import argparse,logging,time,sys,json,os
logger = logging.getLogger(__name__)
import torch
import pandas as pd
import numpy as np
from mpi4py import MPI
from ptflops import get_model_complexity_info


def main():
   ''' simple starter program that can be copied for use when starting a new script. '''

   comm = MPI.COMM_WORLD
   rank = comm.Get_rank()
   nranks = comm.Get_size()

   logging_format = '%(asctime)s %(levelname)s:' + ('%05d' % rank) + ':%(name)s:%(message)s'
   logging_datefmt = '%Y-%m-%d %H:%M:%S'
   if rank == 0:
      logging_level = logging.INFO
   else:
      logging_level = logging.WARNING
   
   parser = argparse.ArgumentParser(description='')
   parser.add_argument('-i','--input_filename',help='input filename of previous data points measured. These will be skipped in the new run.')
   parser.add_argument('-o','--output_filename',help='output json filename, should include "%%05d" somewhere in the name for the rank ID. ',default='test_layers_%05d.json')
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
   
   # parse the rank into the output filename
   output_filename = args.output_filename % rank
   logger.info('input filename:  %s',args.input_filename)
   logger.info('output filename: %s',output_filename)
   
   combinations = get_combo_list()

   previous_data = init_data(args.input_filename)

   logger.info('combinations prior to dedupe: %s',len(combinations))
   combinations = remove_duplicates(previous_data,combinations)
   logger.info('combinations after dedupe: %s',len(combinations))

   new_data = []

   for i in range(rank,len(combinations),nranks):
      combination = combinations[i]
      logger.info('running %s',combination)
      test_data = time_cnn_layer(in_channels=combination['in_channels'],
                                 out_channels=combination['out_channels'],
                                 kernel_size=combination['kernel_size'],
                                 batch_size=combination['batch_size'],
                                 image_size=combination['image_size'])
      new_data.append(test_data)

      json.dump(new_data,open(output_filename,'w'))


def get_combo_list():
   kernel_sizes = [(2,2),(3,3),(4,4),(5,5)]
   in_channels = [1,3,4,8,16,32,64,128,256,512,1024]
   out_channels = in_channels.copy()
   image_sizes = [(32,32),(64,32),(64,64),(128,64),(128,128), (256,128),(256,256),(512,256),(512,512),(1024,512),(1024,1024)]
   batch_sizes = [16,32,64,128,256,512]

   # make list of combinations
   combinations = []
   for batch_size in batch_sizes:
      for in_channel in in_channels:
         for out_channel in out_channels:
            for image_size in image_sizes:
               for kernel_size in kernel_sizes:
                  combination = {}
                  combination['batch_size'] = batch_size
                  combination['in_channels'] = in_channel
                  combination['out_channels'] = out_channel
                  combination['image_size'] = image_size
                  combination['kernel_size'] = kernel_size
                  combinations.append(combination)
   return combinations


def get_header(kernel_dim,image_dim):
   string = ''
   string += '%10s \t' % 'class'
   string += '%10s \t' % 'flops'
   string += '%10s \t' % 'in_channels'
   string += '%10s \t' % 'out_channels'
   string += '%12s '   % 'kernel_size' + '\t' * kernel_dim
   string += '%10s \t' % 'padding'
   string += '%10s \t' % 'stride'
   string += '%10s \t' % 'bias'
   string += '%10s \t' % 'batch_size'
   string += '%12s '   % 'image_size' + '\t' * image_dim
   string += '%10s \t' % 'precision'
   string += '%10s \t' % 'min'
   string += '%10s \t' % 'mean'
   string += '%10s \t' % 'sigma'
   string += '%10s \n' % 'max'
   sys.stderr.write(string)
   return string


def init_data(filename=None):
   if filename is not None and os.path.exists(filename):
      data = json.load(open(filename))
      logger.info('found data with %s entries',len(data))
   else:
      data = []

   return data


def remove_duplicates(data,combinations):

   deduped = []
   counter = 0
   for combination in combinations:
      dupe = False
      for entry in data:
         if combination['batch_size'] == entry['batch_size']:
            if combination['in_channels'] == entry['in_channels']:
               if combination['out_channels'] == entry['out_channels']:
                  if combination['image_size'] == tuple(entry['image_size']):
                     if combination['kernel_size'] == tuple(entry['kernel_size']):
                        dupe = True
                        counter += 1
                        break
      if not dupe:
         deduped.append(combination)
   print(counter)
   return deduped


def time_cnn_layer(layer_class=torch.nn.Conv2d,in_channels=3,out_channels=16,kernel_size=(3,3),padding=1,stride=1,bias=False,batch_size=100,timed_tests=100,image_size=(128,128),precision='float32'):

   layer = layer_class(in_channels,out_channels,kernel_size,stride=stride,bias=bias)
   if hasattr(layer,precision):
      getattr(layer,precision)()
   inputs = torch.randn((batch_size,in_channels) + image_size,dtype=getattr(torch,precision))

   flops,params = get_model_complexity_info(layer,tuple(inputs.shape[1:]),print_per_layer_stat=False,as_strings=False)

   min,mean,sigma,max,pred = timer(layer,timed_tests,inputs)

   test_data = {
      'class':layer_class.__name__,
      'flops':flops,
      'in_channels':in_channels,
      'out_channels':out_channels,
      'kernel_size':kernel_size,
      'padding':padding,
      'stride':stride,
      'bias':bias,
      'batch_size':batch_size,
      'image_size':image_size,
      'precision':precision,
      'min':min,
      'mean':mean,
      'sigma':sigma,
      'max':max,
   }

   # string = ''
   # string += '%10s\t' % layer_class.__name__
   # string += '%10d\t' % flops
   # string += '%10d\t' % in_channels
   # string += '%10d\t' % out_channels
   # string += ''.join('%6d\t' % x for x in kernel_size)
   # string += '%10d\t' % padding
   # string += '%10d\t' % stride
   # string += '%10d\t' % bias
   # string += '%10d\t' % batch_size
   # string += ''.join('%6d\t' % x for x in image_size)
   # string += '%10s\t' % precision
   # string += '%10.6f\t' % min
   # string += '%10.6f\t' % mean
   # string += '%10.6f\t' % sigma
   # string += '%10.6f\n' % max
   # sys.stderr.write(string)
   # sys.stderr.flush()
   #logger.info('%s: min = %6.3f  mean = %6.3f +/- %6.3f  max = %6.3f',layer_class.__name__,min,mean,sigma,max)

   return test_data


def timer(func,tests,*argv):

   sum = 0.
   sum2 = 0.
   n = 0
   min = 999999999.
   max = 0.
   for _ in range(tests):
      start = time.time()
      ret = func(*argv)
      end = time.time()
      diff = end - start
      sum += diff
      sum2 += diff ** 2
      n += 1
      if diff < min:
         min = diff
      if diff > max:
         max = diff

   mean = sum / n
   sigma = np.sqrt((1. / n) * (sum2 - mean ** 2))

   return min,mean,sigma,max,ret








if __name__ == "__main__":
   main()
