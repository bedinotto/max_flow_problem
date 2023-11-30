import sys
# import numpy as np
from scipy.sparse import csr_matrix
from scipy.sparse.csgraph import maximum_flow

file = open("./src/graphs/Exec_"+sys.argv[1]+"-V_"+sys.argv[2]+"-E_"+sys.argv[3]+"-raw_data", "r")

def read_graph(file):
	# create a graph with a matrix of adjacencies of size VxV
	graph = [[0 for i in range(int(sys.argv[1]))] for j in range(int(sys.argv[1]))]
	# print("len(graph): ", len(graph), " len(graph[0]): ", len(graph[0]))
	for line in file:
		line.replace("\n", "")
		line = line.split(";")
		# print(line)
		graph[int(line[0])-1][int(line[1])] = int(line[2])
	return graph

graph = read_graph(file)

print("Source = 0, Sink = ", int(sys.argv[4]))
print (" ------> Maximum flow DINIC FROM SCIPY: ", maximum_flow(csr_matrix(graph), 0, int(sys.argv[4]), method='dinic').flow_value)