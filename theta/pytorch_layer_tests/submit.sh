#!/bin/bash
#COBALT -A datascience
#COBALT -n 128
#COBALT -t 180
#COBALT -q default
#COBALT --jobname test_layers

#module load datascience/pytorch-1.1
module load miniconda-3
module unload darshan
ulimit -u unlimited

export OMP_NUM_THREADS=128
export KMP_AFFINITY=granularity=fine,compact,1,0
export KMP_BLOCKTIME=0

aprun -n $COBALT_PARTSIZE -N 1 --cc depth -j 2 -d $OMP_NUM_THREADS -- python ./test_layers.py -o "${COBALT_JOBID}_%05d.json" -i 372.json --debug 

