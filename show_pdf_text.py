#!/usr/bin/env python3

"""Shows all text contained in a PDF."""

# Imports
from tkinter import filedialog as fd
from pypdf import PdfReader as pdfr


# Constants
CLOSING_MSG = "\n\n\nPress Enter to close. . ."

# Variables
file_ = fd.askopenfilename(filetypes=[("PDF", "*.pdf")])


# Exit if no PDF has been selected.
if len(file_) == 0:
    exit(0)

# Open PDF and get text on first page.
print()
pdf = pdfr(file_)
pdf_txt = pdf.pages[0].extract_text()
print(pdf_txt)

input(CLOSING_MSG)