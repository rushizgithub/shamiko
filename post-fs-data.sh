MODDIR=${0%/*}

if [ "$(magisk -V)" -lt 26000 ]; then
  touch "$MODDIR/disable"
fi
