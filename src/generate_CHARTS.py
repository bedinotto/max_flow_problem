import os
import re
import sys

import matplotlib.pyplot as plt
import numpy as np

import matplotlib.colors as colors
import matplotlib.cm as cmx

from matplotlib import rcParams
from mpl_toolkits.axes_grid1.inset_locator import inset_axes

FONT_NORMAL = 20
FONT_BIG = 20
FONT_BIG = 20

FONT_LABEL = 16
rcParams['font.size'] = 14

mapa_cor = plt.get_cmap('tab20')  # carrega tabela de cores conforme dicionário
mapeamento_normalizado = colors.Normalize(vmin=0, vmax=19)  # mapeamento em 20 cores
mapa_escalar = cmx.ScalarMappable(norm=mapeamento_normalizado, cmap=mapa_cor) # lista de cores final
cores = [mapa_escalar.to_rgba(i) for i in range(20)]

algorithms = ["Edmonds Karp", "Dinic", "Scipy_EK", "Scipy_Dinic"]
n_vertices = []
n_edges = []
timestamp = []
rand_sink = []
n_execs = []
real_time = [[], [], [], []]
total_time = [[], [], [], []]
algorithm_counter = [0]

def readData(file):
    for line in file:
        if line.startswith("Results for"):
            # print("Line: ", line)
            match = re.search(r"(\d+) vertices, (\d+) edges, (\d+) timestamp, (\d+) rand_sink, (\d+) n_execs", line)
            if match:
                n_vertices.append(match.group(1))
                n_edges.append(match.group(2))
                timestamp.append(match.group(3))
                rand_sink.append(match.group(4))
                n_execs.append(match.group(5))
                print("Results for: ", n_vertices, "vertices, ", n_edges, "edges, ", timestamp, "timestamp, ", rand_sink, "rand_sink, ", n_execs, "n_execs\n")
        else:
            # try to find real time mean: and std:
            # real_time[0][algorithm_counter[0]].append(re.search(r"real time mean: (\d+\.\d+) , std: (\d+\.\d+)", line))
            # total_time[0][algorithm_counter[0]].append(re.search(r"total time mean: (\d+\.\d+) , std: (\d+\.\d+)", line))
            print("Algorithm counter: ", algorithm_counter[0])
            algorithm_counter[0] += 1
            # if real_time:
            #     print("Real time: ", real_time[0][algorithm_counter[0]])
            # if total_time:
            #     print("Total time: ", total_time[0][algorithm_counter[0]])

# pattern to match the files that ends with .summary
pattern_file = re.compile(r"(.*)\.summary")
# read all files that ends with .summary in ../results directory
def openFiles():
    list_of_files = os.listdir('results2/')
    for entry in list_of_files:
        if re.fullmatch(pattern_file, entry):
            with open('results/' + entry, 'r', encoding='utf-8') as f:
                readData(f)

openFiles()

# def plota_vertices():

#     # Width of each bar
#     # bar_width = 0.2

#     # Create a figure and axis
#     ax = plt.subplots()
#     for i in range(len(real_time[])):
#         ax.plot(n_vertices[i], real_time[i], label=algorithms[i], marker=None, linestyle='-', color=cores[i])
#     # ax.plot(x, y, label='Line Plot', marker=None, linestyle='-', color=color)

#     # Add labels, title, and custom x-axis tick labels
#     ax.set_xlabel(x_label)
#     ax.set_ylabel(y_label)
#     #ax.set_title()
#     #ax.set_xticks(x)

#     ax.set_xlim(0, 1024)
#     ax.set_ylim(-10, 400)

#     # Show the plot
#     plt.show()

    # FONT_BIG = 30
    # FONT_SIZE = 40
    # plt.rc('font', size=FONT_SIZE)  # controls default text sizes
    # plt.rc('axes', titlesize=FONT_SIZE)  # fontsize of the axes title
    # plt.rc('axes', labelsize=FONT_SIZE)  # fontsize of the x and y labels
    # plt.rc('xtick', labelsize=FONT_SIZE)  # fontsize of the tick labels
    # plt.rc('ytick', labelsize=FONT_SIZE)  # fontsize of the tick labels
    # plt.rc('figure', titlesize=FONT_SIZE)  # fontsize of the figure title
    # plt.tight_layout()
    # plt.savefig(nome+".pdf")
