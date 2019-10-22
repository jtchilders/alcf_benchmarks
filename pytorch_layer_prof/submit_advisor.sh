#!/bin/bash
#COBALT -n 1
#COBALT -t 60
#COBALT -q debug-flat-quad
#COBALT -A datascience
#COBALT --jobname pytorch_layer_prof

export LD_PRELOAD=
module unload darshan
module swap intel/18.0.0.128 intel/19.0.3.199
#module load datascience/pytorch-1.1
module load miniconda-3
module list

export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/soft/compilers/intel/19.0.3.199/advisor_2019.3.0.591490/lib64

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



