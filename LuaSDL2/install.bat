@ECHO OFF
IF "%1%"=="" GOTO FAIL
copy ..\%1%\LuaSDL2.dll .
GOTO FINISH
:FAIL
echo "arguments: install.bat {Debug|Release}"
:FINISH
SET LUA_PATH=?\init.lua;?.lua
