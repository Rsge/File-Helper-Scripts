#  File Helper Scripts

Small scripts to help with various different file related tasks. 

* `change_created_date.py` changes the Created Date of the chosen file(s) to a specified date and time. (**Windows only**)
* `change_modified_date.py` changes the Modified Date of the chosen file(s) to a specified date and time.
* `filter_iphone_photos.py` removes .AAE and their original .JPG/.PNG files from photos & videos imported from an iOS device, keeping only modified and unedited files.
* `ChangeFirefoxUserPreferences.cmd` changes some Firefox user preferences of all users from something to something else, all specified at the top of the script, if Firefox is not currently running.
* `iPhonePhotoFiltererCompiler.cmd` uses `PythonFileCompiler.cmd` to create a .exe of the above Python script to enable users without a Python installation to run it. (**Windows only**)
* `list_files.py` lists all files' unique names in a directory and all it's subdirectories into a text file.
* `PingTest.cmd` tries all combinations of IPs in 192.168.X.X and prints those where an answer is gotten.
* `PythonFileCompiler.cmd` takes 3 arguments, .py file name, .exe file name and path, and creates a .exe file from a Python script file using `pyinstaller`. (`pip install pyinstaller`) (**Windows only**)
* `rename_invoice_pdfs.py` renames PDFs of invoices in a directory according to their content.
* `show_pdf_text.py` shows all text found in a PDF file. Useful e.g. for OCRd PDFs to find problems.
* `show_unique_lines.py` gets all unique lines in a specified text file and outputs them in a new file.
* `SortOutRename.cmd` sorts all files prepended with an "!" in all subdirectories of it's path into "!" subdirs of those dirs and removes the "!" from the file name.
