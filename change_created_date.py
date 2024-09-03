#!/usr/bin/env python

"""Sets the Created Date of a file to a specified date."""

# Imports
from tkinter import filedialog as fd
from datetime import datetime as dt
from os import utime

# String constants
IMPORT_ERROR = "Error: Module \"pywin32\" not installed.\nInstall using \"pip install pywin32\" in console."
DATE_QUESTION = "What date and time do you want to set the Created Date to?\n(Format: yyyy-mm-dd HH:MM)\n"
DATE_ERROR_MSG = "The input wasn't recognized as a date. Please try again.\n"
REPEAT_QUESTION = "Done.\n\nTo do another batch, press Enter. . ."
DATE_FORMAT = "%Y-%m-%d %H:%M"

# Import non-default package.
try:
    import pywintypes, win32file, win32con
except ModuleNotFoundError:
    input(IMPORT_ERROR)
    exit(1)

# Function def
def change_file_creation_time(fname, newtime):
    wintime = pywintypes.Time(newtime)
    winfile = win32file.CreateFile(
        fname, win32con.GENERIC_WRITE,
        win32con.FILE_SHARE_READ | win32con.FILE_SHARE_WRITE | win32con.FILE_SHARE_DELETE,
        None, win32con.OPEN_EXISTING,
        win32con.FILE_ATTRIBUTE_NORMAL, None)
    win32file.SetFileTime(winfile, wintime, None, None)
    winfile.close()

while True:
    # Get files to change.
    files = fd.askopenfilenames()
    if len(files) == 0:
        exit()
    # Get date timestamp.
    while True:
        try:
            date_ts = dt.strptime(input(DATE_QUESTION), DATE_FORMAT).timestamp()
            break
        except ValueError:
            print(DATE_ERROR_MSG)
    # Change changed and access date to specified date.
    for file_ in files:
        change_file_creation_time(file_, date_ts)
    input(REPEAT_QUESTION)