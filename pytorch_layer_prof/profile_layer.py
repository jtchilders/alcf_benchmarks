#!/usr/bin/env python
import argparse,logging
import torch,time,datetime
logger = logging.getLogger(__name__)

start = time.time()
print(datetime.datetime.now(),time.time() - start)
def main():
   print(time.time() - start)
   ''' simple starter program that can be copied for use when starting a new script. '''
   logging_format = '%(asctime)s %(levelname)s:%(name)s:%(message)s'
   logging_datefmt = '%Y-%m-%d %H:%M:%S'
   logging_level = logging.INFO
   
   parser = argparse.ArgumentParser(description='')
   parser.add_argument('-n','--runs',help='number of trials to run',type=int,required=True)


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
   
   print(time.time() - start)
   run_conv2d(runs=args.runs)
   print(time.time() - start)


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
   #torch.rand((batch_size,in_channels) + input_shape)
   targets = torch.arange(batch_size * out_channels * input_shape[0] * input_shape[1],dtype=torch.float).view((batch_size,out_channels) + input_shape)

   #torch.rand((batch_size,out_channels) + input_shape)
   print(time.time() - start)

   layer = torch.nn.Conv2d(in_channels,out_channels,kernel_size,stride=stride,padding=padding,bias=bias)

   if 'adam' in opt:
      opt = torch.optim.Adam(layer.parameters())
   else:
      opt = torch.optim.SGD(layer.parameters())

   loss_func = torch.nn.MSELoss()
   print(time.time() - start)

   for _ in range(runs):

      outputs = layer(inputs)

      if backward:

         loss = loss_func(outputs,targets)

         loss.backward()

         opt.step()

         opt.zero_grad()
         loss.zero_grad()

         



   


if __name__ == "__main__":
   main()
