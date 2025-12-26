#!/bin/sh
set -e

ln -sf /etc/systemd/system/ipod.service \
  $TARGET_DIR/etc/systemd/system/multi-user.target.wants/ipod.service
