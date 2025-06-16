@echo off
set GZDOOM_PATH="C:\Users\douha\Documents\GitHub\gzdoom\cmake-build-debug-visual-studio\gzdoom.exe"
set IWAD_PATH="C:\Program Files (x86)\Steam\steamapps\common\Ultimate Doom\base\doom2\DOOM2.WAD"
set MOD_PATH="C:\Users\douha\Documents\GitHub\gzdoom\mods\AIShowcase"
set MAP_WAD="C:\Users\douha\Documents\GitHub\gzdoom\mods\AIShowcase\maps\DEMOMAP.wad"

%GZDOOM_PATH% -iwad %IWAD_PATH% -file %MOD_PATH% %MAP_WAD% +map DEMOMAP
pause
