#!/bin/bash
# Deploy budget app to NAS
# Usage:
#   ./deploy.sh           — SCP from local machine
#   ./deploy.sh --pull    — SSH into NAS and pull from GitHub (run from any machine)

set -e

NAS_IP="192.168.4.215"
NAS_PORT="9222"
NAS_USER="sclarke"
REMOTE_PATH="/Volume2/appdata/budget/index.html"
GITHUB_URL="https://raw.githubusercontent.com/scottqld/budget/main/index.html"

if [[ "$1" == "--pull" ]]; then
  echo "Pulling latest from GitHub onto NAS..."
  ssh -p "$NAS_PORT" "${NAS_USER}@${NAS_IP}" \
    "curl -L -H 'Cache-Control: no-cache' -H 'Pragma: no-cache' \"${GITHUB_URL}?\$(date +%s)\" -o ${REMOTE_PATH} && grep -o 'v1\.[0-9]*' ${REMOTE_PATH} | head -1"
  echo "✓ Done — http://${NAS_IP}:8080"
else
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
fi
