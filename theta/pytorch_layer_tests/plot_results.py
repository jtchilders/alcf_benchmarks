#!/usr/bin/env python
import argparse,logging,json
import pandas as pd
import numpy as np
from mpl_toolkits.mplot3d import Axes3D
from matplotlib import pyplot as plt
logger = logging.getLogger(__name__)


colors = [
   'Red',
   'Orange',
   'Yellow',
   'Green',
   'Blue',
   'Indigo',
   'Violet',
]

markers = [
   'o',
   'v',
   '+',
   '^',
   '>',
   'x',
   '<',
   'h',
]

def main():
   ''' simple starter program that can be copied for use when starting a new script. '''
   logging_format = '%(asctime)s %(levelname)s:%(name)s:%(message)s'
   logging_datefmt = '%Y-%m-%d %H:%M:%S'
   logging_level = logging.INFO
   
   parser = argparse.ArgumentParser(description='')
   parser.add_argument('-i','--input',dest='input',help='input',required=True)
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
   
   json_data = json.load(open(args.input))

   for entry in json_data:
      entry['image_size_x'] = entry['image_size'][0]
      entry['image_size_y'] = entry['image_size'][1]
      entry['kernel_size_x'] = entry['kernel_size'][0]
      entry['kernel_size_y'] = entry['kernel_size'][1]

   data = pd.DataFrame(json_data)

   logger.info('found %s data entries',len(data))

   fig = plt.figure(figsize=(10,8),dpi=80)

   ax = []
   ax.append(fig.add_subplot(2,2,1))
   ax.append(fig.add_subplot(2,2,2))
   ax.append(fig.add_subplot(2,2,3))
   ax.append(fig.add_subplot(2,2,4))

   # ax.append(fig.add_subplot(2,2,4,projection='3d'))

   # logger.info(data[['image_size_x','min']])

   # for entry in data['kernel_size_x'].unique():
   #    subset = data[data['kernel_size_x'] == entry]
   #    subset.plot.scatter(x='image_size_y',y='min',ax=ax[0,0],label=str(entry),color=colors[entry],s=0.1,)
   
   ax[0].set_yscale('log')
   data.plot.scatter(x='image_size_y',y='min',ax=ax[0],c='kernel_size_x',cmap='Spectral_r')
   ax[1].set_yscale('log')
   data.plot.scatter(x='kernel_size_x',y='min',ax=ax[1],c='image_size_y',cmap='Spectral_r')
   ax[2].set_yscale('log')
   data.plot.scatter(x='out_channels',y='min',ax=ax[2],c='image_size_y',cmap='Spectral_r')
   ax[3].set_yscale('log')
   data.plot.scatter(x='batch_size',y='min',ax=ax[3],c='image_size_y',cmap='Spectral_r')
   
   
   # plt.Axes.set_xla
   
   # ax[3].set_zscale('log')
   

   plt.savefig('plotA.png')
   plt.show()

   figB = plt.figure(figsize=(10,8),dpi=80)
   ax = figB.add_subplot(1,1,1,projection='3d')
   
   start = np.min(data['kernel_size_x'].unique())
   for entry in data['kernel_size_x'].unique():
      subset = data[data['kernel_size_x'] == entry]
      z = np.log(subset[['min']])
      ax.scatter(subset[['out_channels']],subset[['image_size_x']],z,
                    marker=markers[entry-start],c=colors[entry-start])
   
   ax.set_xlabel('out_channels')
   ax.set_ylabel('image_size_x')
   ax.set_zlabel('flops')

   plt.savefig('plotB.png')
   plt.show()



if __name__ == "__main__":
   main()
