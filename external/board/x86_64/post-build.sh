#!/bin/sh

TARGET_DIR=$1

# Service aktivieren (Symlink erstellen, wie systemctl enable es tun würde)
# Prüfen, ob der Service existiert
if [ -f "${TARGET_DIR}/etc/systemd/system/ipod.service" ]; then
    mkdir -p "${TARGET_DIR}/etc/systemd/system/multi-user.target.wants"
    ln -sf ../ipod.service "${TARGET_DIR}/etc/systemd/system/multi-user.target.wants/ipod.service"
    echo "Enabled ipod.service"
fi
