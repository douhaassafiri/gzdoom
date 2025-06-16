@echo off
REM Launch GZDoom with your DOOM II WAD

set GZDOOM_EXE="C:\Users\douha\Documents\GitHub\gzdoom\cmake-build-debug-visual-studio\gzdoom.exe"
set IWAD_PATH="C:\Program Files (x86)\Steam\steamapps\common\Ultimate Doom\base\doom2\DOOM2.WAD"

echo Running GZDoom with DOOM II...
%GZDOOM_EXE% -iwad %IWAD_PATH%
pause