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

RANKS_PER_NODE=2
TOTAL_RANKS=$(( $COBALT_JOBSIZE * $RANKS_PER_NODE))

CONTAINER_BASE=/projects/datascience/parton
LUSTRE_COUNT=50c
LUSTRE_STRIPE_SIZE=128k
CONTAINER=$CONTAINER_BASE/lfs_${LUSTRE_STRIPE_SIZE}_${LUSTRE_COUNT}/miniconda040512.simg
#CONTAINER=$PWD/miniconda040512.simg

OUTPUT_FILE=${COBALT_JOBID}.output_${TOTAL_RANKS}n_${LUSTRE_STRIPE_SIZE}_${LUSTRE_COUNT}
echo [$SECONDS] starting run with container $CONTAINER > $OUTPUT_FILE
echo [$SECONDS] HOROVOD MNIST Test using Conda installed in Singularity  date = $(date) >> $OUTPUT_FILE
aprun -n $TOTAL_RANKS -N $RANKS_PER_NODE singularity exec -B /opt:/opt:ro $CONTAINER python /home/parton/git/singularity_mpi_test_recipe/conda/keras_mnist.py >> $OUTPUT_FILE 2>&1
EXIT_CODE=$?
echo [$SECONDS] completed with $EXIT_CODE

LUSTRE_STRIPE_SIZE=512k
CONTAINER=$CONTAINER_BASE/lfs_${LUSTRE_STRIPE_SIZE}_${LUSTRE_COUNT}/miniconda040512.simg

OUTPUT_FILE=${COBALT_JOBID}.output_${TOTAL_RANKS}n_${LUSTRE_STRIPE_SIZE}_${LUSTRE_COUNT}
echo [$SECONDS] starting run with container $CONTAINER > $OUTPUT_FILE
echo [$SECONDS] HOROVOD MNIST Test using Conda installed in Singularity  date = $(date) >> $OUTPUT_FILE
aprun -n $TOTAL_RANKS -N $RANKS_PER_NODE singularity exec -B /opt:/opt:ro $CONTAINER python /home/parton/git/singularity_mpi_test_recipe/conda/keras_mnist.py >> $OUTPUT_FILE 2>&1
EXIT_CODE=$?
echo [$SECONDS] completed with $EXIT_CODE

LUSTRE_STRIPE_SIZE=1m
CONTAINER=$CONTAINER_BASE/lfs_${LUSTRE_STRIPE_SIZE}_${LUSTRE_COUNT}/miniconda040512.simg

OUTPUT_FILE=${COBALT_JOBID}.output_${TOTAL_RANKS}n_${LUSTRE_STRIPE_SIZE}_${LUSTRE_COUNT}
echo [$SECONDS] starting run with container $CONTAINER > $OUTPUT_FILE
echo [$SECONDS] HOROVOD MNIST Test using Conda installed in Singularity  date = $(date) >> $OUTPUT_FILE
aprun -n $TOTAL_RANKS -N $RANKS_PER_NODE singularity exec -B /opt:/opt:ro $CONTAINER python /home/parton/git/singularity_mpi_test_recipe/conda/keras_mnist.py >> $OUTPUT_FILE 2>&1
EXIT_CODE=$?
echo [$SECONDS] completed with $EXIT_CODE

LUSTRE_STRIPE_SIZE=2m
CONTAINER=$CONTAINER_BASE/lfs_${LUSTRE_STRIPE_SIZE}_${LUSTRE_COUNT}/miniconda040512.simg

OUTPUT_FILE=${COBALT_JOBID}.output_${TOTAL_RANKS}n_${LUSTRE_STRIPE_SIZE}_${LUSTRE_COUNT}
echo [$SECONDS] starting run with container $CONTAINER > $OUTPUT_FILE
echo [$SECONDS] HOROVOD MNIST Test using Conda installed in Singularity  date = $(date) >> $OUTPUT_FILE
aprun -n $TOTAL_RANKS -N $RANKS_PER_NODE singularity exec -B /opt:/opt:ro $CONTAINER python /home/parton/git/singularity_mpi_test_recipe/conda/keras_mnist.py >> $OUTPUT_FILE 2>&1
EXIT_CODE=$?
echo [$SECONDS] completed with $EXIT_CODE

LUSTRE_STRIPE_SIZE=4m
CONTAINER=$CONTAINER_BASE/lfs_${LUSTRE_STRIPE_SIZE}_${LUSTRE_COUNT}/miniconda040512.simg

OUTPUT_FILE=${COBALT_JOBID}.output_${TOTAL_RANKS}n_${LUSTRE_STRIPE_SIZE}_${LUSTRE_COUNT}
echo [$SECONDS] starting run with container $CONTAINER > $OUTPUT_FILE
echo [$SECONDS] HOROVOD MNIST Test using Conda installed in Singularity  date = $(date) >> $OUTPUT_FILE
aprun -n $TOTAL_RANKS -N $RANKS_PER_NODE singularity exec -B /opt:/opt:ro $CONTAINER python /home/parton/git/singularity_mpi_test_recipe/conda/keras_mnist.py >> $OUTPUT_FILE 2>&1
EXIT_CODE=$?
echo [$SECONDS] completed with $EXIT_CODE

LUSTRE_STRIPE_SIZE=8m
CONTAINER=$CONTAINER_BASE/lfs_${LUSTRE_STRIPE_SIZE}_${LUSTRE_COUNT}/miniconda040512.simg

OUTPUT_FILE=${COBALT_JOBID}.output_${TOTAL_RANKS}n_${LUSTRE_STRIPE_SIZE}_${LUSTRE_COUNT}
echo [$SECONDS] starting run with container $CONTAINER > $OUTPUT_FILE
echo [$SECONDS] HOROVOD MNIST Test using Conda installed in Singularity  date = $(date) >> $OUTPUT_FILE
aprun -n $TOTAL_RANKS -N $RANKS_PER_NODE singularity exec -B /opt:/opt:ro $CONTAINER python /home/parton/git/singularity_mpi_test_recipe/conda/keras_mnist.py >> $OUTPUT_FILE 2>&1
EXIT_CODE=$?
echo [$SECONDS] completed with $EXIT_CODE

LUSTRE_STRIPE_SIZE=16m
CONTAINER=$CONTAINER_BASE/lfs_${LUSTRE_STRIPE_SIZE}_${LUSTRE_COUNT}/miniconda040512.simg

OUTPUT_FILE=${COBALT_JOBID}.output_${TOTAL_RANKS}n_${LUSTRE_STRIPE_SIZE}_${LUSTRE_COUNT}
echo [$SECONDS] starting run with container $CONTAINER > $OUTPUT_FILE
echo [$SECONDS] HOROVOD MNIST Test using Conda installed in Singularity  date = $(date) >> $OUTPUT_FILE
aprun -n $TOTAL_RANKS -N $RANKS_PER_NODE singularity exec -B /opt:/opt:ro $CONTAINER python /home/parton/git/singularity_mpi_test_recipe/conda/keras_mnist.py >> $OUTPUT_FILE 2>&1
EXIT_CODE=$?
echo [$SECONDS] completed with $EXIT_CODE

LUSTRE_STRIPE_SIZE=32m
CONTAINER=$CONTAINER_BASE/lfs_${LUSTRE_STRIPE_SIZE}_${LUSTRE_COUNT}/miniconda040512.simg

OUTPUT_FILE=${COBALT_JOBID}.output_${TOTAL_RANKS}n_${LUSTRE_STRIPE_SIZE}_${LUSTRE_COUNT}
echo [$SECONDS] starting run with container $CONTAINER > $OUTPUT_FILE
echo [$SECONDS] HOROVOD MNIST Test using Conda installed in Singularity  date = $(date) >> $OUTPUT_FILE
aprun -n $TOTAL_RANKS -N $RANKS_PER_NODE singularity exec -B /opt:/opt:ro $CONTAINER python /home/parton/git/singularity_mpi_test_recipe/conda/keras_mnist.py >> $OUTPUT_FILE 2>&1
EXIT_CODE=$?
echo [$SECONDS] completed with $EXIT_CODE

LUSTRE_STRIPE_SIZE=64m
CONTAINER=$CONTAINER_BASE/lfs_${LUSTRE_STRIPE_SIZE}_${LUSTRE_COUNT}/miniconda040512.simg

OUTPUT_FILE=${COBALT_JOBID}.output_${TOTAL_RANKS}n_${LUSTRE_STRIPE_SIZE}_${LUSTRE_COUNT}
echo [$SECONDS] starting run with container $CONTAINER > $OUTPUT_FILE
echo [$SECONDS] HOROVOD MNIST Test using Conda installed in Singularity  date = $(date) >> $OUTPUT_FILE
aprun -n $TOTAL_RANKS -N $RANKS_PER_NODE singularity exec -B /opt:/opt:ro $CONTAINER python /home/parton/git/singularity_mpi_test_recipe/conda/keras_mnist.py >> $OUTPUT_FILE 2>&1
EXIT_CODE=$?
echo [$SECONDS] completed with $EXIT_CODE

LUSTRE_STRIPE_SIZE=128m
CONTAINER=$CONTAINER_BASE/lfs_${LUSTRE_STRIPE_SIZE}_${LUSTRE_COUNT}/miniconda040512.simg

OUTPUT_FILE=${COBALT_JOBID}.output_${TOTAL_RANKS}n_${LUSTRE_STRIPE_SIZE}_${LUSTRE_COUNT}
echo [$SECONDS] starting run with container $CONTAINER > $OUTPUT_FILE
echo [$SECONDS] HOROVOD MNIST Test using Conda installed in Singularity  date = $(date) >> $OUTPUT_FILE
aprun -n $TOTAL_RANKS -N $RANKS_PER_NODE singularity exec -B /opt:/opt:ro $CONTAINER python /home/parton/git/singularity_mpi_test_recipe/conda/keras_mnist.py >> $OUTPUT_FILE 2>&1
EXIT_CODE=$?
echo [$SECONDS] completed with $EXIT_CODE




RANKS_PER_NODE=4
TOTAL_RANKS=$(( $COBALT_JOBSIZE * $RANKS_PER_NODE))

CONTAINER_BASE=/projects/datascience/parton
LUSTRE_COUNT=50c
LUSTRE_STRIPE_SIZE=128k
CONTAINER=$CONTAINER_BASE/lfs_${LUSTRE_STRIPE_SIZE}_${LUSTRE_COUNT}/miniconda040512.simg
#CONTAINER=$PWD/miniconda040512.simg

OUTPUT_FILE=${COBALT_JOBID}.output_${TOTAL_RANKS}n_${LUSTRE_STRIPE_SIZE}_${LUSTRE_COUNT}
echo [$SECONDS] starting run with container $CONTAINER > $OUTPUT_FILE
echo [$SECONDS] HOROVOD MNIST Test using Conda installed in Singularity  date = $(date) >> $OUTPUT_FILE
aprun -n $TOTAL_RANKS -N $RANKS_PER_NODE singularity exec -B /opt:/opt:ro $CONTAINER python /home/parton/git/singularity_mpi_test_recipe/conda/keras_mnist.py >> $OUTPUT_FILE 2>&1
EXIT_CODE=$?
echo [$SECONDS] completed with $EXIT_CODE

LUSTRE_STRIPE_SIZE=512k
CONTAINER=$CONTAINER_BASE/lfs_${LUSTRE_STRIPE_SIZE}_${LUSTRE_COUNT}/miniconda040512.simg

OUTPUT_FILE=${COBALT_JOBID}.output_${TOTAL_RANKS}n_${LUSTRE_STRIPE_SIZE}_${LUSTRE_COUNT}
echo [$SECONDS] starting run with container $CONTAINER > $OUTPUT_FILE
echo [$SECONDS] HOROVOD MNIST Test using Conda installed in Singularity  date = $(date) >> $OUTPUT_FILE
aprun -n $TOTAL_RANKS -N $RANKS_PER_NODE singularity exec -B /opt:/opt:ro $CONTAINER python /home/parton/git/singularity_mpi_test_recipe/conda/keras_mnist.py >> $OUTPUT_FILE 2>&1
EXIT_CODE=$?
echo [$SECONDS] completed with $EXIT_CODE

LUSTRE_STRIPE_SIZE=1m
CONTAINER=$CONTAINER_BASE/lfs_${LUSTRE_STRIPE_SIZE}_${LUSTRE_COUNT}/miniconda040512.simg

OUTPUT_FILE=${COBALT_JOBID}.output_${TOTAL_RANKS}n_${LUSTRE_STRIPE_SIZE}_${LUSTRE_COUNT}
echo [$SECONDS] starting run with container $CONTAINER > $OUTPUT_FILE
echo [$SECONDS] HOROVOD MNIST Test using Conda installed in Singularity  date = $(date) >> $OUTPUT_FILE
aprun -n $TOTAL_RANKS -N $RANKS_PER_NODE singularity exec -B /opt:/opt:ro $CONTAINER python /home/parton/git/singularity_mpi_test_recipe/conda/keras_mnist.py >> $OUTPUT_FILE 2>&1
EXIT_CODE=$?
echo [$SECONDS] completed with $EXIT_CODE

LUSTRE_STRIPE_SIZE=2m
CONTAINER=$CONTAINER_BASE/lfs_${LUSTRE_STRIPE_SIZE}_${LUSTRE_COUNT}/miniconda040512.simg

OUTPUT_FILE=${COBALT_JOBID}.output_${TOTAL_RANKS}n_${LUSTRE_STRIPE_SIZE}_${LUSTRE_COUNT}
echo [$SECONDS] starting run with container $CONTAINER > $OUTPUT_FILE
echo [$SECONDS] HOROVOD MNIST Test using Conda installed in Singularity  date = $(date) >> $OUTPUT_FILE
aprun -n $TOTAL_RANKS -N $RANKS_PER_NODE singularity exec -B /opt:/opt:ro $CONTAINER python /home/parton/git/singularity_mpi_test_recipe/conda/keras_mnist.py >> $OUTPUT_FILE 2>&1
EXIT_CODE=$?
echo [$SECONDS] completed with $EXIT_CODE

LUSTRE_STRIPE_SIZE=4m
CONTAINER=$CONTAINER_BASE/lfs_${LUSTRE_STRIPE_SIZE}_${LUSTRE_COUNT}/miniconda040512.simg

OUTPUT_FILE=${COBALT_JOBID}.output_${TOTAL_RANKS}n_${LUSTRE_STRIPE_SIZE}_${LUSTRE_COUNT}
echo [$SECONDS] starting run with container $CONTAINER > $OUTPUT_FILE
echo [$SECONDS] HOROVOD MNIST Test using Conda installed in Singularity  date = $(date) >> $OUTPUT_FILE
aprun -n $TOTAL_RANKS -N $RANKS_PER_NODE singularity exec -B /opt:/opt:ro $CONTAINER python /home/parton/git/singularity_mpi_test_recipe/conda/keras_mnist.py >> $OUTPUT_FILE 2>&1
EXIT_CODE=$?
echo [$SECONDS] completed with $EXIT_CODE

LUSTRE_STRIPE_SIZE=8m
CONTAINER=$CONTAINER_BASE/lfs_${LUSTRE_STRIPE_SIZE}_${LUSTRE_COUNT}/miniconda040512.simg

OUTPUT_FILE=${COBALT_JOBID}.output_${TOTAL_RANKS}n_${LUSTRE_STRIPE_SIZE}_${LUSTRE_COUNT}
echo [$SECONDS] starting run with container $CONTAINER > $OUTPUT_FILE
echo [$SECONDS] HOROVOD MNIST Test using Conda installed in Singularity  date = $(date) >> $OUTPUT_FILE
aprun -n $TOTAL_RANKS -N $RANKS_PER_NODE singularity exec -B /opt:/opt:ro $CONTAINER python /home/parton/git/singularity_mpi_test_recipe/conda/keras_mnist.py >> $OUTPUT_FILE 2>&1
EXIT_CODE=$?
echo [$SECONDS] completed with $EXIT_CODE

LUSTRE_STRIPE_SIZE=16m
CONTAINER=$CONTAINER_BASE/lfs_${LUSTRE_STRIPE_SIZE}_${LUSTRE_COUNT}/miniconda040512.simg

OUTPUT_FILE=${COBALT_JOBID}.output_${TOTAL_RANKS}n_${LUSTRE_STRIPE_SIZE}_${LUSTRE_COUNT}
echo [$SECONDS] starting run with container $CONTAINER > $OUTPUT_FILE
echo [$SECONDS] HOROVOD MNIST Test using Conda installed in Singularity  date = $(date) >> $OUTPUT_FILE
aprun -n $TOTAL_RANKS -N $RANKS_PER_NODE singularity exec -B /opt:/opt:ro $CONTAINER python /home/parton/git/singularity_mpi_test_recipe/conda/keras_mnist.py >> $OUTPUT_FILE 2>&1
EXIT_CODE=$?
echo [$SECONDS] completed with $EXIT_CODE

LUSTRE_STRIPE_SIZE=32m
CONTAINER=$CONTAINER_BASE/lfs_${LUSTRE_STRIPE_SIZE}_${LUSTRE_COUNT}/miniconda040512.simg

OUTPUT_FILE=${COBALT_JOBID}.output_${TOTAL_RANKS}n_${LUSTRE_STRIPE_SIZE}_${LUSTRE_COUNT}
echo [$SECONDS] starting run with container $CONTAINER > $OUTPUT_FILE
echo [$SECONDS] HOROVOD MNIST Test using Conda installed in Singularity  date = $(date) >> $OUTPUT_FILE
aprun -n $TOTAL_RANKS -N $RANKS_PER_NODE singularity exec -B /opt:/opt:ro $CONTAINER python /home/parton/git/singularity_mpi_test_recipe/conda/keras_mnist.py >> $OUTPUT_FILE 2>&1
EXIT_CODE=$?
echo [$SECONDS] completed with $EXIT_CODE

LUSTRE_STRIPE_SIZE=64m
CONTAINER=$CONTAINER_BASE/lfs_${LUSTRE_STRIPE_SIZE}_${LUSTRE_COUNT}/miniconda040512.simg

OUTPUT_FILE=${COBALT_JOBID}.output_${TOTAL_RANKS}n_${LUSTRE_STRIPE_SIZE}_${LUSTRE_COUNT}
echo [$SECONDS] starting run with container $CONTAINER > $OUTPUT_FILE
echo [$SECONDS] HOROVOD MNIST Test using Conda installed in Singularity  date = $(date) >> $OUTPUT_FILE
aprun -n $TOTAL_RANKS -N $RANKS_PER_NODE singularity exec -B /opt:/opt:ro $CONTAINER python /home/parton/git/singularity_mpi_test_recipe/conda/keras_mnist.py >> $OUTPUT_FILE 2>&1
EXIT_CODE=$?
echo [$SECONDS] completed with $EXIT_CODE

LUSTRE_STRIPE_SIZE=128m
CONTAINER=$CONTAINER_BASE/lfs_${LUSTRE_STRIPE_SIZE}_${LUSTRE_COUNT}/miniconda040512.simg

OUTPUT_FILE=${COBALT_JOBID}.output_${TOTAL_RANKS}n_${LUSTRE_STRIPE_SIZE}_${LUSTRE_COUNT}
echo [$SECONDS] starting run with container $CONTAINER > $OUTPUT_FILE
echo [$SECONDS] HOROVOD MNIST Test using Conda installed in Singularity  date = $(date) >> $OUTPUT_FILE
aprun -n $TOTAL_RANKS -N $RANKS_PER_NODE singularity exec -B /opt:/opt:ro $CONTAINER python /home/parton/git/singularity_mpi_test_recipe/conda/keras_mnist.py >> $OUTPUT_FILE 2>&1
EXIT_CODE=$?
echo [$SECONDS] completed with $EXIT_CODE



RANKS_PER_NODE=8
TOTAL_RANKS=$(( $COBALT_JOBSIZE * $RANKS_PER_NODE))

CONTAINER_BASE=/projects/datascience/parton
LUSTRE_COUNT=50c
LUSTRE_STRIPE_SIZE=128k
CONTAINER=$CONTAINER_BASE/lfs_${LUSTRE_STRIPE_SIZE}_${LUSTRE_COUNT}/miniconda040512.simg
#CONTAINER=$PWD/miniconda040512.simg

OUTPUT_FILE=${COBALT_JOBID}.output_${TOTAL_RANKS}n_${LUSTRE_STRIPE_SIZE}_${LUSTRE_COUNT}
echo [$SECONDS] starting run with container $CONTAINER > $OUTPUT_FILE
echo [$SECONDS] HOROVOD MNIST Test using Conda installed in Singularity  date = $(date) >> $OUTPUT_FILE
aprun -n $TOTAL_RANKS -N $RANKS_PER_NODE singularity exec -B /opt:/opt:ro $CONTAINER python /home/parton/git/singularity_mpi_test_recipe/conda/keras_mnist.py >> $OUTPUT_FILE 2>&1
EXIT_CODE=$?
echo [$SECONDS] completed with $EXIT_CODE

LUSTRE_STRIPE_SIZE=512k
CONTAINER=$CONTAINER_BASE/lfs_${LUSTRE_STRIPE_SIZE}_${LUSTRE_COUNT}/miniconda040512.simg

OUTPUT_FILE=${COBALT_JOBID}.output_${TOTAL_RANKS}n_${LUSTRE_STRIPE_SIZE}_${LUSTRE_COUNT}
echo [$SECONDS] starting run with container $CONTAINER > $OUTPUT_FILE
echo [$SECONDS] HOROVOD MNIST Test using Conda installed in Singularity  date = $(date) >> $OUTPUT_FILE
aprun -n $TOTAL_RANKS -N $RANKS_PER_NODE singularity exec -B /opt:/opt:ro $CONTAINER python /home/parton/git/singularity_mpi_test_recipe/conda/keras_mnist.py >> $OUTPUT_FILE 2>&1
EXIT_CODE=$?
echo [$SECONDS] completed with $EXIT_CODE

LUSTRE_STRIPE_SIZE=1m
CONTAINER=$CONTAINER_BASE/lfs_${LUSTRE_STRIPE_SIZE}_${LUSTRE_COUNT}/miniconda040512.simg

OUTPUT_FILE=${COBALT_JOBID}.output_${TOTAL_RANKS}n_${LUSTRE_STRIPE_SIZE}_${LUSTRE_COUNT}
echo [$SECONDS] starting run with container $CONTAINER > $OUTPUT_FILE
echo [$SECONDS] HOROVOD MNIST Test using Conda installed in Singularity  date = $(date) >> $OUTPUT_FILE
aprun -n $TOTAL_RANKS -N $RANKS_PER_NODE singularity exec -B /opt:/opt:ro $CONTAINER python /home/parton/git/singularity_mpi_test_recipe/conda/keras_mnist.py >> $OUTPUT_FILE 2>&1
EXIT_CODE=$?
echo [$SECONDS] completed with $EXIT_CODE

LUSTRE_STRIPE_SIZE=2m
CONTAINER=$CONTAINER_BASE/lfs_${LUSTRE_STRIPE_SIZE}_${LUSTRE_COUNT}/miniconda040512.simg

OUTPUT_FILE=${COBALT_JOBID}.output_${TOTAL_RANKS}n_${LUSTRE_STRIPE_SIZE}_${LUSTRE_COUNT}
echo [$SECONDS] starting run with container $CONTAINER > $OUTPUT_FILE
echo [$SECONDS] HOROVOD MNIST Test using Conda installed in Singularity  date = $(date) >> $OUTPUT_FILE
aprun -n $TOTAL_RANKS -N $RANKS_PER_NODE singularity exec -B /opt:/opt:ro $CONTAINER python /home/parton/git/singularity_mpi_test_recipe/conda/keras_mnist.py >> $OUTPUT_FILE 2>&1
EXIT_CODE=$?
echo [$SECONDS] completed with $EXIT_CODE

LUSTRE_STRIPE_SIZE=4m
CONTAINER=$CONTAINER_BASE/lfs_${LUSTRE_STRIPE_SIZE}_${LUSTRE_COUNT}/miniconda040512.simg

OUTPUT_FILE=${COBALT_JOBID}.output_${TOTAL_RANKS}n_${LUSTRE_STRIPE_SIZE}_${LUSTRE_COUNT}
echo [$SECONDS] starting run with container $CONTAINER > $OUTPUT_FILE
echo [$SECONDS] HOROVOD MNIST Test using Conda installed in Singularity  date = $(date) >> $OUTPUT_FILE
aprun -n $TOTAL_RANKS -N $RANKS_PER_NODE singularity exec -B /opt:/opt:ro $CONTAINER python /home/parton/git/singularity_mpi_test_recipe/conda/keras_mnist.py >> $OUTPUT_FILE 2>&1
EXIT_CODE=$?
echo [$SECONDS] completed with $EXIT_CODE

LUSTRE_STRIPE_SIZE=8m
CONTAINER=$CONTAINER_BASE/lfs_${LUSTRE_STRIPE_SIZE}_${LUSTRE_COUNT}/miniconda040512.simg

OUTPUT_FILE=${COBALT_JOBID}.output_${TOTAL_RANKS}n_${LUSTRE_STRIPE_SIZE}_${LUSTRE_COUNT}
echo [$SECONDS] starting run with container $CONTAINER > $OUTPUT_FILE
echo [$SECONDS] HOROVOD MNIST Test using Conda installed in Singularity  date = $(date) >> $OUTPUT_FILE
aprun -n $TOTAL_RANKS -N $RANKS_PER_NODE singularity exec -B /opt:/opt:ro $CONTAINER python /home/parton/git/singularity_mpi_test_recipe/conda/keras_mnist.py >> $OUTPUT_FILE 2>&1
EXIT_CODE=$?
echo [$SECONDS] completed with $EXIT_CODE

LUSTRE_STRIPE_SIZE=16m
CONTAINER=$CONTAINER_BASE/lfs_${LUSTRE_STRIPE_SIZE}_${LUSTRE_COUNT}/miniconda040512.simg

OUTPUT_FILE=${COBALT_JOBID}.output_${TOTAL_RANKS}n_${LUSTRE_STRIPE_SIZE}_${LUSTRE_COUNT}
echo [$SECONDS] starting run with container $CONTAINER > $OUTPUT_FILE
echo [$SECONDS] HOROVOD MNIST Test using Conda installed in Singularity  date = $(date) >> $OUTPUT_FILE
aprun -n $TOTAL_RANKS -N $RANKS_PER_NODE singularity exec -B /opt:/opt:ro $CONTAINER python /home/parton/git/singularity_mpi_test_recipe/conda/keras_mnist.py >> $OUTPUT_FILE 2>&1
EXIT_CODE=$?
echo [$SECONDS] completed with $EXIT_CODE

LUSTRE_STRIPE_SIZE=32m
CONTAINER=$CONTAINER_BASE/lfs_${LUSTRE_STRIPE_SIZE}_${LUSTRE_COUNT}/miniconda040512.simg

OUTPUT_FILE=${COBALT_JOBID}.output_${TOTAL_RANKS}n_${LUSTRE_STRIPE_SIZE}_${LUSTRE_COUNT}
echo [$SECONDS] starting run with container $CONTAINER > $OUTPUT_FILE
echo [$SECONDS] HOROVOD MNIST Test using Conda installed in Singularity  date = $(date) >> $OUTPUT_FILE
aprun -n $TOTAL_RANKS -N $RANKS_PER_NODE singularity exec -B /opt:/opt:ro $CONTAINER python /home/parton/git/singularity_mpi_test_recipe/conda/keras_mnist.py >> $OUTPUT_FILE 2>&1
EXIT_CODE=$?
echo [$SECONDS] completed with $EXIT_CODE

LUSTRE_STRIPE_SIZE=64m
CONTAINER=$CONTAINER_BASE/lfs_${LUSTRE_STRIPE_SIZE}_${LUSTRE_COUNT}/miniconda040512.simg

OUTPUT_FILE=${COBALT_JOBID}.output_${TOTAL_RANKS}n_${LUSTRE_STRIPE_SIZE}_${LUSTRE_COUNT}
echo [$SECONDS] starting run with container $CONTAINER > $OUTPUT_FILE
echo [$SECONDS] HOROVOD MNIST Test using Conda installed in Singularity  date = $(date) >> $OUTPUT_FILE
aprun -n $TOTAL_RANKS -N $RANKS_PER_NODE singularity exec -B /opt:/opt:ro $CONTAINER python /home/parton/git/singularity_mpi_test_recipe/conda/keras_mnist.py >> $OUTPUT_FILE 2>&1
EXIT_CODE=$?
echo [$SECONDS] completed with $EXIT_CODE

LUSTRE_STRIPE_SIZE=128m
CONTAINER=$CONTAINER_BASE/lfs_${LUSTRE_STRIPE_SIZE}_${LUSTRE_COUNT}/miniconda040512.simg

OUTPUT_FILE=${COBALT_JOBID}.output_${TOTAL_RANKS}n_${LUSTRE_STRIPE_SIZE}_${LUSTRE_COUNT}
echo [$SECONDS] starting run with container $CONTAINER > $OUTPUT_FILE
echo [$SECONDS] HOROVOD MNIST Test using Conda installed in Singularity  date = $(date) >> $OUTPUT_FILE
aprun -n $TOTAL_RANKS -N $RANKS_PER_NODE singularity exec -B /opt:/opt:ro $CONTAINER python /home/parton/git/singularity_mpi_test_recipe/conda/keras_mnist.py >> $OUTPUT_FILE 2>&1
EXIT_CODE=$?
echo [$SECONDS] completed with $EXIT_CODE




exit $EXIT_CODE
