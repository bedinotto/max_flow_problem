import sys
import os
import re
import numpy as np
import matplotlib.pyplot as plt


def readData(file):
    for line in file:
        print(line)

# pattern to match the files that ends with .summary
pattern_file = re.compile(r"(.*)\.summary")
# read all files that ends with .summary in ../results directory
def openFiles():
    list_of_files = os.listdir("../results/")
    for entry in list_of_files:
        if re.fullmatch(pattern_file, entry):
            with open("../results/" + entry, "r") as f:
                readData(f)