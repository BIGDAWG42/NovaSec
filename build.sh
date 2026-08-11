#!/usr/bin/env bash
set -euo pipefail

lb clean --purge || true
lb config \
  --architectures amd64 \
  --distribution bookworm \
  --binary-images iso-hybrid \
  --bootappend-live "boot=live components hostname=novasec username=novasec" \
  --archive-areas "main contrib non-free non-free-firmware" \
  --debian-installer none \
  --iso-application "NovaSec" \
  --iso-publisher "NovaSec" \
  --iso-volume "NOVASEC_01"

sudo lb build
