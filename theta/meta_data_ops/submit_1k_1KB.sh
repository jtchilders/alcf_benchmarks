#!/bin/bash
#COBALT -A datascience
#COBALT --jobname metadata_perf

NODES=$1
RANKS_PER_NODE=$2
TOTAL_RANKS=$(( $NODES * $RANKS_PER_NODE ))
echo [$SECONDS] starting test of meta data access
echo [$SECONDS] nodes x ranks_per_node: $NODES x $RANKS_PER_NODE

env | sort > ${COBALT_JOBID}.env

CONTAINER=/projects/datascience/parton/datafiles_1k_1KB.simg
EXEC=/home/parton/git/alcf_benchmarks/theta/meta_data_ops/measure_meta_data_ops.py

NTIMEITS=10
NREPEATS=10

echo [$SECONDS] run timeit $NTIMEITS times and repeat $NREPEATS times

module swap cray-mpich cray-mpich-abi

export SINGULARITYENV_LD_LIBRARY_PATH=/opt/cray/wlm_detect/default/lib64/:$CRAY_LD_LIBRARY_PATH:$LD_LIBRARY_PATH

echo [$SECONDS] start test in container: $CONTAINER
aprun -n $TOTAL_RANKS -N $RANKS_PER_NODE \
    singularity exec -B /opt -B /etc/alternatives $CONTAINER python3.6 /tests/measure_meta_data_ops.py -p /tests/datafiles --ntimeits $NTIMEITS --nrepeats $NREPEATS

module swap cray-mpich-abi cray-mpich

module load miniconda-3.6/conda-4.5.12

echo [$SECONDS] starting test on filesystem
aprun -n $TOTAL_RANKS -N $RANKS_PER_NODE \
    $EXEC -p /projects/datascience/parton/datafiles_1k_1KB --ntimeits $NTIMEITS --nrepeats $NREPEATS
echo [$SECONDS] done $?
module unload miniconda-3.6/conda-4.5.12


