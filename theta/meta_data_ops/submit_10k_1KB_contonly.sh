#!/bin/bash
#COBALT -A datascience
#COBALT --jobname metadata_perf

NODES=$1
RANKS_PER_NODE=$2
echo [$SECONDS] starting test of meta data access
echo [$SECONDS] nodes x ranks_per_node: $NODES x $RANKS_PER_NODE

env | sort > ${COBALT_JOBID}.env

TYPE=1k_1KB
CONTAINER=/projects/datascience/parton/datafiles_$TYPE.simg
EXEC=/home/parton/git/alcf_benchmarks/theta/meta_data_ops/measure_meta_data_ops.py
DIR=/projects/datascience/parton/datafiles_$TYPE
NTIMEITS=10
NREPEATS=10

echo [$SECONDS] using type $TYPE
module swap cray-mpich cray-mpich-abi
export SINGULARITYENV_LD_LIBRARY_PATH=/opt/cray/wlm_detect/default/lib64/:$CRAY_LD_LIBRARY_PATH:$LD_LIBRARY_PATH


echo [$SECONDS] run timeit $NTIMEITS times and repeat $NREPEATS times

for MULTIPLIER in 1 2 4 8 16 32 64
do
   
   TMP_RPN=$(( $RANKS_PER_NODE * $MULTIPLIER ))
   TOTAL_RANKS=$(( $NODES * $TMP_RPN ))
   echo [$SECONDS] running with $TOTAL_RANKS = $NODES x $TMP_RPN

      echo [$SECONDS] start test in container: $CONTAINER
   aprun -n $TOTAL_RANKS -N $TMP_RPN singularity exec -B /opt -B /etc/alternatives $CONTAINER python3.6 /tests/measure_meta_data_ops.py -p /tests/datafiles --ntimeits $NTIMEITS --nrepeats $NREPEATS

   echo [$SECONDS] done with TMP_RPN=$TMP_RPN
done

echo [$SECONDS] completed

