
import torch,horovod
import horovod.torch as hvd
hvd.init()

print('torch version = ',torch.__version__,'torch file = ',torch.__file__)
print('hvd version = ',horovod.__version__,'horovod file = ',horovod.__file__)
print('mpi rank = ',hvd.rank(),' mpi size = ',hvd.size(),' local rank = ',hvd.local_rank(),' local size = ',hvd.local_size())

