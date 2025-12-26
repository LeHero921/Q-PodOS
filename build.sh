#!/bin/bash
# -------------------------------
# iPodOS Build Script
# -------------------------------
# Erstellt die Images für x86_64 oder Raspberry Pi
# Bereinigt alte Build-Artefakte automatisch
# -------------------------------

set -e  # Stop bei Fehler

# --- Pfade ---
PROJECT_ROOT="$(cd "$(dirname "$0")" && pwd)"
BUILDROOT="$PROJECT_ROOT/buildroot"
EXTERNAL="$PROJECT_ROOT/external"

# --- Ziel wählen ---
TARGET="$1"  # z.B. x86_64 oder rpi4
if [ -z "$TARGET" ]; then
  echo "Usage: $0 <target>"
  echo "Example: $0 x86_64"
  exit 1
fi

echo "==== Building iPodOS for $TARGET ===="

# --- Alte Config & Output bereinigen ---
echo "--- Cleaning previous build ---"
rm -f "$BUILDROOT/.config"
rm -rf "$BUILDROOT/output"

# --- Defconfig setzen ---
case "$TARGET" in
  x86_64)
    DEFCONFIG="ipodos_x86_64_defconfig"
    ;;
  rpi4)
    DEFCONFIG="ipodos_rpi4_defconfig"
    ;;
  rpi5)
    DEFCONFIG="ipodos_rpi5_defconfig"
    ;;
  *)
    echo "Unknown target: $TARGET"
    exit 1
    ;;
esac

echo "--- Applying Defconfig ---"
make -C "$BUILDROOT" BR2_EXTERNAL="$EXTERNAL" "$DEFCONFIG"

# --- Build starten ---
echo "--- Starting Build ---"
make -C "$BUILDROOT" BR2_EXTERNAL="$EXTERNAL" -j$(nproc)

# --- Fertig ---
echo "==== Build complete for $TARGET ===="
echo "Output images:"
ls -lh "$BUILDROOT/output/images/"
