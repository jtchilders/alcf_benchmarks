#!/bin/bash
#COBALT -n 1
#COBALT -t 60
#COBALT -q debug-flat-quad
#COBALT -A datascience
#COBALT --jobname pytorch_layer_prof

export LD_PRELOAD=

module load miniconda-3
module unload darshan
module swap  PrgEnv-intel PrgEnv-gnu

export PATH=/projects/datascience/parton/profilers/tau-2.28.2/install/craycnl/bin:$PATH
#export LD_LIBRARY_PATH=/soft/datascience/conda/miniconda3/latest/mkl-dnn_install/lib64:$LD_LIBRARY_PATH


# Generate callpath profiles
export TAU_CALLPATH=1

# Generate Trace View
#unset TAU_CALLPATH 
#export TAU_TRACE=1


export OMP_NUM_THREADS=8
export KMP_BLOCKTIME=0
export KMP_AFFINITY=“granularity=fine,compact,1,0
echo [$SECONDS] OMP_NUM_THREADS=$OMP_NUM_THREADS
export MKL_VERBOSE=1
export MKLDNN_VERBOSE=1
echo [$SECONDS] start $(date)
aprun -n 1 -N 1 tau_python -T openmp,ompt,python -ebs $HOME/git/alcf_benchmarks/pytorch_layer_prof/profile_layer.py -n 200
echo [$SECONDS] done $(date)
#aprun -n 1 -N 1 python /projects/datascience/parton/git/pointnet_toy/run_pointnet.py -c /projects/datascience/parton/git/pointnet_toy/pointnet_semseg.json
