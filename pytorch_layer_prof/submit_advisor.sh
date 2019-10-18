#!/bin/bash
#COBALT -n 1
#COBALT -t 60
#COBALT -q debug-flat-quad
#COBALT -A datascience
#COBALT --jobname pytorch_layer_prof

export LD_PRELOAD=

module load miniconda-3
module swap intel intel/19.0.3.199 # intel/19.0.5.274 
module unload darshan
#module swap  PrgEnv-intel PrgEnv-gnu


export OMP_NUM_THREADS=8
export KMP_BLOCKTIME=0
export KMP_AFFINITY=granularity=fine,compact,1,0
echo [$SECONDS] OMP_NUM_THREADS=$OMP_NUM_THREADS
export MKL_VERBOSE=1
export MKLDNN_VERBOSE=1
echo [$SECONDS] start $(date)
aprun -n 1 -N 1  advixe-cl --collect survey --project-dir ${COBALT_JOBID}_advixe -- python $HOME/git/alcf_benchmarks/pytorch_layer_prof/profile_layer.py -n 10
echo [$SECONDS] starting $(date)
aprun -n 1 -N 1  advixe-cl --collect tripcounts -flops-and-masks -callstack-flops --project-dir ${COBALT_JOBID}_advixe -- python $HOME/git/alcf_benchmarks/pytorch_layer_prof/profile_layer.py -n 10
echo [$SECONDS] done $(date)



