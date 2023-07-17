MODDIR=${0%/*}

if [ "$(magisk -V)" -lt 26000 ] || [ "$(/data/adb/ksud -V)" -lt 10818 ]; then
  touch "$MODDIR/disable"
fi
