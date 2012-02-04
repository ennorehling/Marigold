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

struct userdata {
    SDL_Surface * screen;
    SDL_sem * sem_fps;
};

static int daisy_Init (lua_State *L) {
  int result = SDL_Init(SDL_INIT_EVERYTHING);
  atexit(SDL_Quit);
  if (result!=0) {
      return 0;
  }
  userdata * udata = (userdata *)lua_newuserdata(L, sizeof(userdata));
  memset(udata, 0, sizeof(udata));
  return 1;
}

static Uint32 fps_timer(Uint32 interval, void *param)
{
    SDL_sem * sem = (SDL_sem *)param;
    SDL_SemPost(sem);
    return interval;
}

static int daisy_SetFrameDelay(lua_State * L)
{
    userdata * udata = (userdata *)lua_touserdata(L, 1);
    Uint32 interval = (Uint32)luaL_checkinteger(L, 2);
    SDL_NewTimerCallback callback = fps_timer;
    udata->sem_fps = SDL_CreateSemaphore(0);
    SDL_TimerID * result = (SDL_TimerID *)lua_newuserdata(L, sizeof(SDL_TimerID));
    *result = SDL_AddTimer(interval, callback, udata->sem_fps);
    return 1;
}

static int daisy_WM_SetCaption (lua_State *L) {
  const char * title = luaL_checkstring(L, 1);
  SDL_WM_SetCaption(title, title);
  return 0;
}

static int daisy_SetVideoMode (lua_State *L) {
    userdata * udata = (userdata *)lua_touserdata(L, 1);
    int width = (int)luaL_checknumber(L, 2);
    int height = (int)luaL_checknumber(L, 3);
    int depth = (int)luaL_checknumber(L, 4);
    int flags = SDL_HWSURFACE;

    /* Initialize the screen / window */
 
    udata->screen = SDL_SetVideoMode(width, height, depth, flags);
    return 0;
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
    userdata * udata = (userdata *)lua_touserdata(L, 1); 
    SDL_Rect rect;
    rect.x = (Sint16)luaL_checknumber(L, 2);
    rect.y = (Sint16)luaL_checknumber(L, 3);
    rect.w = (Sint16)luaL_checknumber(L, 4);
    rect.h = (Sint16)luaL_checknumber(L, 5);
    int color = (int)luaL_checknumber(L, 6);
    Uint32 rgb = SDL_MapRGB(udata->screen->format, (color>>16)&0xFF, (color>>8)&0xFF, color&0xFF);
    SDL_FillRect(udata->screen, &rect, rgb);
    return 0;
}

static int daisy_Flip(lua_State * L)
{
    userdata * udata = (userdata *)lua_touserdata(L, 1); 
    if (udata->sem_fps) {
        SDL_SemWait(udata->sem_fps);
    }
    SDL_Flip(udata->screen);
    return 0;
}

static int daisy_CreateSemaphore(lua_State * L)
{
    Uint32 value = (Uint32)lua_tonumber(L, 1);
    SDL_sem ** sem = (SDL_sem **)lua_newuserdata(L, sizeof(SDL_sem *));
    *sem = SDL_CreateSemaphore(value);
    return 1;
}

static int daisy_DestroySemaphore(lua_State * L)
{
    SDL_sem ** semp = (SDL_sem **)lua_touserdata(L, 1);
    SDL_DestroySemaphore(*semp);
    return 0;
}

static int daisy_SemWait(lua_State * L)
{
    SDL_sem ** semp = (SDL_sem **)lua_touserdata(L, 1);
    int result = SDL_SemWait(*semp);
    lua_pushinteger(L, result);
    return 1;
}

static int daisy_SemTryWait(lua_State * L)
{
    SDL_sem ** semp = (SDL_sem **)lua_touserdata(L, 1);
    int result = SDL_SemTryWait(*semp);
    lua_pushinteger(L, result);
    return 1;
}

static int daisy_SemPost(lua_State * L)
{
    SDL_sem ** semp = (SDL_sem **)lua_touserdata(L, 1);
    int result = SDL_SemPost(*semp);
    lua_pushinteger(L, result);
    return 1;
}

int LUA_API luaopen_daisy (lua_State *L) {
  struct luaL_reg driver[] = {
    {"Init", daisy_Init},
    {"SetVideoMode", daisy_SetVideoMode},
    {"WM_SetCaption", daisy_WM_SetCaption},
    {"WaitEvent", daisy_WaitEvent},
    {"PollEvent", daisy_PollEvent},
    {"GetTicks", daisy_GetTicks},
    {"FillRect", daisy_FillRect},
    {"Flip", daisy_Flip},
    {"SetFrameDelay", daisy_SetFrameDelay },

    {"CreateSemaphore", daisy_CreateSemaphore},
    {"DestroySemaphore", daisy_DestroySemaphore},
    {"SemWait", daisy_SemWait},
    {"SemTryWait", daisy_SemTryWait},
    {"SemPost", daisy_SemPost},

    {NULL, NULL},
  };
  luaL_openlib (L, PROJECT_TABLENAME, driver, 0);
  return 1;
}
