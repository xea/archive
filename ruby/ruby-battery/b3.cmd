@ECHO OFF
SET PATH=..\..\app-portable\ruby\1.9.1\bin
IF NOT EXIST ..\..\app-portable\ruby\1.9.1\bin EXIT
START ruby -w b3.rb
