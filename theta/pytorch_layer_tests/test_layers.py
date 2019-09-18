#!/usr/bin/env python
import argparse,logging,time,sys,json,os
logger = logging.getLogger(__name__)
import torch
import pandas as pd
import numpy as np
from ptflops import get_model_complexity_info


def main():
   ''' simple starter program that can be copied for use when starting a new script. '''
   logging_format = '%(asctime)s %(levelname)s:%(name)s:%(message)s'
   logging_datefmt = '%Y-%m-%d %H:%M:%S'
   logging_level = logging.INFO
   
   parser = argparse.ArgumentParser(description='')
   # parser.add_argument('-i','--input',dest='input',help='input',required=True)
   parser.add_argument('-o','--output_filename',help='output jasn filename',default='test_layers.json')
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
   
   # # Conv2d tests
   # batch_size = 10
   # image_size = (128,128)
   # in_channels = 3
   # out_channels = 16

   # layer = torch.nn.Conv2d(in_channels,out_channels,(3,3),stride=1,padding=1,bias=False)
   # opt = torch.optim.SGD(layer.parameters(),lr=0.1)
   # lossfunc = torch.nn.BCELoss()
   # activation = torch.nn.Sigmoid()

   # opt.zero_grad()

   # inputs = torch.randn((batch_size,in_channels) + image_size,dtype=torch.float32)
   # targets = torch.randn((batch_size,out_channels) + image_size,dtype=torch.float32)
   # targets = torch.abs(targets)



   kernel_sizes = [(2,2),(3,3),(4,4),(5,5)]
   in_channels = [1,3,4,8,16,32,64,128,256,512,1024]
   out_channels = in_channels.copy()
   image_sizes = [(32,32),(64,32),(64,64),(128,64),(128,128), (256,128),(256,256),(512,256),(512,512),(1024,512),(1024,1024)]
   batch_sizes = [16,32,64,128,256,512]

   string = ''
   string += '%10s \t' % 'class'
   string += '%10s \t' % 'flops'
   string += '%10s \t' % 'in_channels'
   string += '%10s \t' % 'out_channels'
   string += '%12s '   % 'kernel_size' + '\t' * len(kernel_sizes[0])
   string += '%10s \t' % 'padding'
   string += '%10s \t' % 'stride'
   string += '%10s \t' % 'bias'
   string += '%10s \t' % 'batch_size'
   string += '%12s '   % 'image_size' + '\t' * len(image_sizes[0])
   string += '%10s \t' % 'precision'
   string += '%10s \t' % 'min'
   string += '%10s \t' % 'mean'
   string += '%10s \t' % 'sigma'
   string += '%10s \n' % 'max'
   sys.stderr.write(string)

   if os.path.exists(args.output_filename):
      data = json.load(open(args.output_filename))
      logger.info('found data with %s entries',len(data))
   else:
      data = []

   for batch_size in batch_sizes:
      for in_channel in in_channels:
         for out_channel in out_channels:
            for image_size in image_sizes:
               for kernel_size in kernel_sizes:

                  done_already = False
                  for entry in data:
                     if (entry['batch_size']    == batch_size and
                         entry['in_channels']   == in_channel and
                         entry['out_channels']  == out_channel and
                         tuple(entry['image_size'])    == image_size and
                         tuple(entry['kernel_size'])   == kernel_size):
                        done_already = True
                        break

                  if done_already:
                     break

                  test_data = time_cnn_layer(in_channels=in_channel,
                                             out_channels=out_channel,
                                             kernel_size=kernel_size,
                                             batch_size=batch_size,
                                             image_size=image_size)
                  data.append(test_data)

                  json.dump(data,open(args.output_filename,'w'))


   #time_cnn_layer()
   #min,mean,sigma,max,pred = timer(layer,100,inputs)
   #logger.info('fwd: min = %6.3f  mean = %6.3f +/- %6.3f  max = %6.3f',min,mean,sigma,max)


   # min,mean,sigma,max,pred = timer(activation,100,pred)
   # logger.info('act: min = %6.3f  mean = %6.3f +/- %6.3f  max = %6.3f',min,mean,sigma,max)

   # min,mean,sigma,max,loss = timer(lossfunc,100,pred,targets)
   # logger.info('loss: min = %6.3f  mean = %6.3f +/- %6.3f  max = %6.3f',min,mean,sigma,max)

   # min,mean,sigma,max,loss = timer(loss.backward,100,layer.parameters(),True)
   # logger.info('loss: min = %6.3f  mean = %6.3f +/- %6.3f  max = %6.3f',min,mean,sigma,max)


def time_cnn_layer(layer_class=torch.nn.Conv2d ,in_channels=3,out_channels=16,kernel_size=(3,3),padding=1,stride=1,bias=False,batch_size=100,timed_tests=100,image_size=(128,128),precision='float32'):

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

   string = ''
   string += '%10s\t' % layer_class.__name__
   string += '%10d\t' % flops
   string += '%10d\t' % in_channels
   string += '%10d\t' % out_channels
   string += ''.join('%6d\t' % x for x in kernel_size)
   string += '%10d\t' % padding
   string += '%10d\t' % stride
   string += '%10d\t' % bias
   string += '%10d\t' % batch_size
   string += ''.join('%6d\t' % x for x in image_size)
   string += '%10s\t' % precision
   string += '%10.6f\t' % min
   string += '%10.6f\t' % mean
   string += '%10.6f\t' % sigma
   string += '%10.6f\n' % max
   sys.stderr.write(string)
   sys.stderr.flush()
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
