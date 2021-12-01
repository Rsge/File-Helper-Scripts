#!/usr/bin/env python3

from glob import glob as g

# Variables
output_ext = "_u"
uniques = []

# Get file
while True:
	input_file_name = input("\nWhich file should be processed?\n")
	input_file = g(input_file_name)
	if len(input_file) > 0:
	    input_file = input_file[0]
	    break
	print("This file doesn't exist, try again.")

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

print("Done.\n")
input("Press Enter to exit. . .")
exit(0)