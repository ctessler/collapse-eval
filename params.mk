JOBS := 4
# Pipeline Stage 1, Graph Creation
NODES := 4 8 12 16 20 24 28 32
NODES := 4 8 12 
EDGEP := 0.02 0.04 0.06 0.08. 0.10 0.12 0.14 0.16 0.18 0.20
EDGEP := 0.02 0.04 0.06 
GRAFC := 100
GRAFC := 3

# Pipeline Stage 1, Demand Parameters
WCET1 := 50
OBJS  := 2 4 8 12 14 6
OBJS  := 2 4
GROWF := 0.2 0.4 0.6 0.8 1.0
GROWF := 0.2 0.4
CPFAC := 0.5 1.0 2.0 4.0 8.0 16.0
CPFAC := 0.5 2.0 16.0
UTILS := 0.2 0.4 0.6 0.8 1.0 1.5 2.0 3.0 4.0 5.0 6.0 7.0 8.0
UTILS := 0.2 4.0 8.0

# Schedulability Analysis
CORES := 2 4 8 12 16 20 24 32
CORES := 2 4
