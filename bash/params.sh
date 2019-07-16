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
declare TCNT		# Count of task sets per (CORES, UTILS)

declare -a NODES	# Number of nodes V
declare -a EDGEP	# Edge probability P
declare -a OBJS		# Number of objects
declare -a GROWF	# Growth Factors
declare -a CPFAC	# Critical Path Length Factor for setting deadlines
declare -a UTILS	# *TASK* Utilization Targets
declare -a CORES	# Core counts

declare JOBS		# Maximum parallelism, suggest (cores - 1)

JOBS=${JOBS:-4}

# Shape parameters
#SCNT=${SCNT:-100}
SCNT=${SCNT:-3}
#NODES=(${NODES[@]:-4 8 16 32 64})
NODES=(${NODES[@]:-4 8})
#EDGEP=(${EDGEP[@]:-0.02 0.04 0.06 0.08 0.1 0.12 0.14 0.16 0.18 0.2})
EDGEP=(${EDGEP[@]:-0.02 0.08 0.1 0.16 0.2})

# Demand Parameters
WCET1=${WCET1:-50}
#OBJS=(${OBJS[@]:-2 4 8 16})
OBJS=(${OBJS[@]:-2 4 8})
#GROWF=(${GROWF[@]:-0.2 0.4 0.6 0.8 1.0})
GROWF=(${GROWF[@]:-0.2 0.6 1.0})
#CPFAC=(${CPFAC[@]:-2 4 8 16})
CPFAC=(${CPFAC[@]:-2 4 8})

# Period Parameters
#UTILS=(${UTLIS[@]:-0.2 0.4 0.6 0.8 1.0 1.5 2.0 4.0 8.0})
UTILS=(${UTILS[@]:-0.2 0.6 1.0 2.0 8.0})

# Task *SET* Parameters
# Count of task sets with "same" utilization
TCNT=5

# Total task set utilization
#TASKSET_UTIL=(${TASKSET_UTIL[@]:-1 2 4 8 16 32 64 128})
TASKSET_UTILS=(${TASKSET_UTILS[@]:-1 2 4 8 10 12 14 16 18 20})

# Architecture Parameters

#CORES=(${CORES[@]:-2 4 8 16 32 64})
CORES=(${CORES[@]:-2 4 8 16})


