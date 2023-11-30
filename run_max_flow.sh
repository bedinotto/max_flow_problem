#!/bin/bash

# dependencies:
# - src/generate_graph.py
# - src/Dinic.py
# - src/Edmonds_Karp.py
# - src/Scipy_EK.py
# - src/Scipy_Dinic.py

DEPENDENCIES="src/generate_GRAPH.py src/Dinic.py src/Edmonds_Karp.py src/Scipy_EK.py src/Scipy_Dinic.py src/summarize_data.py"
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
STATS_FILE="results/Exec_V-$N_VERTICES-_E-$N_EDGES-_TIME-$TIMESTAMP-results.data"

echo "=========================================================="
echo " Genarating graph with $N_VERTICES vertices and $N_EDGES edges"
TIMESTAMP_BEGIN=$(date +%s)
python3 src/generate_GRAPH.py $N_VERTICES $N_EDGES $TIMESTAMP
TIMESTAMP_END=$(date +%s)
echo " Graph generated in $((TIMESTAMP_END - TIMESTAMP_BEGIN)) seconds" >> $STATS_FILE
echo " Graph generated "
echo "=========================================================="
echo "" 

echo "==========================================================" >> $STATS_FILE
echo " ------ Executing Edmonds Karp $N_TIMES_EXEC times ------ " >> $STATS_FILE
echo " ------ Executing Edmonds Karp $N_TIMES_EXEC times ------ " 

for i in $(seq 1 $N_TIMES_EXEC)
do
    echo "Iteration $i"
    TIMESTAMP_BEGIN=$(date +%s)
    python3 src/Edmonds_Karp.py $N_VERTICES $N_EDGES $TIMESTAMP $RAND_NUM >> $STATS_FILE
    TIMESTAMP_END=$(date +%s)
    echo "####### $((TIMESTAMP_END - TIMESTAMP_BEGIN)) seconds Edmonds_Karp $i total" >> $STATS_FILE
    echo "____________________________________" >> $STATS_FILE
done




echo "==========================================================" >> $STATS_FILE
echo " ------ Executing Dinic $N_TIMES_EXEC times ------ " >> $STATS_FILE
echo " ------ Executing Dinic $N_TIMES_EXEC times ------ "
echo "=========================================================="
for i in $(seq 1 $N_TIMES_EXEC)
do
    echo "Iteration $i"
    TIMESTAMP_BEGIN=$(date +%s)
    python3 src/Dinic.py $N_VERTICES $N_EDGES $TIMESTAMP $RAND_NUM >> $STATS_FILE
    TIMESTAMP_END=$(date +%s)
    echo "####### $((TIMESTAMP_END - TIMESTAMP_BEGIN)) seconds Dinic $i total" >> $STATS_FILE
    echo "____________________________________" >> $STATS_FILE
done
echo "" 

echo "==========================================================" >> $STATS_FILE
echo " ------ Executing EK FROM SCIPY $N_TIMES_EXEC times ------ " >> $STATS_FILE
echo " ------ Executing EK FROM SCIPY $N_TIMES_EXEC times ------ "
echo "=========================================================="
for i in $(seq 1 $N_TIMES_EXEC)
do
    echo "Iteration $i"
    TIMESTAMP_BEGIN=$(date +%s)
    python3 src/Scipy_EK.py $N_VERTICES $N_EDGES $TIMESTAMP $RAND_NUM >> $STATS_FILE
    TIMESTAMP_END=$(date +%s)
    echo "####### $((TIMESTAMP_END - TIMESTAMP_BEGIN)) seconds Scipy_EK $i total" >> $STATS_FILE
    echo "____________________________________" >> $STATS_FILE
done
echo "" 

echo "==========================================================" >> $STATS_FILE
echo " ------ Executing DINIC FROM SCIPY $N_TIMES_EXEC times ------ " >> $STATS_FILE
echo " ------ Executing DINIC FROM SCIPY $N_TIMES_EXEC times ------ "
echo "=========================================================="
for i in $(seq 1 $N_TIMES_EXEC)
do
    echo "Iteration $i"
    TIMESTAMP_BEGIN=$(date +%s)
    python3 src/Scipy_Dinic.py $N_VERTICES $N_EDGES $TIMESTAMP $RAND_NUM >> $STATS_FILE
    TIMESTAMP_END=$(date +%s)
    echo "####### $((TIMESTAMP_END - TIMESTAMP_BEGIN)) seconds Scipy_Dinic $i total" >> $STATS_FILE
    echo "____________________________________" >> $STATS_FILE
done
echo "==========================================================" >> $STATS_FILE
echo "&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&" >> $STATS_FILE

echo "=========================================================="
echo " Generating summary of results"
SUMMARY_FILE="results/Exec_V-$N_VERTICES-_E-$N_EDGES-_TIME-$TIMESTAMP-results.summary"
python3 src/summarize_data.py $N_VERTICES $N_EDGES $TIMESTAMP $RAND_NUM $STATS_FILE $N_TIMES_EXEC >> $SUMMARY_FILE

sudo chown -R $USER results

echo "=========================================================="
echo " ls results/"
ls results/
echo "=========================================================="