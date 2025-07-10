#!/usr/bin/env bash
# Simple backup script (deliberately contains a typo)

SOURCE_DIR="$HOME"   # Typo: SEOURCE instead of SOURCE
DEST_DIR="/tmp/backup_$(date +%F)"

mkdir -p "$DEST_DIR"
rsync -a --delete "$SOURCE_DIR"/ "$DEST_DIR"/

echo "Backup complete: $DEST_DIR"
