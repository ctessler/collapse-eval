#!/bin/bash

# Number of jobs, not make parallel jobs -- necessary for scripts
JOBS=${JOBS:-4}

# Task *SET* Parameters
# Count of task sets with "same" utilization
TCNT=20

# Total task set utilization
TASKSET_UTILS=(${TASKSET_UTILS[@]:-0.5 1 2 4 8 16 20 24 28 32 36})

# Architecture Parameters
CORES=(${CORES[@]:-2 4 8 12 16 20 24 28 32})
