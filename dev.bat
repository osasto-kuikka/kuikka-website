@ECHO OFF

set filepath="C:\Program Files (x86)\Microsoft Visual C++ Build Tools\vcbuildtools.bat"

if exist %filepath% (
  %filepath% amd64
) else (
  echo "Missing Visual studio cpp build tools. Check readme how to install it"
)
