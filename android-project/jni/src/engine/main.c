#include <SDL.h>
#include <lua.h>
#include <lualib.h>
#include <lauxlib.h>
#include <limits.h>
#include <string.h>

#define MAX_SCRIPT_LENGTH 32768
#define MAX_PATH_LENGTH 64

static int asset_loader(lua_State * L) {
    const char * module = lua_tostring(L, 1);
    char * buffer;
    SDL_RWops * rw;
    char filename[MAX_PATH_LENGTH];

    //SDL_Log("+++++ LOADING %s +++++", module);
    strcat(strcpy(filename, module), ".lua");
    rw = SDL_RWFromFile(filename, "rb");
    if (rw) {
        //SDL_Log("+++++ OPENED %s +++++", filename);
        void * buffer;
        size_t sz, rd;
        SDL_RWseek(rw, 0, RW_SEEK_END);
        sz = SDL_RWtell(rw);
        //SDL_Log("+++++ LOADING %u bytes from %s +++++", sz, filename);
        buffer = malloc(sz);
        SDL_RWseek(rw, 0, RW_SEEK_SET);
        rd = SDL_RWread(rw, buffer, 1, sz);
        //SDL_Log("+++++ LOADED %u bytes from %s +++++", rd, filename);
        if (rd>0) {
            luaL_loadbuffer(L, (const char *)buffer, sz, filename);
            //SDL_Log("+++++ PARSED %u bytes from %s +++++", sz, filename);
        }
        SDL_FreeRW(rw);
        free(buffer);
    } else {
        char error[MAX_PATH_LENGTH+32];
        strcat(strcpy(error, "could not load "), filename);
        lua_pushstring(L, error);
    }
    return 1;
}

static const char * getFilesDir(void) {
    // TODO: implement me
    return "";
}

static const struct {
  const char *name;
  int (*func) (lua_State *);
} lualibs[] = {
  {
  "", luaopen_base}, {
  LUA_TABLIBNAME, luaopen_table}, {
  LUA_IOLIBNAME, luaopen_io}, {
  LUA_STRLIBNAME, luaopen_string}, {
  LUA_MATHLIBNAME, luaopen_math}, {
  LUA_LOADLIBNAME, luaopen_package}, {
  LUA_DBLIBNAME, luaopen_debug},
#if LUA_VERSION_NUM>=501
  {
  LUA_OSLIBNAME, luaopen_os},
#endif
  {
  NULL, NULL}
};

static void load_libraries(lua_State * L) {
  int i;
  for (i = 0; lualibs[i].func; ++i) {
    lua_pushcfunction(L, lualibs[i].func);
    lua_pushstring(L, lualibs[i].name);
    lua_call(L, 1, 0);
  }
}

static void register_loader(lua_State * L, const char * files_dir) {
    char custom_path[PATH_MAX+1];

    lua_getglobal(L, "package");
    lua_getfield(L, -1, "loaders");
    int num_loaders = lua_objlen(L, -1);
    lua_pushcfunction(L, asset_loader);
    lua_rawseti(L, -2, 2);
    lua_pop(L, 1);

    lua_getfield(L, -1, "path");
    custom_path[0] = ';';
    strcpy(custom_path+1, files_dir);
    strcat(custom_path, "/?.lua");
    lua_pushstring(L, custom_path);
    lua_concat(L, 2);
    lua_setfield(L, -2, "path");
    lua_pop(L, 1);
}


extern int tolua_SDL_wr_open(lua_State*);
extern int tolua_SDL_surface_wr_open(lua_State*);
extern int tolua_SDL_render_wr_open(lua_State*);
extern int tolua_SDL_video_wr_open(lua_State*);
extern int tolua_SDL_timer_wr_open(lua_State*);
extern int tolua_SDL_keyboard_wr_open(lua_State*);
extern int tolua_SDL_event_wr_open(lua_State*);
extern int tolua_SDL_audio_wr_open(lua_State*);

int DECLSPEC luaopen_LuaSDL2 (lua_State* L) {
    tolua_SDL_wr_open(L);
    tolua_SDL_surface_wr_open(L);
    tolua_SDL_render_wr_open(L);
    tolua_SDL_video_wr_open(L);
    tolua_SDL_timer_wr_open(L);
    tolua_SDL_keyboard_wr_open(L);
    tolua_SDL_event_wr_open(L);
    tolua_SDL_audio_wr_open(L);
    return 0;
};

int SDL_main(int argc, char * argv[]) {
    int a = 23, ret;
    lua_State * L = lua_open();
    const char * script = "main.lua";

    //SDL_Log("+++++ COMPILED ON %s AT %s +++++", __DATE__, __TIME__);
    load_libraries(L);
    luaopen_LuaSDL2(L);
    //SDL_Log("+++++ LOAD LIBRARIES OK +++++");
    register_loader(L, getFilesDir());
    //SDL_Log("+++++ LOADER REGISTERED +++++");

    lua_pushinteger(L, 42);
    lua_setglobal(L, "a");

    // luaL_loadstring(L, "a=42");
    luaL_loadstring(L, "require('main')");
    ret = lua_pcall(L, 0, LUA_MULTRET, 0);
    SDL_Log("+++++ main pcall returned %d +++++", ret);
    if (ret) {
        const char * err = lua_tostring(L, -1);
        SDL_Log("+++++ ERROR %s", err);
    }

    lua_close(L);
    return 0;
}
