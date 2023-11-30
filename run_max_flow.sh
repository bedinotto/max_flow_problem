#!/bin/bash

# dependencies:
# - src/generate_graph.py
# - src/Dinic.py
# - src/Edmonds_Karp.py
# - src/Scipy_EK.py
# - src/Scipy_Dinic.py

DEPENDENCIES="src/generate_graph.py src/Dinic.py src/Edmonds_Karp.py src/Scipy_EK.py src/Scipy_Dinic.py"
for FILE in $DEPENDENCIES
do
    [ -f $FILE ] || {
    echo "[ERROR] missing dependency $FILE!"
    }
done

usage() {
    echo ""
    echo "Usage: $0 <n_vertices> <n_edges> <n_iterations>"
    echo "  n_vertices: The number of vertices to generate the graph in the test"
    echo "  n_edges: The number of edges the graph must have in the test"
    echo "  n_iterations: How many times the test must be executed (to get an average)"
    echo ""
    exit 
}

[ $1 ] && [ $2 ] && [ $3 ]|| { 
    usage
}

N_VERTICES=$1
N_EDGES=$2
N_TIMES_EXEC=$3

[[ "$N_VERTICES" =~ ^[0-9]+$ ]] || {
    echo ""
    echo "[ERROR] parameter 1 is NOT an integer!"
    echo ""
    sleep 2
    usage
}
[[ "$N_EDGES" =~ ^[0-9]+$ ]] || {
    echo ""
    echo "[ERROR] parameter 2 is NOT an integer!"
    echo ""
    sleep 2
    usage
}
[[ "$N_TIMES_EXEC" =~ ^[0-9]+$ ]] || {
    echo ""
    echo "[ERROR] parameter 3 is NOT an integer!"
    echo ""
    sleep 2
    usage
}

USER_ID=$(id -u $USER)
N_MAX=$(echo $(($N_VERTICES - 1)))
RAND_NUM=$(echo "$((1 + $RANDOM % $N_MAX))")
echo "RAND_NUM: $RAND_NUM"

TIMESTAMP=$(date +%Y%m%d%H%M%S)
STATS_FILE="results/Exec_$N_VERTICES-V_$N_EDGES-E_$TIMESTAMP-stats.txt"

echo "=========================================================="
echo " Genarating graph with $N_VERTICES vertices and $N_EDGES edges"
TIMESTAMP_BEGIN=$(date +%Y%m%d%H%M%S)
python3 src/generate_graph.py $N_VERTICES $N_EDGES $TIMESTAMP
TIMESTAMP_END=$(date +%Y%m%d%H%M%S)
echo " Graph generated in $((TIMESTAMP_END - TIMESTAMP_BEGIN)) seconds" >> $STATS_FILE
echo " Graph generated "
echo "=========================================================="
echo "" 



echo "==========================================================" >> $STATS_FILE
echo " ------ Executing Edmonds Karp $N_TIMES_EXEC times ------ " >> $STATS_FILE

for i in $(seq 1 $N_TIMES_EXEC)
do
    echo "Iteration $i"
    TIMESTAMP_BEGIN=$(date +%Y%m%d%H%M%S)
    python3 src/Edmonds_Karp.py $N_VERTICES $N_EDGES $TIMESTAMP $RAND_NUM >> $STATS_FILE
    TIMESTAMP_END=$(date +%Y%m%d%H%M%S)
    echo " Edmonds Karp $i executed in $((TIMESTAMP_END - TIMESTAMP_BEGIN)) seconds" >> $STATS_FILE
    echo "____________________________________" >> $STATS_FILE
done

echo "==========================================================" >> $STATS_FILE
echo " ------ Executing Dinic $N_TIMES_EXEC times ------ " >> $STATS_FILE
echo "=========================================================="
for i in $(seq 1 $N_TIMES_EXEC)
do
    echo "Iteration $i"
    TIMESTAMP_BEGIN=$(date +%Y%m%d%H%M%S)
    python3 src/Dinic.py $N_VERTICES $N_EDGES $TIMESTAMP $RAND_NUM >> $STATS_FILE
    TIMESTAMP_END=$(date +%Y%m%d%H%M%S)
    echo " Dinic execution $i executed in $((TIMESTAMP_END - TIMESTAMP_BEGIN)) seconds" >> $STATS_FILE
    echo "____________________________________" >> $STATS_FILE
done
echo "" 

echo "==========================================================" >> $STATS_FILE
echo " ------ Executing EK FROM SCIPY $N_TIMES_EXEC times ------ " >> $STATS_FILE
echo "=========================================================="
for i in $(seq 1 $N_TIMES_EXEC)
do
    echo "Iteration $i"
    TIMESTAMP_BEGIN=$(date +%Y%m%d%H%M%S)
    python3 src/Scipy_EK.py $N_VERTICES $N_EDGES $TIMESTAMP $RAND_NUM >> $STATS_FILE
    TIMESTAMP_END=$(date +%Y%m%d%H%M%S)
    echo " Scipy_EK execution $i executed in $((TIMESTAMP_END - TIMESTAMP_BEGIN)) seconds" >> $STATS_FILE
    echo "____________________________________" >> $STATS_FILE
done
echo "" 

echo "==========================================================" >> $STATS_FILE
echo " ------ Executing DINIC FROM SCIPY $N_TIMES_EXEC times ------ " >> $STATS_FILE
echo "=========================================================="
for i in $(seq 1 $N_TIMES_EXEC)
do
    echo "Iteration $i"
    TIMESTAMP_BEGIN=$(date +%Y%m%d%H%M%S)
    python3 src/Scipy_Dinic.py $N_VERTICES $N_EDGES $TIMESTAMP $RAND_NUM >> $STATS_FILE
    TIMESTAMP_END=$(date +%Y%m%d%H%M%S)
    echo " Scipy_Dinic execution $i executed in $((TIMESTAMP_END - TIMESTAMP_BEGIN)) seconds" >> $STATS_FILE
    echo "____________________________________" >> $STATS_FILE
done
echo "" 

sudo chown -R $USER results

echo "=========================================================="
echo " ls results/"
ls results/
echo "=========================================================="