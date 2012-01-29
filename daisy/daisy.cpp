// daisy.cpp  ->  daisy.dll (msvc6 : dll example project, select c++:codegen:"multithreaded dll" and add luabin include&lib paths)

#include "stdafx.h"
#include <stdio.h>
extern "C" {
  #include "lua.h"
  #include "lauxlib.h"
}
#include <SDL.h>
#define PROJECT_TABLENAME "daisy"
#undef LUA_API
#ifdef WIN32
#define LUA_API __declspec(dllexport)
#else
#define LUA_API
#endif

extern "C" {
  int LUA_API luaopen_daisy (lua_State *L);
}

static int daisy_WM_SetCaption (lua_State *L) {
  const char * title = luaL_checkstring(L, 1);
  SDL_WM_SetCaption(title, title);
  return 0;
}

static int daisy_Init (lua_State *L) {
  SDL_Surface *screen;

  int width = (int)luaL_checknumber(L, 1);
  int height = (int)luaL_checknumber(L, 2);
  int depth = (int)luaL_checknumber(L, 3);
  int flags = SDL_HWSURFACE;
     
  /* Initialize SDL */
  SDL_Init(SDL_INIT_VIDEO);
  atexit(SDL_Quit);
     
  /* Initialize the screen / window */
  screen = SDL_SetVideoMode(width, height, depth, flags);
  SDL_Surface ** data = (SDL_Surface **)lua_newuserdata(L, sizeof(SDL_Surface *));
  *data = screen;
  return 1;
}

static int PushEvent(lua_State * L, SDL_Event * event) {
	lua_pushnumber(L, (lua_Number)event->type);
	switch (event->type) {
	case SDL_KEYUP:
	case SDL_KEYDOWN: {
		SDL_KeyboardEvent * e = (SDL_KeyboardEvent *)event;
		lua_createtable(L, 0, 5);
		lua_pushstring(L, "which");
		lua_pushnumber(L, e->which);
		lua_rawset(L, -3);
		lua_pushstring(L, "scancode");
		lua_pushnumber(L, e->keysym.scancode);
		lua_rawset(L, -3);
		lua_pushstring(L, "mod");
		lua_pushnumber(L, e->keysym.mod);
		lua_rawset(L, -3);
		lua_pushstring(L, "sym");
		lua_pushnumber(L, e->keysym.sym);
		lua_rawset(L, -3);
		lua_pushstring(L, "unicode");
		lua_pushnumber(L, e->keysym.unicode);
		lua_rawset(L, -3);
		break;
	}
	case SDL_QUIT:
		return 1;
	default:
		lua_newtable(L);
	}
	return 2;
}

static int daisy_WaitEvent(lua_State * L)
{
    SDL_Event event;

    if (SDL_WaitEvent(&event)) {
		return PushEvent(L, &event);
	}
    return 0;
}

static int daisy_PollEvent(lua_State * L)
{
    SDL_Event event;

    if (SDL_PollEvent(&event)) {
		return PushEvent(L, &event);
	}
	return 0;
}

static int daisy_GetTicks(lua_State * L)
{
    Uint32 ticks = SDL_GetTicks();
	lua_pushnumber(L, (lua_Number)ticks);
	return 1;
}

static int daisy_FillRect(lua_State * L)
{
	SDL_Surface ** data = (SDL_Surface **)lua_touserdata(L, 1); 
	SDL_Surface * screen = *data;
	SDL_Rect rect;
	rect.x = (Sint16)luaL_checknumber(L, 2);
	rect.y = (Sint16)luaL_checknumber(L, 3);
	rect.w = (Sint16)luaL_checknumber(L, 4);
	rect.h = (Sint16)luaL_checknumber(L, 5);
	int color = (int)luaL_checknumber(L, 6);
	Uint32 rgb = SDL_MapRGB(screen->format, (color>>16)&0xFF, (color>>8)&0xFF, color&0xFF);
	SDL_FillRect(screen, &rect, rgb);
	return 0;
}

static int daisy_Flip(lua_State * L)
{
	SDL_Surface ** data = (SDL_Surface **)lua_touserdata(L, 1); 
	SDL_Surface * screen = *data;
    SDL_Flip(screen);
	return 0;
}

int LUA_API luaopen_daisy (lua_State *L) {
  struct luaL_reg driver[] = {
    {"Init", daisy_Init},
    {"WM_SetCaption", daisy_WM_SetCaption},
    {"WaitEvent", daisy_WaitEvent},
    {"PollEvent", daisy_PollEvent},
    {"GetTicks", daisy_GetTicks},
    {"FillRect", daisy_FillRect},
    {"Flip", daisy_Flip},
    {NULL, NULL},
  };
  luaL_openlib (L, PROJECT_TABLENAME, driver, 0);
  return 1;
}
