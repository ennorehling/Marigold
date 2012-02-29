LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

LOCAL_MODULE := main

SDL_PATH := ../SDL
LUA_PATH := ../Lua

LOCAL_C_INCLUDES := $(LOCAL_PATH)/test \
	$(LOCAL_PATH)/$(SDL_PATH)/include \
	$(LOCAL_PATH)/$(LUA_PATH)/include

# Add your application source files here...
LOCAL_SRC_FILES := $(SDL_PATH)/src/main/android/SDL_android_main.cpp \
	engine/main.c

LOCAL_SHARED_LIBRARIES := SDL2 Lua

LOCAL_LDLIBS := -lGLESv1_CM -llog

include $(BUILD_SHARED_LIBRARY)
