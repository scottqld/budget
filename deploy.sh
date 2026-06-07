#!/bin/bash
# Deploy budget app to NAS
# Usage: ./deploy.sh [nas-user]  (default user: sclarke)
set -e

NAS_IP="192.168.4.215"
NAS_PORT="9222"
NAS_USER="${1:-sclarke}"
REMOTE_PATH="/Volume2/appdata/budget/index.html"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
LOCAL_FILE="$SCRIPT_DIR/index.html"

if [[ ! -f "$LOCAL_FILE" ]]; then
  echo "Error: index.html not found at $LOCAL_FILE" >&2
  exit 1
fi

VERSION=$(grep -oP 'v\d+\.\d+' "$LOCAL_FILE" | head -1)
echo "Deploying budget $VERSION → ${NAS_USER}@${NAS_IP}:${REMOTE_PATH}"

scp -P "$NAS_PORT" "$LOCAL_FILE" "${NAS_USER}@${NAS_IP}:${REMOTE_PATH}"

echo "✓ Done — http://${NAS_IP}:8080"
