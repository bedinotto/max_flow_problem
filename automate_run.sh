#!/bin/bash

# array with vertices options
vertices=(1000 5000 10000 20000 50000 100000 500000 1000000)
edges=(1000 5000 10000 20000 50000 100000 500000 1000000)
# times=(1 2 3 4 5 6 7 8 9 10)

for i in {0..7}
do
	for j in {0..7}
	do
		./run_max_flow.sh ${vertices[$i]} ${edges[$j]} 10
	done
done