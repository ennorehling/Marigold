LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

LOCAL_MODULE := main

SDL_PATH := ../SDL
LUA_PATH := ../Lua
MARIGOLD_PATH := ../../..

LOCAL_C_INCLUDES := $(LOCAL_PATH)/test \
	$(LOCAL_PATH)/$(SDL_PATH)/include \
	$(LOCAL_PATH)/$(LUA_PATH)/include

# Add your application source files here...
LOCAL_SRC_FILES := $(SDL_PATH)/src/main/android/SDL_android_main.cpp \
	$(subst $(LOCAL_PATH)/,, $(wildcard $(LOCAL_PATH)/../../../LuaSDL2/SDL_*_wr.c)) \
	$(subst $(LOCAL_PATH)/,, $(wildcard $(LOCAL_PATH)/../../../LuaSDL2/*_helper.c)) \
	engine/main.c 

LOCAL_SHARED_LIBRARIES := SDL2 Lua

LOCAL_LDLIBS := -lGLESv1_CM -llog

include $(BUILD_SHARED_LIBRARY)
