#!/bin/bash
#COBALT -n 128
#COBALT -t 30
#COBALT -q default
#COBALT -A datascience

echo [$SECONDS] HOROVOD MNIST Test using Conda installed on Lustre date = $(date)
module load miniconda-3.6/conda-4.5.12 

env | sort > ${COBALT_JOBID}.env.txt

NODES=$COBALT_JOBSIZE
RANKS_PER_NODE=1
TOTAL_RANKS=$(( $NODES * $RANKS_PER_NODE))
OUTPUT_FILE=${COBALT_JOBID}.output_${TOTAL_RANKS}n
echo [$SECONDS] starting run
echo [$SECONDS] HOROVOD MNIST Test using Conda installed on Lustre date = $(date) > $OUTPUT_FILE
aprun -n $TOTAL_RANKS -N $RANKS_PER_NODE python keras_mnist.py >> $OUTPUT_FILE 2>&1

NODES=$COBALT_JOBSIZE
RANKS_PER_NODE=2
TOTAL_RANKS=$(( $NODES * $RANKS_PER_NODE))
OUTPUT_FILE=${COBALT_JOBID}.output_${TOTAL_RANKS}n
echo [$SECONDS] starting run
echo [$SECONDS] HOROVOD MNIST Test using Conda installed on Lustre date = $(date) > $OUTPUT_FILE
aprun -n $TOTAL_RANKS -N $RANKS_PER_NODE python keras_mnist.py >> $OUTPUT_FILE 2>&1

NODES=$COBALT_JOBSIZE
RANKS_PER_NODE=4
TOTAL_RANKS=$(( $NODES * $RANKS_PER_NODE))
OUTPUT_FILE=${COBALT_JOBID}.output_${TOTAL_RANKS}n
echo [$SECONDS] starting run
echo [$SECONDS] HOROVOD MNIST Test using Conda installed on Lustre date = $(date) > $OUTPUT_FILE
aprun -n $TOTAL_RANKS -N $RANKS_PER_NODE python keras_mnist.py >> $OUTPUT_FILE 2>&1

NODES=$COBALT_JOBSIZE
RANKS_PER_NODE=8
TOTAL_RANKS=$(( $NODES * $RANKS_PER_NODE))
OUTPUT_FILE=${COBALT_JOBID}.output_${TOTAL_RANKS}n
echo [$SECONDS] starting run
echo [$SECONDS] HOROVOD MNIST Test using Conda installed on Lustre date = $(date) > $OUTPUT_FILE
aprun -n $TOTAL_RANKS -N $RANKS_PER_NODE python keras_mnist.py >> $OUTPUT_FILE 2>&1

NODES=$COBALT_JOBSIZE
RANKS_PER_NODE=16
TOTAL_RANKS=$(( $NODES * $RANKS_PER_NODE))
OUTPUT_FILE=${COBALT_JOBID}.output_${TOTAL_RANKS}n
echo [$SECONDS] starting run
echo [$SECONDS] HOROVOD MNIST Test using Conda installed on Lustre date = $(date) > $OUTPUT_FILE
aprun -n $TOTAL_RANKS -N $RANKS_PER_NODE python keras_mnist.py >> $OUTPUT_FILE 2>&1

NODES=$COBALT_JOBSIZE
RANKS_PER_NODE=32
TOTAL_RANKS=$(( $NODES * $RANKS_PER_NODE))
OUTPUT_FILE=${COBALT_JOBID}.output_${TOTAL_RANKS}n
echo [$SECONDS] starting run
echo [$SECONDS] HOROVOD MNIST Test using Conda installed on Lustre date = $(date) > $OUTPUT_FILE
aprun -n $TOTAL_RANKS -N $RANKS_PER_NODE python keras_mnist.py >> $OUTPUT_FILE 2>&1

NODES=64
RANKS_PER_NODE=1
TOTAL_RANKS=$(( $NODES * $RANKS_PER_NODE))
OUTPUT_FILE=${COBALT_JOBID}.output_${TOTAL_RANKS}n
echo [$SECONDS] starting run
echo [$SECONDS] HOROVOD MNIST Test using Conda installed on Lustre date = $(date) > $OUTPUT_FILE
aprun -n $TOTAL_RANKS -N $RANKS_PER_NODE python keras_mnist.py >> $OUTPUT_FILE 2>&1 &

NODES=32
RANKS_PER_NODE=1
TOTAL_RANKS=$(( $NODES * $RANKS_PER_NODE))
OUTPUT_FILE=${COBALT_JOBID}.output_${TOTAL_RANKS}n
echo [$SECONDS] starting run
echo [$SECONDS] HOROVOD MNIST Test using Conda installed on Lustre date = $(date) > $OUTPUT_FILE
aprun -n $TOTAL_RANKS -N $RANKS_PER_NODE python keras_mnist.py >> $OUTPUT_FILE 2>&1 &

NODES=16
RANKS_PER_NODE=1
TOTAL_RANKS=$(( $NODES * $RANKS_PER_NODE))
OUTPUT_FILE=${COBALT_JOBID}.output_${TOTAL_RANKS}n
echo [$SECONDS] starting run
echo [$SECONDS] HOROVOD MNIST Test using Conda installed on Lustre date = $(date) > $OUTPUT_FILE
aprun -n $TOTAL_RANKS -N $RANKS_PER_NODE python keras_mnist.py >> $OUTPUT_FILE 2>&1 &

NODES=8
RANKS_PER_NODE=1
TOTAL_RANKS=$(( $NODES * $RANKS_PER_NODE))
OUTPUT_FILE=${COBALT_JOBID}.output_${TOTAL_RANKS}n
echo [$SECONDS] starting run
echo [$SECONDS] HOROVOD MNIST Test using Conda installed on Lustre date = $(date) > $OUTPUT_FILE
aprun -n $TOTAL_RANKS -N $RANKS_PER_NODE python keras_mnist.py >> $OUTPUT_FILE 2>&1 &

NODES=4
RANKS_PER_NODE=1
TOTAL_RANKS=$(( $NODES * $RANKS_PER_NODE))
OUTPUT_FILE=${COBALT_JOBID}.output_${TOTAL_RANKS}n
echo [$SECONDS] starting run
echo [$SECONDS] HOROVOD MNIST Test using Conda installed on Lustre date = $(date) > $OUTPUT_FILE
aprun -n $TOTAL_RANKS -N $RANKS_PER_NODE python keras_mnist.py >> $OUTPUT_FILE 2>&1 &

wait
