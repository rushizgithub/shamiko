# shellcheck disable=SC2034
SKIPUNZIP=1

enforce_install_from_app() {
  if $BOOTMODE; then
    ui_print "- Installing from Magisk / KernelSU app"
  else
    ui_print "*********************************************************"
    ui_print "! Install from recovery is NOT supported"
    ui_print "! Recovery sucks"
    ui_print "! Please install from Magisk / KernelSU app"
    abort "*********************************************************"
  fi
}

check_magisk_version() {
  ui_print "- Magisk version: $MAGISK_VER_CODE"
  if [ "$MAGISK_VER_CODE" -lt 26000 ]; then
    ui_print "*********************************************************"
    ui_print "! Please install Magisk v26.0+ (26000+)"
    abort    "*********************************************************"
  fi
}

check_ksu_version() {
  ui_print "- KernelSU version: $KSU_KERNEL_VER_CODE (kernel) + $KSU_VER_CODE (ksud)"
  if ! [ "$KSU_KERNEL_VER_CODE" ] || [ "$KSU_KERNEL_VER_CODE" -lt 10940 ]; then
    ui_print "*********************************************************"
    ui_print "! KernelSU version is too old!"
    ui_print "! Please update KernelSU to latest version"
    abort    "*********************************************************"
  elif [ "$KSU_KERNEL_VER_CODE" -ge 20000 ]; then
    ui_print "*********************************************************"
    ui_print "! KernelSU version abnormal!"
    ui_print "! Please integrate KernelSU into your kernel"
    ui_print "  as submodule instead of copying the source code"
    abort    "*********************************************************"
  fi
  if ! [ "$KSU_VER_CODE" ] || [ "$KSU_VER_CODE" -lt 10942 ]; then
    ui_print "*********************************************************"
    ui_print "! ksud version is too old!"
    ui_print "! Please update KernelSU Manager to latest version"
    abort    "*********************************************************"
  fi
}

check_zygisksu_version() {
  ZYGISKSU_VERSION=$(cat /data/adb/modules/zygisksu/module.prop | grep versionCode | sed 's/versionCode=//g')
  ui_print "- Zygisksu version: $ZYGISKSU_VERSION"
  if ! [ "$ZYGISKSU_VERSION" ] || [ "$ZYGISKSU_VERSION" -lt 85 ]; then
    ui_print "*********************************************************"
    ui_print "! Zygisksu version is too old!"
    ui_print "! Please update Zygisksu to latest version"
    abort    "*********************************************************"
  fi
}

VERSION=$(grep_prop version "${TMPDIR}/module.prop")
ui_print "- Shamiko version ${VERSION}"

# Extract verify.sh
ui_print "- Extracting verify.sh"
unzip -o "$ZIPFILE" 'verify.sh' -d "$TMPDIR" >&2
if [ ! -f "$TMPDIR/verify.sh" ]; then
  ui_print "*********************************************************"
  ui_print "! Unable to extract verify.sh!"
  ui_print "! This zip may be corrupted, please try downloading again"
  abort    "*********************************************************"
fi
. "$TMPDIR/verify.sh"

extract "$ZIPFILE" 'customize.sh' "$TMPDIR"
extract "$ZIPFILE" 'verify.sh' "$TMPDIR"

enforce_install_from_app
if [ "$KSU" ]; then
  check_ksu_version
  check_zygisksu_version
else
  check_magisk_version
fi

# Check architecture
if [ "$ARCH" != "arm" ] && [ "$ARCH" != "arm64" ] && [ "$ARCH" != "x86" ] && [ "$ARCH" != "x64" ]; then
  abort "! Unsupported platform: $ARCH"
else
  ui_print "- Device platform: $ARCH"
fi

if [ "$API" -lt 27 ]; then
  abort "! Only support Android 8.1+ devices"
fi

extract "$ZIPFILE" 'checksum'           "$MODPATH"
extract "$ZIPFILE" 'module.prop'        "$MODPATH"
extract "$ZIPFILE" 'sepolicy.rule'      "$MODPATH"
extract "$ZIPFILE" 'post-fs-data.sh'    "$MODPATH"
extract "$ZIPFILE" 'service.sh'         "$MODPATH"
extract "$ZIPFILE" 'uninstall.sh'       "$MODPATH"

ui_print "- Extracting zygisk libraries"
if [ "$ARCH" = "arm" ] || [ "$ARCH" = "arm64" ] ; then
  extract "$ZIPFILE" 'zygisk/armeabi-v7a.so' "$MODPATH" false
  if [ "$IS64BIT" = true ]; then
    extract "$ZIPFILE" 'zygisk/arm64-v8a.so' "$MODPATH" false
  fi
elif [ "$ARCH" = "x86" ] || [ "$ARCH" = "x64" ]; then
  extract "$ZIPFILE" 'zygisk/x86.so' "$MODPATH" false
  if [ "$IS64BIT" = true ]; then
    extract "$ZIPFILE" 'zygisk/x86_64.so' "$MODPATH" false
  fi
fi


set_perm_recursive "$MODPATH" 0 0 0755 0644

ui_print "- これで勝ったと思うなよ―――!!"
