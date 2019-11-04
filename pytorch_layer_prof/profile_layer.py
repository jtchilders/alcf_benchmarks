#!/usr/bin/env python
import argparse,logging
import torch,time,datetime
from ptflops import get_model_complexity_info
import numpy as np
logger = logging.getLogger(__name__)

start = time.time()
print(datetime.datetime.now(),time.time() - start)
def main():
   print('main',time.time() - start)
   ''' simple starter program that can be copied for use when starting a new script. '''
   logging_format = '%(asctime)s %(levelname)s:%(name)s:%(message)s'
   logging_datefmt = '%Y-%m-%d %H:%M:%S'
   logging_level = logging.INFO
   
   parser = argparse.ArgumentParser(description='')
   parser.add_argument('-n','--runs',help='number of trials to run',type=int,required=True)
   parser.add_argument('-b','--batch_size',help='batch size for inputs',type=int,default=10)
   parser.add_argument('--input_width',help='width of input',type=int,default=500)
   parser.add_argument('--input_height',help='height of input',type=int,default=500)
   parser.add_argument('-c','--input_channels',help='number of channels of input',type=int,default=3)
   parser.add_argument('-f','--filters',help='number of filters in CNN',type=int,default=64)
   parser.add_argument('-k','--kernel_size',help='kernel size',type=int,default=10)
   parser.add_argument('--stride',help='stride',type=int,default=1)
   parser.add_argument('--padding',help='padding',type=int,default=1)
   parser.add_argument('--bias',help='use bias',default=False, action='store_true')
   parser.add_argument('--backward',help='run backward pass',default=False, action='store_true')
   parser.add_argument('--opt',help='optimizer for backward measurements',default='adam')


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
   
   logger.info('start  %s',time.time() - start)
   run_conv2d(batch_size=args.batch_size,
              input_shape=(args.input_width,args.input_height),
              in_channels = args.input_channels,
              out_channels = args.filters,
              kernel_size = (args.kernel_size,args.kernel_size),
              stride = args.stride,
              padding = args.padding,
              bias = args.bias,
              opt = args.opt,
              backward = args.backward,
              runs = args.runs)
   logger.info('end  %s',time.time() - start)

def run_conv2d(batch_size=10,
               input_shape=(500,500),
               in_channels = 3,
               out_channels = 64,
               kernel_size = (10,10),
               stride = 1,
               padding = 1,
               bias = True,
               opt = 'adam',
               backward = False,
               runs = 10,
               ):
   
   inputs = torch.arange(batch_size * in_channels * input_shape[0] * input_shape[1],dtype=torch.float).view((batch_size,in_channels) + input_shape)
   logger.info('inputs.shape %s',inputs.shape)
   #torch.rand((batch_size,in_channels) + input_shape)
   targets = torch.arange(batch_size * out_channels * input_shape[0] * input_shape[1],dtype=torch.float).view((batch_size,out_channels) + input_shape)
   logger.info('targets.shape %s',targets.shape)

   #torch.rand((batch_size,out_channels) + input_shape)
   logger.info('start run_conv2d  %s',time.time() - start)

   layer = torch.nn.Conv2d(in_channels,out_channels,kernel_size,stride=stride,padding=padding,bias=bias)
   flops, params = get_model_complexity_info(layer, tuple(inputs.shape[1:]))
   logger.info(' flops = %s   params = %s',flops,params)

   if 'adam' in opt:
      opt = torch.optim.Adam(layer.parameters())
   else:
      opt = torch.optim.SGD(layer.parameters())

   loss_func = torch.nn.MSELoss()
   start_loop = time.time()
   logger.info('loop run_conv2d  %s',time.time() - start)

   for _ in range(runs):

      outputs = layer(inputs)

      if backward:

         loss = loss_func(outputs,targets)

         loss.backward()

         opt.step()

         opt.zero_grad()
         loss.zero_grad()

   duration = time.time() - start_loop
   logger.info('loop run time: %s   and time per iteration: %s',duration,duration / runs)


   


if __name__ == "__main__":
   main()
