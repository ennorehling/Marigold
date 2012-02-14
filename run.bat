@ECHO OFF
SET LUA_CPATH=Debug\?.dll
SET LUA_PATH=?\init.lua;?.lua
lua simplebreak.lua
