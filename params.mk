JOBS := 4
# Schedulability tests get no more than 15 minutes each.
TIMEOUT := 10

# Pipeline Stage 1, Graph Creation
NODES := 16 32 
EDGEP := 0.02 0.06 0.12
GRAFC := 50

# Pipeline Stage 1, Demand Parameters
WCET1 := 50
OBJS  := 4 8 16
GROWF := 0.2 0.6 1.0
UTILS := 0.25 0.50 2.0 4.0 8.0

# Schedulability Analysis
CORES := 4 8 12 16 20 24 28 32
