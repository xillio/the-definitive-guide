@echo off

set OUTPUT_TITLE=Xill Plugins - The Definitive Guide
set BUILD_DIR=build/
set LOG_DIR=build/logs/

set INPUT_FILES=title.txt ^
01-getting-started/00-chapter1.md ^
02-developing-constructs/00-chapter2.md

set PDF_OUTPUT=%BUILD_DIR%%OUTPUT_TITLE%.pdf
set EPUB_OUTPUT=%BUILD_DIR%%OUTPUT_TITLE%.epub
set HTML_OUTPUT=%BUILD_DIR%%OUTPUT_TITLE%.html

echo CREATING FOLDERS...
if not exist "%BUILD_DIR%" mkdir "%BUILD_DIR%"
if not exist "%LOG_DIR%" mkdir "%LOG_DIR%"

echo BUILDING PDF...
pandoc -S -o "%PDF_OUTPUT%" %INPUT_FILES% > %LOG_DIR%pdf.log 2> %LOG_DIR%pdf.error.log


echo BUILDING EPUB...
pandoc -S -o "%EPUB_OUTPUT%" %INPUT_FILES% > %LOG_DIR%epub.log 2> %LOG_DIR%epub.error.log

echo BUILDING HTML...
pandoc -S -s --toc -o "%HTML_OUTPUT%" %INPUT_FILES% > %LOG_DIR%html.log 2> %LOG_DIR%html.error.log