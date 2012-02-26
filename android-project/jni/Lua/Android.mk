LOCAL_PATH := $(call my-dir)

###########################
#
# Lua shared library
#
###########################

include $(CLEAR_VARS)

LOCAL_MODULE := Lua

LOCAL_C_INCLUDES := $(LOCAL_PATH)/include

LOCAL_SRC_FILES := \
	$(subst $(LOCAL_PATH)/,, \
	$(wildcard $(LOCAL_PATH)/src/*.c))

LOCAL_LDLIBS := -ldl -lm

include $(BUILD_SHARED_LIBRARY)
