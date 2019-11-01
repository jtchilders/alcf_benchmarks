#!/bin/bash
#COBALT -n 1
#COBALT -t 20
#COBALT -q knl_7250
#COBALT -A datascience
#COBALT --jobname pytorch_layer_prof

source /soft/compilers/intel-2019/parallel_studio_xe_2019/psxevars.sh
source /gpfs/jlse-fs0/projects/datascience/parton/mlprof/mconda3/setup.sh
export PYTHONPATH=/gpfs/jlse-fs0/projects/datascience/parton/mlprof/pytorch/build/lib.linux-x86_64-3.7

export OMP_NUM_THREADS=8
export KMP_BLOCKTIME=0
export KMP_AFFINITY=granularity=fine,compact,1,0
echo [$SECONDS] OMP_NUM_THREADS=$OMP_NUM_THREADS
export MKL_VERBOSE=1
export MKLDNN_VERBOSE=1
echo [$SECONDS] start $(date)
advixe-cl --collect survey --project-dir ${COBALT_JOBID}_advixe -- python /gpfs/jlse-fs0/projects/datascience/parton/mlprof/alcf_benchmarks/pytorch_layer_prof/profile_layer.py -n 10
echo [$SECONDS] starting $(date)
advixe-cl --collect tripcounts -flops-and-masks -callstack-flops --project-dir ${COBALT_JOBID}_advixe -- python /gpfs/jlse-fs0/projects/datascience/parton/mlprof/alcf_benchmarks/pytorch_layer_prof/profile_layer.py -n 10
echo [$SECONDS] done $(date)



