// dllmain.cpp : Defines the entry point for the DLL application.
#include "stdafx.h"
#include <lua.h>

extern "C" {
    int tolua_sdl_open(lua_State*);
    int __declspec(dllexport) luaopen_LuaSDL (lua_State* L) {
        return tolua_sdl_open(L);
    };

}

BOOL APIENTRY DllMain( HMODULE hModule,
                       DWORD  ul_reason_for_call,
                       LPVOID lpReserved
					 )
{
	switch (ul_reason_for_call)
	{
	case DLL_PROCESS_ATTACH:
	case DLL_THREAD_ATTACH:
	case DLL_THREAD_DETACH:
	case DLL_PROCESS_DETACH:
		break;
	}
	return TRUE;
}

