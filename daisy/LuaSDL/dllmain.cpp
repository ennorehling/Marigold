// dllmain.cpp : Defines the entry point for the DLL application.
#include "stdafx.h"
#include <lua.h>

extern "C" {
    int tolua_SDL_wr_open(lua_State*);
    int tolua_SDL_video_wr_open(lua_State*);
    int tolua_SDL_timer_wr_open(lua_State*);
    int tolua_SDL_keyboard_wr_open(lua_State*);
    int tolua_SDL_event_wr_open(lua_State*);
    int __declspec(dllexport) luaopen_LuaSDL (lua_State* L) {
        tolua_SDL_wr_open(L);
        tolua_SDL_video_wr_open(L);
        tolua_SDL_timer_wr_open(L);
        tolua_SDL_keyboard_wr_open(L);
        tolua_SDL_event_wr_open(L);
        return 0;
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

