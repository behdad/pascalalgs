@echo off
:loop
mapgener
if errorlevel 1 goto end
mapfold
maptestr
goto loop
:end