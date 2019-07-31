JOBS := 4
# Schedulability tests get no more than 15 minutes each.
TIMEOUT := 10

# Pipeline Stage 1, Graph Creation
NODES := 4 8 12 16 20 24 28 32
EDGEP := 0.02 0.06 0.10 0.14 0.18
GRAFC := 20

# Pipeline Stage 1, Demand Parameters
WCET1 := 50
OBJS  := 4 8 12 14 16
GROWF := 0.2 0.4 0.6 0.8 1.0
CPFAC := 0.5 1.0 1.5 2.0
UTILS := 0.5 1.0 2.0 4.0 8.0 16.0 24.0

# Schedulability Analysis
CORES := 2 4 8 12 16 20 24 28 32
