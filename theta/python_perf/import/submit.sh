#!/bin/bash
#COBALT -n 128
#COBALT -t 30
#COBALT -q default
#COBALT -A datascience

echo [$SECONDS] HOROVOD MNIST Test using Conda installed in Singularity  date = $(date) 

# Use Cray's Application Binary Independent MPI build
module swap cray-mpich cray-mpich-abi

# include CRAY_LD_LIBRARY_PATH in to the system library path
export LD_LIBRARY_PATH=$CRAY_LD_LIBRARY_PATH:$LD_LIBRARY_PATH
# also need this additional library
export LD_LIBRARY_PATH=/opt/cray/wlm_detect/1.3.2-6.0.6.0_3.8__g388ccd5.ari/lib64/:$LD_LIBRARY_PATH
# in order to pass environment variables to a Singularity container create the variable
# with the SINGULARITYENV_ prefix
export SINGULARITYENV_LD_LIBRARY_PATH=$LD_LIBRARY_PATH


env | sort > ${COBALT_JOBID}.env.txt


RANKS_PER_NODE=1

LUSTRE_SIZE=16m
LUSTRE_COUNT=50c

NODES=$COBALT_JOBSIZE
TOTAL_RANKS=$(( $NODES * $RANKS_PER_NODE))

CONTAINER=/projects/datascience/parton/lfs_${LUSTRE_SIZE}_${LUSTRE_COUNT}/miniconda040512.simg

OUTPUT_FILE=${COBALT_JOBID}.output_${NODES}n_${LUSTRE_SIZE}_${LUSTRE_COUNT}

echo [$SECONDS] HOROVOD MNIST Test using Conda installed in Singularity date = $(date) > $OUTPUT_FILE
echo [$SECONDS] starting run with container $CONTAINER >> $OUTPUT_FILE
aprun -n $TOTAL_RANKS -N $RANKS_PER_NODE singularity exec -B /opt:/opt:ro $CONTAINER python /home/parton/git/singularity_mpi_test_recipe/conda/keras_mnist.py >> $OUTPUT_FILE 2>&1
EXIT_CODE=$?
echo [$SECONDS] completed with $EXIT_CODE

NODES=64
TOTAL_RANKS=$(( $NODES * $RANKS_PER_NODE))

CONTAINER=/projects/datascience/parton/lfs_${LUSTRE_SIZE}_${LUSTRE_COUNT}/miniconda040512.simg
#CONTAINER=$PWD/miniconda040512.simg
OUTPUT_FILE=${COBALT_JOBID}.output_${NODES}n_${LUSTRE_SIZE}_${LUSTRE_COUNT}

echo [$SECONDS] HOROVOD MNIST Test using Conda installed in Singularity  date = $(date) > $OUTPUT_FILE
echo [$SECONDS] starting run with container $CONTAINER >> $OUTPUT_FILE
aprun -n $TOTAL_RANKS -N $RANKS_PER_NODE singularity exec -B /opt:/opt:ro $CONTAINER python /home/parton/git/singularity_mpi_test_recipe/conda/keras_mnist.py >> $OUTPUT_FILE 2>&1 &


NODES=32
TOTAL_RANKS=$(( $NODES * $RANKS_PER_NODE))

CONTAINER=/projects/datascience/parton/lfs_16m_50c/miniconda040512.simg
#CONTAINER=$PWD/miniconda040512.simg
OUTPUT_FILE=${COBALT_JOBID}.output_${NODES}n_${LUSTRE_SIZE}_${LUSTRE_COUNT}

echo [$SECONDS] HOROVOD MNIST Test using Conda installed in Singularity  date = $(date) > $OUTPUT_FILE
echo [$SECONDS] starting run with container $CONTAINER >> $OUTPUT_FILE
aprun -n $TOTAL_RANKS -N $RANKS_PER_NODE singularity exec -B /opt:/opt:ro $CONTAINER python /home/parton/git/singularity_mpi_test_recipe/conda/keras_mnist.py >> $OUTPUT_FILE 2>&1 &

NODES=16
TOTAL_RANKS=$(( $NODES * $RANKS_PER_NODE))

CONTAINER=/projects/datascience/parton/lfs_16m_50c/miniconda040512.simg
#CONTAINER=$PWD/miniconda040512.simg
OUTPUT_FILE=${COBALT_JOBID}.output_${NODES}n_${LUSTRE_SIZE}_${LUSTRE_COUNT}

echo [$SECONDS] HOROVOD MNIST Test using Conda installed in Singularity  date = $(date) > $OUTPUT_FILE
echo [$SECONDS] starting run with container $CONTAINER >> $OUTPUT_FILE
aprun -n $TOTAL_RANKS -N $RANKS_PER_NODE singularity exec -B /opt:/opt:ro $CONTAINER python /home/parton/git/singularity_mpi_test_recipe/conda/keras_mnist.py >> $OUTPUT_FILE 2>&1 &



wait

exit $EXIT_CODE
