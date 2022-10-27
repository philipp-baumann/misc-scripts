Custom bash scripts for manipulating vector and raster files
================

# Overview

You can clone this repository to download all files keeping up to date
with this repository:

``` {bash}
# change to desired directory in shell where you want to clone
git clone https://github.com/philipp-baumann/vector-and-image-cli-commands.git
# pull newest updates if there were changes
git pull
```

# Transformation of vector formats

## Custom ghostscript (gs) routines

More infos about ghostscript can be found on the [official
page](https://www.ghostscript.com/).

### Resize PDFs

-   [`resize_pdf`](scripts/resize_pdf.sh) is a simple shell script that
    performs resizing from an input format (e.g., A4) to a desired
    output format (e.g., A5).

To make it available on your Linux/MacOS device, you might first have to
install the ghostscript (gs) command line program.

``` {bash}
# check if it is installed
gs --version
# e.g. on Ubuntu/Debian
sudo apt install ghostscript
# for other platforms, follow https://ghostscript.com/docs/9.54.0/Install.htm
```

``` {bash}
# make the file executable
chmod +x ./scripts/resize_pdf.sh
# copy it to make it available on any folder in your shell
sudo cp  ./scripts/resize_pdf.sh /usr/local/bin/resize_pdf
```

The syntax of the script is:

``` {bash}
# change to folder with desired pdfwrite
# it has the following command syntax
resize_pdf <your-file.pdf> <format-tag-from> <format-tag-to>
# e.g.
resize_pdf example.pdf a4 a5
```

# PDFtk routines

## Combine multiple files

First install it.

``` {bash}
# e.g. on ubuntu
sudo apt install pdftk
```

Merge multiple PDF files into one.

``` {bash}
pdftk file1.pdf file2.pdf file3.pdf cat output newfile.pdf
# in a directory
pdftk *.pdf cat output newfile.pdf
```
