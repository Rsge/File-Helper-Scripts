#!/usr/bin/env python

"""Lists all files in a directory and all it's subdirectories into a text file."""

# Imports
from tkinter import filedialog as fd
from glob import glob as g
from os.path import join as j
from os.path import basename as b

# String constants
PATH_QUESTION = "Where should the files be listed?\n"
EXTENSION_QUESTION = "File extension? (* for all)\n"
LOG_FILE = "! File List.txt"
CLOSING_MSG = "\nDone.\nPress Enter to close. . ."

# Variables
path = fd.askdirectory()
if len(path) == 0:
    exit()
ext = input(EXTENSION_QUESTION)
names = []


# Main
files = g(j(path, "**", "*." + ext), recursive=True)
for file_ in files:
    name = b(file_)
    if not name in names:
        names.append(name)
        print(name)

with open(j(path, LOG_FILE), 'w') as writer_buffer:
    writer_buffer.write('\n'.join(names))

input(CLOSING_MSG)
