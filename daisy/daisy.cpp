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

static int daisy_setWindowTitle (lua_State *L) {
  const char * title = luaL_checkstring(L, 1);
  SDL_WM_SetCaption(title, title);
  return 0;
}

static int daisy_init (lua_State *L) {
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
  lua_pushlightuserdata(L, screen);
  return 1;
}

static int daisy_pump(lua_State * L)
{
    SDL_Event event;

    SDL_WaitEvent(&event);

    switch (event.type) {
        case SDL_KEYDOWN:
            printf("The %s key was pressed!\n",
                   SDL_GetKeyName(event.key.keysym.sym));
            break;
        case SDL_QUIT:
            exit(0);
    }
    return 0;
}

int LUA_API luaopen_daisy (lua_State *L) {
  struct luaL_reg driver[] = {
    {"init", daisy_init},
    {"setWindowTitle", daisy_setWindowTitle},
    {NULL, NULL},
  };
  luaL_openlib (L, PROJECT_TABLENAME, driver, 0);
  return 1;
}
