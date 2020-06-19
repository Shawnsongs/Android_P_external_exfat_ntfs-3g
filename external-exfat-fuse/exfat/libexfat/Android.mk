LOCAL_PATH := $(call my-dir)
include $(CLEAR_VARS)

LOCAL_MODULE    := libexfat
LOCAL_SRC_FILES := cluster.c io.c log.c lookup.c mount.c node.c time.c utf.c utils.c 

LOCAL_CFLAGS := \
	-D_FILE_OFFSET_BITS=64 \
	-DFUSE_USE_VERSION=26 \
	-Wno-error=format-security \
	-Wno-sign-compare \
	-Wno-unused-parameter \
	-Wno-pointer-arith \
	-Wno-address-of-packed-member \
	-Wno-missing-field-initializers \
	-Wno-logical-not-parentheses
	
LOCAL_CFLAGS := $(EXFAT_CFLAGS)
LOCAL_C_INCLUDES += $(LOCAL_PATH)
include $(BUILD_STATIC_LIBRARY)
