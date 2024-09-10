#!/usr/bin/env python

"""Renames invoice PDFs according to their content."""

# Imports
from tkinter import filedialog as fd
from glob import glob as g
from os.path import join as j
from datetime import datetime as dt
from os import rename as rn
import locale
import os
import re

# Constants
IMPORT_ERROR = "Error: Module \"{0}\" not installed.\nInstall using \"pip install {0}\" in console."
PATH_QUESTION = "Where are the files to rename? (Default: Downloads)\n"
STARTING_MSG = "Renaming files...\n"
CLOSING_MSG = "\nDone.\nPlease check naming for accuracy. . .\nPress Enter to close. . ."
DEFAULT_FILES_PATH = os.environ['USERPROFILE'] + r"\Downloads"
FILE_EXT = ".pdf"
TYPE_STR = "Store"
TYPE_EXT_REGEX = r"Sold? (?:by:|by) (\w+)"
DATE_REGEX = r"(?<!Ordering date )\d{2}(?:\.? [^\W\d_]+ |\.\d{2}\.)\d{4}"
DATE_FORMAT_LONG = "%B %d. %Y"
DATE_FORMAT_SHORT = "%m/%d/%Y"
MAIN_SEP = " - "
SEC_SEP = ", "
LANG = "en_US"

# Import non-default package.
try:
    from pypdf import PdfReader as pdfr
except ModuleNotFoundError:
    input(IMPORT_ERROR.format("pypdf"))
    exit(1)


# Get iso date string from match
def get_date_str(str, format):
    return dt.strptime(str, format).date().isoformat()


# Main
path = fd.askdirectory(initialdir=DEFAULT_FILES_PATH)
if len(path) == 0:
    exit()
files = g(j(path, "*" + FILE_EXT))
i = 1
print(STARTING_MSG)
for f in files:
    name = os.path.basename(f)
    path = os.path.dirname(f)
    # Open PDF and get text on first page
    pdf = pdfr(f)
    pdf_txt = pdf.pages[0].extract_text()
    #print(bn(f))
    #print(pdf_txt + "\n\n")
    locale.setlocale(locale.LC_ALL, LANG)
    # Get date
    date_str = ""
    m = re.search(DATE_REGEX, pdf_txt)
    if m is not None:
        date_match = m.group(0).replace(" ", ".").replace("..", ".")
        try:
            date_str = get_date_str(date_match, DATE_FORMAT_LONG)
        except ValueError:
            try: 
                date_str = get_date_str(date_match, DATE_FORMAT_SHORT)
            except:
                pass
    m = re.search(TYPE_EXT_REGEX, pdf_txt)
    if m is not None:
        type_ext = m.group(1).capitalize()
    else:
        type_ext = ""
    # Build new name and rename file
    new_name = MAIN_SEP.join([date_str, SEC_SEP.join([TYPE_STR, type_ext]), str(i)]) + FILE_EXT
    print(new_name)
    try:
        rn(j(path, name), j(path, new_name))
    except IOError as e:
        print(str(e))
    i += 1

input(CLOSING_MSG)