#!/usr/bin/env python

"""Brute-forces a MS Office document password. False positives are possible, just continue with the given option in that case."""

# Imports
from enum import Enum
from tkinter import filedialog as fd
import string
import io
from itertools import product
from os.path import basename as bn

class Mode(Enum):
    LOWER_CASE = "a"
    LETTERS = "A"
    NAME = "N"
    LC_NAME = "n"
    DIGITS = "0"
    ALPHANUM = "Z"
    LIST = "L"


# Constants
IMPORT_ERROR = "Error: Module \"{0}\" not installed.\nInstall using \"pip install {0}\" in console."
MIN_LENGTH_QUESTION = "What is the minimum length the password could be? "
SYMBOLS_QUESTION = f"""What symbols does the password contain?
{Mode.LOWER_CASE.value} = Only lowercase letters, {Mode.LETTERS.value} = Only letters,
{Mode.NAME.value} = Only first letter always capitalized, {Mode.LC_NAME.value} = Only first letter also capitalized,
{Mode.DIGITS.value} = Only digits, {Mode.ALPHANUM.value} = Letters and digits, {Mode.LIST.value} = Use a word list file """
START_WHERE_QUESTION = """Which is the lexicographically first “word” or letter to start trying from (e.g. to resume from a stopped run),
with capital letters ranking before lowercase ones? Leave blank to start at first possible. """
CLOSING_MSG = "\nPress Enter to close. . ."

# Import non-default package.
try:
    import msoffcrypto
except ModuleNotFoundError:
    input(IMPORT_ERROR.format("msoffcrypto"))
    exit(1)

# Get file.
file_path = fd.askopenfilename(filetypes=[("Office", "*.doc? *.xls? *.ppt?")])
if len(file_path) == 0:
    exit()

# Get config.
while True:
    min_len = input(MIN_LENGTH_QUESTION)
    if (min_len.isdigit()):
        min_len = int(min_len)
        break
while True:
    try:
        mode = Mode(input(SYMBOLS_QUESTION))
    except ValueError:
        continue
    match mode:
        case Mode.LOWER_CASE | Mode.NAME | Mode.LC_NAME:
            symbols = list(string.ascii_lowercase)
            break
        case Mode.LETTERS:
            symbols = list(string.ascii_letters)
            break
        case Mode.DIGITS:
            symbols = list(string.digits)
            break
        case Mode.ALPHANUM:
            symbols = list(string.ascii_letters) + list(string.digits)
            break
        case Mode.LIST:
            word_list = fd.askopenfilename(filetypes=[("Text", "*.txt")])
            if len(file_path) != 0:
                break
start_at = input(START_WHERE_QUESTION)

# Decrypt helper function.
decrypted = io.BytesIO()
def decryptDoc(of, pw):
    print("Trying " + pw, end="… ")
    try:
        of.load_key(password=pw)
        of.decrypt(decrypted)
    except:
        print("Fail.")
        return False
    print("Success!")
    return True

# Try passwords.
found = False
with open(file_path, 'rb') as f:
    office_file = msoffcrypto.OfficeFile(f)
    if mode == Mode.LIST:
        with open(word_list, 'r') as wl:
            pwds = [line.strip() for line in wl]
        for pwd in pwds:
            if len(pwd) >= min_len and pwd >= start_at:
                if decryptDoc(office_file, pwd):
                    found = True
                    break
    else:
        i = min_len
        while not found:
            for pwdl in product(symbols, repeat=i):
                pwd = "".join(pwdl)
                if mode == Mode.NAME:
                    pwd = pwd.capitalize()
                if pwd < start_at:
                    continue
                if decryptDoc(office_file, pwd):
                    found = True
                    break
            if mode == Mode.LC_NAME and i > 0:
                for pwdl in product(symbols, repeat=i):
                    pwd = "".join(pwdl)
                    pwd = pwd.capitalize()
                    if pwd < start_at:
                        continue
                    if decryptDoc(office_file, pwd):
                        found = True
                        break
            i += 1
if found:
    print(f"\nThe password for \"{bn(file_path)}\" could be: {pwd}")
else:
    print("\nPassword could not be found in the list.")
input(CLOSING_MSG)