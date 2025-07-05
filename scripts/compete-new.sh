#!/bin/bash

set -eu

if [ -z "${1:-}" ]; then
  echo "Usage: compete new <contest_id>"
  exit 1
fi

CONTEST_ID=$1
# config.defaultから読み込まれた変数を利用
TARGET_PARENT_DIR="${SOLUTIONS_DIR}/AtCoder/ABC"
TEMPLATE_PATH="${REPO_ROOT}/${ACC_TEMPLATE_DIR}"

# 作業ディレクトリに移動
mkdir -p "$TARGET_PARENT_DIR"
cd "$TARGET_PARENT_DIR"

echo "Creating contest '$CONTEST_ID' in '$TARGET_PARENT_DIR'..."
echo "Using template from '$TEMPLATE_PATH'..."

# acc new を実行してテンプレートから環境を生成
acc new "$CONTEST_ID" --template "$TEMPLATE_PATH"

echo "Done. Contest directory created at: ${TARGET_PARENT_DIR}/${CONTEST_ID}"