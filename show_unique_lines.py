#!/usr/bin/env python

"""Outputs all unique lines of a text file in order of occurence, skipping duplicates."""

# Imports
from tkinter import filedialog as fd

# Constants
OUTPUT_EXT = "_u"
CLOSING_MSG = "Done.\nPress Enter to close. . ."

# Variables
uniques = []
input_file = fd.askopenfilename()


# Exit if no PDF has been selected.
if len(input_file) == 0:
    exit(0)

# Read lines
with open(input_file, 'r') as f:
    lines = f.readlines()

# Get uniques only
for line in lines:
  if not line in uniques:
      uniques.append(line)
 
# Write lines
with open("{0}{2}.{1}".format(*input_file.rsplit('.', 1) + [OUTPUT_EXT]), 'w') as f:
    f.writelines(uniques)

input(CLOSING_MSG)