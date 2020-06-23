# Android_P_external_exfat_ntfs
Support ntfs and exfat formats on android 9.0

Software Version: Android 9.0
Platform: Freescale IMX8

exfat-nofuse
============

Linux non-fuse read/write kernel driver for the exFAT, FAT12, FAT16 and vfat (FAT32) file systems.<br />
Originally ported from Android kernel v3.0.


    1、put  kernel-no-fuse\exfat  in  vendor/nxp-opensource/kernel_imx/fs/
    2、modify some config file 
    3、make dtboimage;make bootimage;
    4、burn it we can see exfat in proc/filesystems



modify some config files in kernel_imx/fs:
====================================

```
diff --git a/vendor/nxp-opensource/kernel_imx/arch/arm64/configs/android_f202_p_car_defconfig b/vendor/nxp-opensource/kernel_imx/arch/arm64/configs/android_f202_p_car_defconfig
index 0841989..28523fe 100755
--- a/vendor/nxp-opensource/kernel_imx/arch/arm64/configs/android_f202_p_car_defconfig
+++ b/vendor/nxp-opensource/kernel_imx/arch/arm64/configs/android_f202_p_car_defconfig
@@ -512,6 +512,9 @@ CONFIG_FUSE_FS=y
 CONFIG_CUSE=y
 CONFIG_OVERLAY_FS=y
 CONFIG_VFAT_FS=y
+CONFIG_EXFAT_FS=y
+CONFIG_EXFAT_DEFAULT_CODEPAGE=437
+CONFIG_EXFAT_DEFAULT_IOCHARSET="utf8"
 CONFIG_TMPFS_POSIX_ACL=y
 CONFIG_HUGETLBFS=y
 CONFIG_SDCARD_FS=y
diff --git a/vendor/nxp-opensource/kernel_imx/fs/Kconfig b/vendor/nxp-opensource/kernel_imx/fs/Kconfig
old mode 100644
new mode 100755
index 121fabf..75002af
--- a/vendor/nxp-opensource/kernel_imx/fs/Kconfig
+++ b/vendor/nxp-opensource/kernel_imx/fs/Kconfig
@@ -126,6 +126,7 @@ menu "DOS/FAT/NT Filesystems"
 
 source "fs/fat/Kconfig"
 source "fs/ntfs/Kconfig"
+source "fs/exfat/Kconfig"
 
 endmenu
 endif # BLOCK
diff --git a/vendor/nxp-opensource/kernel_imx/fs/Makefile b/vendor/nxp-opensource/kernel_imx/fs/Makefile
old mode 100644
new mode 100755
index 1e34e4b..254cb71
--- a/vendor/nxp-opensource/kernel_imx/fs/Makefile
+++ b/vendor/nxp-opensource/kernel_imx/fs/Makefile
@@ -79,6 +79,7 @@ obj-$(CONFIG_HUGETLBFS)		+= hugetlbfs/
 obj-$(CONFIG_CODA_FS)		+= coda/
 obj-$(CONFIG_MINIX_FS)		+= minix/
 obj-$(CONFIG_FAT_FS)		+= fat/
+obj-$(CONFIG_EXFAT_FS)          += exfat/
 obj-$(CONFIG_BFS_FS)		+= bfs/
 obj-$(CONFIG_ISO9660_FS)	+= isofs/
 obj-$(CONFIG_HFSPLUS_FS)	+= hfsplus/ # Before hfs to find wrapped HFS+
```



make dtboimage and bootimage then burn it:
======================================

we can see exfat in proc/filesystems

	cat proc/filesystems 
	we can see exfat in it,so we make it successful 


put external-exfat-fuse\exfat  and external-exfat-fuse\fuse in external :
=================================


First, make -j128:

	it may have many errors,we can add LOCAL_CFLAGS to fix it

```
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
```
Then,if build successfully,we can see: 

```
   out/***/system/bin/mount.exfat
   out/***/system/bin/mkfs.exfat
   out/***/system/bin/mkfs.exfat
```

There is no need modify vold,we can see it already have system/vold/fs/Exfat.cpp in Android 9.0:

Finally,if you test in Exfat udisk,it works very well,enjoy it brother.



Happy EveryDay!
=================================

My CSDN BLOG LINK:
Android 9.0 支持NTFS和Exfat 格式U盘开发

https://blog.csdn.net/An_Times/article/details/106858104
