# Python program for implementation 
# of Ford Fulkerson algorithm
import sys
from collections import defaultdict
import time


# This class represents a directed graph 
# using adjacency matrix representation
class Graph:

	def __init__(self, graph):
		self.graph = graph # residual graph
		self. ROW = len(graph)
		# self.COL = len(gr[0])

	'''Returns true if there is a path from source 's' to sink 't' in
	residual graph. Also fills parent[] to store the path '''

	def BFS(self, s, t, parent):

		# Mark all the vertices as not visited
		visited = [False]*(self.ROW)

		# Create a queue for BFS
		queue = []

		# Mark the source node as visited and enqueue it
		queue.append(s)
		visited[s] = True

		# Standard BFS Loop
		while queue:

			# Dequeue a vertex from queue and print it
			u = queue.pop(0)

			# Get all adjacent vertices of the dequeued vertex u
			# If a adjacent has not been visited, then mark it
			# visited and enqueue it
			for ind, val in enumerate(self.graph[u]):
				if visited[ind] == False and val > 0:
					# If we find a connection to the sink node, 
					# then there is no point in BFS anymore
					# We just have to set its parent and can return true
					queue.append(ind)
					visited[ind] = True
					parent[ind] = u
					if ind == t:
						return True

		# We didn't reach sink in BFS starting 
		# from source, so return false
		return False
			
	
	# Returns the maximum flow from s to t in the given graph
	def FordFulkerson(self, source, sink):

		# This array is filled by BFS and to store path
		parent = [-1]*(self.ROW)

		max_flow = 0 # There is no flow initially

		# Augment the flow while there is path from source to sink
		while self.BFS(source, sink, parent) :

			# Find minimum residual capacity of the edges along the
			# path filled by BFS. Or we can say find the maximum flow
			# through the path found.
			path_flow = float("Inf")
			s = sink
			while(s != source):
				path_flow = min (path_flow, self.graph[parent[s]][s])
				s = parent[s]

			# Add path flow to overall flow
			max_flow += path_flow

			# update residual capacities of the edges and reverse edges
			# along the path
			v = sink
			while(v != source):
				u = parent[v]
				self.graph[u][v] -= path_flow
				self.graph[v][u] += path_flow
				v = parent[v]

		return max_flow


file = open("./src/graphs/Exec_V-"+sys.argv[1]+"_E-"+sys.argv[2]+"_TIME-"+sys.argv[3]+"-raw_data", "r")

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

file.close()

g = Graph(graph)

print(" ------ Source = 0, Sink = ", int(sys.argv[4]))
start_time = time.time()
print(" ------ Maximum flow EK: ", g.FordFulkerson(0, int(sys.argv[4])))
print("####### %s seconds to execute #######" % (time.time() - start_time))

# This code is contributed by Neelam Yadav
