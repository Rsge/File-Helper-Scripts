#!/usr/bin/env python

"""Sets the Modified Date of a file to a specified date."""

# Imports
from tkinter import filedialog as fd
from datetime import datetime as dt
from os import utime

# String constants
DATE_QUESTION = "What date and time do you want to set the Modified Date to?\n(Format: yyyy-mm-dd HH:MM)\n"
DATE_ERROR_MSG = "The input wasn't recognized as a date. Please try again.\n"
REPEAT_QUESTION = "Done.\n\nTo do another batch, press Enter. . ."
DATE_FORMAT = "%Y-%m-%d %H:%M"


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
        utime(file_, (date_ts, date_ts))
    input(REPEAT_QUESTION)