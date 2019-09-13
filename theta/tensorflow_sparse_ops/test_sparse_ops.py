#!/usr/bin/env python
import tensorflow as tf
import numpy as np
import time

# shortcut
tfs = tf.sparse
logger = tf.compat.v1.logging

# eager execution
#tf.enable_eager_execution()
config = tf.ConfigProto()
config.inter_op_parallelism_threads = 4
config.intra_op_parallelism_threads = 4
tf.compat.v1.enable_eager_execution(config=config)


class ValueModel(tf.keras.Model):
   def __init__(self,input_dim,hidden_dim=100):
      super(ValueModel, self).__init__()

      self.cnn = tf.keras.layers.Conv2D(28,4,input_shape=(input_dim,input_dim))
      self.flatten = tf.keras.layers.Flatten()
      # this is our dense hidden layer witha ReLU activiation that will encode most of our information
      self.hidden_layer = tf.keras.layers.Dense(100,'relu',use_bias=False)
      # then we reduce to a single output with a tanh activation
      # we use tanh because -1 <= tanh(x) <= 1 and we will build a reward system based on a range -1 to 1
      self.output_layer = tf.keras.layers.Dense(1,'tanh',use_bias=False)

   def call(self,input):
      # this is the function used to actually evaluate our model on input data
      x = self.cnn(input)
      x = self.flatten(x)
      x = self.hidden_layer(x)
      x = self.output_layer(x)
      return x


def main():
   flags = tf.app.flags
   logger.set_verbosity(tf.logging.INFO)

   ranks = [2 ** 7,2 ** 8,2 ** 9,2 ** 10,2 ** 11,2 ** 12]

   funcs = [ss_add,sd_add,ss_matmul,sd_matmul]

   dim = 100
   model = ValueModel(dim)
   test = np.random.randn(50,dim,dim,1)
   result = model(test)

   logger.info('result = %s',result)

   data = {}
   for func in funcs:
      logger.info(func.__name__)
      func_data = []
      for rank in ranks:
         min,mean,sigma = timer(func,100,rank)
         logger.info(" \t%10d\t%6.3f\t%6.3f\t%6.3f",rank,min,mean,sigma)
         func_data.append((rank,min,mean,max))
      data[func.__name__] = func_data
   

def timer(func,tests,*argv):

   sum = 0.
   sum2 = 0.
   n = 0
   min = 999999999.
   for _ in range(tests):
      #start = time.time()
      diff = func(*argv)
      #end = time.time()
      # diff = end - start
      sum += diff
      sum2 += diff ** 2
      n += 1
      if diff < min:
         min = diff

   mean = sum / n
   sigma = np.sqrt((1. / n) * (sum2 - mean ** 2))

   return min,mean,sigma


####
# tfs.add with sparse + sparse
def ss_add(rank=1000,dim=2,sparsity_mean=0.5,sparsity_sigma=10):

   # number of points to fill in the matrix
   a_np = int(np.random.normal(sparsity_mean * rank,sparsity_sigma))
   if a_np <= 0:
      raise Exception(f'produced sparse tensor with no entries, settings:\n rank={rank}\n' +
                      f' dim={dim}\n sparsity_mean={sparsity_mean} sparsity_sigma={sparsity_sigma}')
   logger.debug('a_np = %s',a_np)
   a = tfs.SparseTensor(indices=np.random.randint(0,rank,(a_np,dim)),
                        values=np.random.randn(a_np),
                        dense_shape=[rank] * dim)
   b = tfs.SparseTensor(indices=np.random.randint(0,rank,(a_np,dim)),
                        values=np.random.randn(a_np),
                        dense_shape=[rank] * dim)
   start = time.time()
   c = tfs.add(a,b)
   end = time.time()

   return end - start


####
# tfs.add with sparse + dense
def sd_add(rank=1000,dim=2,sparsity_mean=0.5,sparsity_sigma=10):

   # number of points to fill in the matrix
   a_np = int(np.random.normal(sparsity_mean * rank,sparsity_sigma))
   if a_np <= 0:
      raise Exception(f'produced sparse tensor with no entries, settings:\n rank={rank}\n' +
                      f' dim={dim}\n sparsity_mean={sparsity_mean} sparsity_sigma={sparsity_sigma}')
   logger.debug('a_np = %s',a_np)
   a = tfs.SparseTensor(indices=np.random.randint(0,rank,(a_np,dim)),
                        values=np.random.randn(a_np),
                        dense_shape=[rank] * dim)
   b = np.random.randn(rank ** dim)
   b = np.reshape(b,[rank] * dim)

   start = time.time()
   c = tfs.add(a,b)
   end = time.time()

   return end - start


####
# tfs.add with sparse + dense
def ss_matmul(rank=1000,dim=2,sparsity_mean=0.5,sparsity_sigma=10):

   # number of points to fill in the matrix
   a_np = int(np.random.normal(sparsity_mean * rank,sparsity_sigma))
   if a_np <= 0:
      raise Exception(f'produced sparse tensor with no entries, settings:\n rank={rank}\n' +
                      f' dim={dim}\n sparsity_mean={sparsity_mean} sparsity_sigma={sparsity_sigma}')
   logger.debug('a_np = %s',a_np)
   a = tfs.SparseTensor(indices=np.random.randint(0,rank,(a_np,dim)),
                        values=np.random.randn(a_np),
                        dense_shape=[rank] * dim)
   b = tfs.SparseTensor(indices=np.random.randint(0,rank,(a_np,dim)),
                        values=np.random.randn(a_np),
                        dense_shape=[rank] * dim)

   start = time.time()
   c = tfs.to_dense(a,0.,validate_indices=False) * tfs.to_dense(b,0.,validate_indices=False)
   end = time.time()

   return end - start


####
# tfs.add with sparse + dense
def sd_matmul(rank=1000,dim=2,sparsity_mean=0.5,sparsity_sigma=10):

   # number of points to fill in the matrix
   a_np = int(np.random.normal(sparsity_mean * rank,sparsity_sigma))
   if a_np <= 0:
      raise Exception(f'produced sparse tensor with no entries, settings:\n rank={rank}\n' +
                      f' dim={dim}\n sparsity_mean={sparsity_mean} sparsity_sigma={sparsity_sigma}')
   logger.debug('a_np = %s',a_np)
   a = tfs.SparseTensor(indices=np.random.randint(0,rank,(a_np,dim)),
                        values=np.random.randn(a_np),
                        dense_shape=[rank] * dim)
   b = np.random.randn(rank ** dim)
   b = np.reshape(b,[rank] * dim)

   start = time.time()
   c = tfs.sparse_dense_matmul(a,b)
   end = time.time()

   return end - start


if __name__ == "__main__":
   main()
