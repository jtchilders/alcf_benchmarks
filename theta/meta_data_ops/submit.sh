#!/bin/bash
#COBALT -A datascience
#COBALT --jobname metadata_perf

RANKS_PER_NODE=$1
TOTAL_RANKS=$(( $COBALT_PARTSIZE * $RANKS_PER_NODE ))
echo [$SECONDS] starting test of meta data access
echo [$SECONDS] nodes, ranks_per_node: $COBALT_PARTSIZE \t $RANKS_PER_NODE

env | sort > ${COBALT_JOBID}.env

CONTAINER=/projects/datascience/parton/datafiles.simg
EXEC=/home/parton/git/alcf_benchmarks/theta/meta_data_ops/measure_meta_data_ops.py

NTIMEITS=10
NREPEATS=10

echo [$SECONDS] run timeit $NTIMEITS times and repeat $NREPEATS times

module load miniconda-3.6/conda-4.5.12

echo [$SECONDS] starting test on filesystem
aprun -n $TOTAL_RANKS -N $RANKS_PER_NODE \
    $EXEC -p /projects/datascience/parton/metadata_datafiles --ntimeits $NTIMEITS --nrepeats $NREPEATS

module unload miniconda-3.6/conda-4.5.12

module swap cray-mpich cray-mpich-abi

# include CRAY_LD_LIBRARY_PATH in to the system library path
export LD_LIBRARY_PATH=$CRAY_LD_LIBRARY_PATH:$LD_LIBRARY_PATH
# also need this additional library
export LD_LIBRARY_PATH=/opt/cray/wlm_detect/1.3.2-6.0.6.0_3.8__g388ccd5.ari/lib64/:$LD_LIBRARY_PATH
# in order to pass environment variables to a Singularity container create the variable
# with the SINGULARITYENV_ prefix
export SINGULARITYENV_LD_LIBRARY_PATH=$LD_LIBRARY_PATH

echo [$SECONDS] start test in container: $CONTAINER
aprun -n $TOTAL_RANKS -N $RANKS_PER_NODE \
    singularity exec -B /opt $CONTAINER python3.6 /tests/measure_meta_data_ops.py -p /tests/datafiles --ntimeits $NTIMEITS --nrepeats $NREPEATS
