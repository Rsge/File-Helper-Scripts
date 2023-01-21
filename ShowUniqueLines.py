#!/usr/bin/env python3

"""
Outputs all unique lines of a text file in order of occurence, skipping duplicates.
"""

# Imports
from glob import glob as g

# Constants
OUTPUT_EXT = "_u"
INPUT_QUESTION = "\nWhich file should be processed?\n"
MISSING_FILE_ERROR = "This file doesn't exist, try again."
CLOSING_MSG = "\nDone.\nPress Enter to close. . ."

# Variables
uniques = []


# Get file
while True:
	input_file_name = input(INPUT_QUESTION)
	input_file = g(input_file_name)
	if len(input_file) > 0:
		input_file = input_file[0]
		break
	print(MISSING_FILE_ERROR)

# Read lines
with open(input_file, 'r') as f:
    lines = f.readlines()

# Get uniques only
for line in lines:
  if not line in uniques:
      uniques.append(line)
 
# Write lines
with open("{0}_{2}.{1}".format(*input_file.rsplit('.', 1) + [OUTPUT_EXT]), 'w') as f:
    f.writelines(uniques)

input(CLOSING_MSG)
exit(0)