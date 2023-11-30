import random
import sys
import time

N_VERTICES = int(sys.argv[1])
N_EDGES = int(sys.argv[2])
TIMESTAMP = int(sys.argv[3])
MAX_WEIGHT = 100

def randomize(n):
    return random.randint(1, n)

def saveToFile(n_edges):
    filename = f"./src/graphs/Exec_"+sys.argv[1]+"-V_"+sys.argv[2]+"-E_"+sys.argv[3]+"-raw_data"
    with open(filename, "w") as file:
        v1 = N_VERTICES + 1
        for i in range(n_edges):
            v1 -= 1
            if v1 <= 0:
                v1 = N_VERTICES
            v2 = randomize(N_VERTICES-1)
            if v2 == v1 and v2 < (N_VERTICES-2):
                v2 += 1
            else:
                v2 -= 1
            file.write(f"{v1};{v2};{random.randint(0, MAX_WEIGHT)}\n")

# def main():
random.seed(time.time())

    # print("Random graph generation: ")

    # n_edges = ((((random.randint(0, N_VERTICES - 1)) * 100) - random.randint(0, N_VERTICES - 1)) // 2) + random.randint(0, N_VERTICES - 1)

saveToFile(N_EDGES)

# if __name__ == "__main__":
#     main()
