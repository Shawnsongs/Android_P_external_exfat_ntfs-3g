EXFAT_ROOT := $(call my-dir)
LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

EXFAT_CFLAGS := -Wall -O2 -std=c99 \
                -D__GLIBC__ \
                -D_FILE_OFFSET_BITS=64 \
                -DALWAYS_USE_SYNC_OPTION=1 \
                -DUSE_TRANSITIONAL_LFS=1 \
                -I$(EXFAT_ROOT)/libexfat \
                -I$(EXFAT_ROOT)/../fuse/include\
				-DFUSE_USE_VERSION=26 \
	            -Wno-error=format-security \
	            -Wno-sign-compare \
	            -Wno-unused-parameter \
	            -Wno-pointer-arith \
	            -Wno-address-of-packed-member \
	            -Wno-missing-field-initializers \
	            -Wno-logical-not-parentheses
				
				
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
	
#LOCAL_MODULE := mount.exfat
#LOCAL_SRC_FILES := main.c
#LOCAL_STATIC_LIBRARIES += libexfat_mount libexfat_fsck libexfat_mkfs libexfat_dump libexfat_label
#LOCAL_STATIC_LIBRARIES += libexfat libfuse_static
#include $(BUILD_EXECUTABLE)

LOCAL_MODULE := mount.exfat
LOCAL_SRC_FILES := main.c
LOCAL_STATIC_LIBRARIES += libexfat_mount libexfat_fsck libexfat_mkfs libexfat_dump libexfat_label
LOCAL_STATIC_LIBRARIES += libexfat libfuse
include $(BUILD_EXECUTABLE)

LINKS := fsck.exfat mkfs.exfat
SYMLINKS := $(addprefix $(TARGET_OUT)/bin/,$(LINKS))
$(SYMLINKS): EXFAT_BINARY := $(LOCAL_MODULE)
$(SYMLINKS): $(LOCAL_INSTALLED_MODULE) $(LOCAL_PATH)/Android.mk
	@echo "Symlink: $@ -> $(EXFAT_BINARY)"
	@mkdir -p $(dir $@)
	@rm -rf $@
	$(hide) ln -sf $(EXFAT_BINARY) $@

ALL_DEFAULT_INSTALLED_MODULES += $(SYMLINKS)

include $(EXFAT_ROOT)/libexfat/Android.mk
include $(EXFAT_ROOT)/fuse/Android.mk
include $(EXFAT_ROOT)/mkfs/Android.mk
include $(EXFAT_ROOT)/fsck/Android.mk
include $(EXFAT_ROOT)/dump/Android.mk
include $(EXFAT_ROOT)/label/Android.mk
