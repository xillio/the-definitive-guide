@echo off

rem PROPERTIES
set OUTPUT_TITLE=Xill Plugins - The Definitive Guide
set BUILD_DIR=build/

rem COLLECT ALL CHAPTERS
set INPUT_FILES=title.txt ^
01-getting-started/00-chapter1.md ^
02-developing-constructs/00-chapter2.md ^
03-advanced-topics/00-chapter3.md

rem CREATE BUILD FOLDER IF IT DOESN'T EXIST
if not exist "%BUILD_DIR%" mkdir "%BUILD_DIR%"

rem LOOP AND GENERATE ALL OUTPUT FORMATS
echo Generating Documents...
for %%e in (pdf, epub, html, docx) do call :Generate %%e
goto End

:Generate
rem THIS FUNCTION WILL GENERATE A DOCUMENT GIVEN THE EXTENSION
set OUTPUT_FILE=%OUTPUT_TITLE%.%1
set LOG_FILE=%LOG_DIR%%1.log
set ERROR_LOG_FILE=%LOG_DIR%%1.error.log
echo Building %OUTPUT_FILE%...
pandoc -S -s --toc -o "%BUILD_DIR%%OUTPUT_FILE%" %INPUT_FILES%
goto :eof

:End
echo Build Done!