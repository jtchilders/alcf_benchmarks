#!/bin/bash
#COBALT -n 2
#COBALT -q debug-cache-quad
#COBALT -t 10
#COBALT -A datascience
#COBALT --jobname pytorch_hvd_import


module load miniconda-3/2019-11

NODES=$COBALT_PARTSIZE
RANKS_PER_NODE=2
TOTAL_RANKS=$(( $NODES * $RANKS_PER_NODE ))

aprun -n $TOTAL_RANKS -N $RANKS_PER_NODE python import_test.py

