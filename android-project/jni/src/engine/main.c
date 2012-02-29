#include <SDL.h>
#include <lua.h>
#include <lualib.h>
#include <lauxlib.h>
#include <limits.h>
#include <string.h>

static int asset_loader(lua_State * L) {
    SDL_Log("+++++ DEBUG %s:%d +++++", __FILE__, __LINE__);
    const char * filename = lua_tostring(L, 1);
    SDL_Log("asset_loader: %s", filename);
    return 0;
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

int SDL_main(int argc, char * argv[]) {
    int a = 23, ret;
    lua_State * L = lua_open();
    const char * script = "main.lua";

    SDL_Log("+++++ COMPILED ON %s AT %s +++++", __DATE__, __TIME__);
    load_libraries(L);
    SDL_Log("+++++ LOAD LIBRARIES OK +++++");
    register_loader(L, getFilesDir());
    SDL_Log("+++++ LOADER REGISTERED +++++");

    lua_pushinteger(L, 42);
    lua_setglobal(L, "a");

    // luaL_loadstring(L, "a=42");
    luaL_loadstring(L, "require('main')");
    ret = lua_pcall(L, 0, LUA_MULTRET, 0);
    SDL_Log("+++++ RETURN %d +++++", ret);
    if (ret) {
        const char * err = lua_tostring(L, -1);
        SDL_Log("+++++ ERROR %s", err);
    }
//    luaL_dofile(L, script);

    SDL_Log("+++++ DEBUG %s:%d +++++", __FUNCTION__, __LINE__);
    lua_getglobal(L, "a");
    SDL_Log("+++++ DEBUG %s:%d +++++", __FUNCTION__, __LINE__);
    a = lua_tointeger(L, 1);
    SDL_Log("+++++ DEBUG %s:%d +++++", __FUNCTION__, __LINE__);
    lua_close(L);
    SDL_Log("+++++ THE ULTIMATE ANSWER IS %d +++++", a);
    SDL_Quit();
    return 0;
}
