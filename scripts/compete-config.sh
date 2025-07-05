#!/bin/bash

set -eu

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
REPO_ROOT=$(cd "$SCRIPT_DIR/.." && pwd)
DEV_CONFIG_FILE="$REPO_ROOT/config.default"
INSTALLED_CONFIG_FILE="$HOME/.config/compete-cli/config"

if [ -f "$DEV_CONFIG_FILE" ]; then
  CONFIG_FILE="$DEV_CONFIG_FILE"
elif [ -f "$INSTALLED_CONFIG_FILE" ]; then
  CONFIG_FILE="$INSTALLED_CONFIG_FILE"
else
  echo "Error: Configuration file not found."
  exit 1
fi

ACTION=${1:-view}

case $ACTION in
  view)
    echo "Displaying config from: $CONFIG_FILE"
    echo "-------------------------------------"
    cat "$CONFIG_FILE"
    echo "-------------------------------------"
    ;;
  edit)
    echo "Opening $CONFIG_FILE with an editor..."
    ${EDITOR:-code} "$CONFIG_FILE"
    ;;
  path)
    echo "$CONFIG_FILE"
    ;;
  *)
    echo "Usage: compete config [view|edit|path]"
    exit 1
    ;;
esac