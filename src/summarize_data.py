import re
import sys

import numpy as np

# List of parameters
# $N_VERTICES = sys.argv[1]
# $N_EDGES = sys.argv[2]
# $TIMESTAMP = sys.argv[3]
# $RAND_NUM = sys.argv[4]
# $STATS_FILE = sys.argv[5]
# $N_TIMES_EXEC = sys.argv[6]


algorithms = ["Edmonds Karp", "Dinic", "Scipy_EK", "Scipy_Dinic"]
active_algorithm = -1
execution_counter = -1
data_counter = 0
real_time_set = np.array([[np.single(-1) for j in range(int(sys.argv[6]))] for i in range(4)])
real_time_results = np.array([np.single(-1) for i in range(4)])
total_time_set = np.array([[np.single(-1) for j in range(int(sys.argv[6]))] for i in range(4)])
total_time_results = np.array([np.single(-1) for i in range(4)])
file = open(sys.argv[5], "r")

for line in file:
    if line.startswith("========"):
        if execution_counter != np.single(-1):
            real_time_results[active_algorithm] = np.mean(real_time_set[active_algorithm], dtype=np.single)
            total_time_results[active_algorithm] = np.mean(total_time_set[active_algorithm], dtype=np.single)
        active_algorithm += 1
        execution_counter = 1
        continue
    elif line.startswith("####### "):
        match = re.search(r"(\d+\.\d+|\d+) seconds", line)
        if match:
            if data_counter == 0:
                # print("actite algorithm: ", active_algorithm, " execution_counter: ", execution_counter, " data_counter: ", data_counter)
                # print("real time: \n", real_time_set)
                real_time_set[active_algorithm][execution_counter-1] = (float(match.group(1)))
                data_counter += 1
            else:
                total_time_set[active_algorithm][execution_counter-1] = (float(match.group(1)))
                data_counter = 0
    elif line.startswith("__________"):
        execution_counter += 1

    elif line.startswith("&&&&&&&&"):
        print("Results for: ", sys.argv[1], "vertices, ", sys.argv[2], "edges, ", sys.argv[3], "timestamp, ", sys.argv[4], "rand_sink, ", sys.argv[6], "n_execs\n")
        for i in range(4):
            print(algorithms[i], "\n\t real time:", real_time_results[i], "\n\t total time:", total_time_results[i], "\n")
        # print("real time: \n", real_time_set)
        # print("total time: \n", total_time_set)

file.close()
# def read_file()
