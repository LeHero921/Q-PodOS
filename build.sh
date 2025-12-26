#!/bin/bash
set -e

# --- Pfade ---
PROJECT_ROOT="$(cd "$(dirname "$0")" && pwd)"
BUILDROOT="$PROJECT_ROOT/buildroot"
EXTERNAL="$PROJECT_ROOT/external"

# --- Argumente parsen ---
TARGET="$1"
ACTION="$2" # Optional: "clean" oder leer lassen

if [ -z "$TARGET" ]; then
  echo "Usage: $0 <target> [clean]"
  echo "Targets: x86_64, rpi4"
  exit 1
fi

# --- Config Zuweisung ---
case "$TARGET" in
  x86_64) DEFCONFIG="ipodos_x86_64_defconfig" ;;
  rpi4)   DEFCONFIG="ipodos_rpi4_defconfig" ;;
  *)      echo "Unknown target: $TARGET"; exit 1 ;;
esac

# --- Clean Option (Nur wenn explizit gefordert) ---
if [ "$ACTION" == "clean" ]; then
    echo "==== Cleaning build for $TARGET ===="
    make -C "$BUILDROOT" BR2_EXTERNAL="$EXTERNAL" distclean
    echo "Done. Re-run without 'clean' to build."
    exit 0
fi

# --- Konfiguration anwenden (nur wenn noch nicht konfiguriert) ---
if [ ! -f "$BUILDROOT/output/.config" ]; then
    echo "==== Applying Defconfig ($DEFCONFIG) ===="
    make -C "$BUILDROOT" BR2_EXTERNAL="$EXTERNAL" "$DEFCONFIG"
else
    echo "==== Using existing configuration ===="
    echo "Tip: Run '$0 $TARGET clean' to force a full rebuild."
fi

# --- Build starten ---
echo "==== Starting Build ===="
# Speichert Log, damit du Fehler nachlesen kannst
make -C "$BUILDROOT" BR2_EXTERNAL="$EXTERNAL" -j$(nproc) 2>&1 | tee build.log

echo "==== Build complete for $TARGET ===="
ls -lh "$BUILDROOT/output/images/"
