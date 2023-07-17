# shellcheck disable=SC2034
SKIPUNZIP=1

enforce_install_from_magisk_app() {
  if $BOOTMODE; then
    ui_print "- Installing from Magisk app"
  else
    ui_print "*********************************************************"
    ui_print "! Install from recovery is NOT supported"
    ui_print "! Recovery sucks"
    ui_print "! Please install from Magisk app"
    abort "*********************************************************"
  fi
}

check_magisk_version() {
  ui_print "- Magisk version: $MAGISK_VER_CODE"
  if [ "$MAGISK_VER_CODE" -lt 24200 ]; then
    ui_print "*********************************************************"
    ui_print "! Please install Magisk v24.2+ (24200+)"
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

check_magisk_version
enforce_install_from_magisk_app

# Check architecture
if [ "$ARCH" != "arm" ] && [ "$ARCH" != "arm64" ] && [ "$ARCH" != "x86" ] && [ "$ARCH" != "x64" ]; then
  abort "! Unsupported platform: $ARCH"
else
  ui_print "- Device platform: $ARCH"
fi

if [ "$API" -lt 27 ]; then
  abort "! Only support SDK 27+ devices"
fi

extract "$ZIPFILE" 'checksum'           "$MODPATH"
extract "$ZIPFILE" 'module.prop'        "$MODPATH"
extract "$ZIPFILE" 'sepolicy.rule'      "$MODPATH"
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
