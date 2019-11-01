#!/bin/bash
#COBALT -n 1
#COBALT -t 60
#COBALT -q debug-flat-quad
#COBALT -A datascience
#COBALT --jobname pytorch_layer_prof

export LD_PRELOAD=
module unload darshan
#INTEL_VERSION=19.0.3.199
INTEL_VERSION=19.0.2.187
module swap intel/18.0.0.128 intel/$INTEL_VERSION
#module load datascience/pytorch-1.1
module load miniconda-3
module list

export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/soft/compilers/intel/$INTEL_VERSION/advisor/lib64

export OMP_NUM_THREADS=8
export KMP_BLOCKTIME=0
export OMP_AFFINITY=compact,granularity=core
export PMI_NO_FORK=1
export PE_RANK=$ALPS_APP_PE
export OMP_STACKSIZE=16G
export DARSHAN_DISABLE=1
echo [$SECONDS] OMP_NUM_THREADS=$OMP_NUM_THREADS
export MKL_VERBOSE=1
export MKLDNN_VERBOSE=1
export AMPLXE_RUNTOOL_OPTIONS=--no-altstack
ulimit unlimited
echo [$SECONDS] start $(date) $(ulimit -s)
aprun -n 1 -N 1  advixe-cl --collect survey --project-dir ${COBALT_JOBID}_advixe -- python $HOME/git/alcf_benchmarks/pytorch_layer_prof/profile_layer.py -n 10 > ${COBALT_JOBID}.survey 2>&1
echo [$SECONDS] starting $(date)
aprun -n 1 -N 1  advixe-cl --collect tripcounts -flops-and-masks -callstack-flops --project-dir ${COBALT_JOBID}_advixe -- python $HOME/git/alcf_benchmarks/pytorch_layer_prof/profile_layer.py -n 10 > ${COBALT_JOBID}.tripcounts 2>&1
echo [$SECONDS] done $(date)



