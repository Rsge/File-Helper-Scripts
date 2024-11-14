#!/usr/bin/env python

"""Removes .AAE and their original .JPG/.PNG files, keeping only modified and unedited files, from photos & videos imported from an iOS device."""

# Imports
from tkinter import filedialog as fd
from glob import glob as g
from os.path import join as j
from os.path import basename as bn
from os.path import splitext as se
import os

# Constants
EDIT_EXT = ".AAE"
NO_DEL_EXTS = [".MOV"]
DEL_WARN = "These files and their {} files will be deleted. Delete? (Y/n)".format(EDIT_EXT)
CLOSING_MSG = "\nDone.\nPress Enter to close. . ."


# Main
while True:
    # Get directory to process.
    path = fd.askdirectory()
    if len(path) == 0:
        exit()
    # Get files.
    edit_files = g(j(path, "**", "*" + EDIT_EXT), recursive=True)
    all_files = g(j(path, "**", "*.*"), recursive=True)
    del_files = []
    
    # Find matching files.
    for edit_file in edit_files:
        new_del_files = [x for x in all_files if se(bn(edit_file))[0] in x and not se(bn(x))[1] in NO_DEL_EXTS]
        del_files += new_del_files
        for new_file in new_del_files:
            new_file_name = bn(new_file)
            if se(new_file_name)[1] != EDIT_EXT:
                print(bn(new_file_name))
    confirm = input(DEL_WARN)
    # Confirm & delete.
    if confirm == "" or confirm == "Y":
        for del_file in del_files:
            os.remove(del_file)
        break

input(CLOSING_MSG)
