#!/bin/bash

set -eu

# --- 共通ライブラリと設定の読み込み ---
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
source "$SCRIPT_DIR/compete-lib.sh"

REPO_ROOT=$(cd "$SCRIPT_DIR/.." && pwd)
load_config # config.defaultから設定を読み込む
# -----------------------------------------

if [ -z "${1:-}" ]; then
  echo "Usage: compete new <contest_id>"
  echo "Examples:"
  echo "  compete new abc365"
  echo "  compete new arc180"
  echo "  compete new 1985   # For Codeforces"
  exit 1
fi

CONTEST_ID=$1
SITE=""
CONTEST_TYPE=""

# --- コンテストIDからサイトと種類を自動判別 ---
case "$CONTEST_ID" in
  abc*)
    SITE="AtCoder"
    CONTEST_TYPE="ABC"
    ;;
  arc*)
    SITE="AtCoder"
    CONTEST_TYPE="ARC"
    ;;
  agc*)
    SITE="AtCoder"
    CONTEST_TYPE="AGC"
    ;;
  ahc*)
    SITE="AtCoder"
    CONTEST_TYPE="AHC"
    ;;
  # 数字のみで構成されるIDはCodeforcesと見なす
  ^[0-9]+$)
    SITE="Codeforces"
    CONTEST_TYPE="CONTEST" # Codeforcesは一つのタイプにまとめる
    ;;
  *)
    echo "エラー: 不明な形式のコンテストIDです: $CONTEST_ID"
    exit 1
    ;;
esac

# --- ターゲットディレクトリパスを動的に生成 ---
# これにより、コマンドの実行場所に関わらず、常に正しい場所に作成される
TARGET_PARENT_DIR="${REPO_ROOT}/${SOLUTIONS_DIR}/${SITE}/${CONTEST_TYPE}"
TARGET_CONTEST_DIR="${TARGET_PARENT_DIR}/${CONTEST_ID}"

echo "Contest Type: ${SITE} ${CONTEST_TYPE}"
echo "Creating contest '$CONTEST_ID' in '$TARGET_CONTEST_DIR'..."

if [ -d "$TARGET_CONTEST_DIR" ]; then
  echo "エラー: ディレクトリは既に存在します: $TARGET_CONTEST_DIR"
  exit 1
fi

# --- サイトに応じて処理を分岐 ---
if [ "$SITE" == "AtCoder" ]; then
  # AtCoderの場合: acc new を使用
  TEMPLATE_PATH="${REPO_ROOT}/${ACC_TEMPLATE_DIR}"
  echo "Using AtCoder template: '$ACC_TEMPLATE_DIR'..."
  
  mkdir -p "$TARGET_PARENT_DIR"
  cd "$TARGET_PARENT_DIR"
  acc new "$CONTEST_ID" --template "$TEMPLATE_PATH"

elif [ "$SITE" == "Codeforces" ]; then
  # Codeforcesの場合: ディレクトリ作成とテンプレートコピー
  TEMPLATE_PATH="${REPO_ROOT}/${CF_TEMPLATE_DIR}"
  echo "Using Codeforces template: '$CF_TEMPLATE_DIR'..."

  if [ ! -d "$TEMPLATE_PATH" ]; then
    echo "エラー: Codeforces用のテンプレートディレクトリが見つかりません: $TEMPLATE_PATH"
    exit 1
  fi
  
  echo "Creating directory and copying template files..."
  mkdir -p "$TARGET_CONTEST_DIR"
  # テンプレートディレクトリの中身を全てコピー
  cp -r "${TEMPLATE_PATH}/." "$TARGET_CONTEST_DIR/"

fi

echo "✅ Done. Contest directory created at: ${TARGET_CONTEST_DIR}"

echo "-------------------------------------"
echo "Updating rust-project.json for rust-analyzer..."
"$SCRIPT_DIR/compete-rust-project.sh"