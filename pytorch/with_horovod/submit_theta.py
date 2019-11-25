#!/bin/bash
#COBALT -n 2
#COBALT -q debug-cache-quad
#COBALT -t 10
#COBALT -A datascience
#COBALT --jobname pytorch_hvd_import


module load miniconda-3/2019-11

aprun -n $COBALT_PARTSIZE -N 2 python import_test.py

