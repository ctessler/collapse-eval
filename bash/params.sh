#!/bin/bash

#
# PARAMETERS TO DAG TASKSET GENERATION
#
# There are three types of parameters
#   Static: simply min and max
#   Expanded: min, max, with a step between
#   Dependent: min, max, with a step and values based on other variables
#

declare WCET1		# Single WCET max
declare SCNT		# Count of shapes

declare -a NODES	# Number of nodes V
declare -a EDGEP	# Edge probability P
declare -a OBJS		# Number of objects
declare -a GROWF	# Growth Factors
declare -a UTILS	# *TASK* Utilization Targets

declare JOBS		# Maximum parallelism, suggest (cores - 1)

JOBS=${JOBS:-3}

# Shape parameters
SCNT=${SCNT:-100}
NODES=(${NODES[@]:-4 8 16 32 64})
EDGEP=(${EDGEP[@]:-0.02 0.04 0.06 0.08 0.1 0.12 0.14 0.16 0.18 0.2})

# Demand Parameters
WCET1=${WCET1:-50}
OBJS=(${OBJS[@]:-2 4 8 16})
GROWF=(${GROWF[@]:-0.2 0.4 0.6 0.8 1.0})

# Period Parameters
UTILS=(${UTLIS[@]:-0.2 0.4 0.6 0.8 1.0 1.5 2.0 4.0 8.0})
