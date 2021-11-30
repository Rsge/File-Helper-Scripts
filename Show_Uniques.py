#!/usr/bin/env python3


# Variables
input_file = "example.txt"
output_ext = "_u"

uniques = []

# Read lines
with open(input_file, "r") as f:
    lines = f.readlines()

# Get uniques only
for line in lines:
  if not line in uniques:
      uniques.append(line)
 
# Write lines
with open("{0}_{2}.{1}".format(*input_file.rsplit('.', 1) + [output_ext]), "w") as f:
    f.writelines(uniques)