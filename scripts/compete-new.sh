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
  abc* | arc* | agc* | ahc*)
    SITE="AtCoder"
    ;;
  ^[0-9]+$)
    SITE="Codeforces"
    ;;
  *)
    echo "エラー: 不明な形式のコンテストIDです: $CONTEST_ID"
    exit 1
    ;;
esac

# --- ターゲットディレクトリパスを動的に生成 ---
# これにより、コマンドの実行場所に関わらず、常に正しい場所に作成される
TARGET_PARENT_DIR="${REPO_ROOT}/${SOLUTIONS_DIR_NAME}/${SITE}"
TARGET_CONTEST_DIR="${TARGET_PARENT_DIR}/${CONTEST_ID}"

echo "Site: ${SITE}"
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

echo "-------------------------------------"
  echo "Manually generating Cargo.toml for the contest..."

  CONTEST_DIR_PATH="${TARGET_PARENT_DIR}/${CONTEST_ID}"
  NEW_CARGO_TOML_PATH="${CONTEST_DIR_PATH}/Cargo.toml"
  CARGO_TEMPLATE_PATH="${TEMPLATE_PATH}/Cargo.toml.contest"

  sed "s/{{ contest.id }}/$CONTEST_ID/g" "$CARGO_TEMPLATE_PATH" > "$NEW_CARGO_TOML_PATH"

  # 各問題の[[bin]]セクションを追記
  problem_dirs=$(find "$CONTEST_DIR_PATH" -mindepth 1 -maxdepth 1 -type d -not -path '*/test*' | sort)
  if [ -n "$problem_dirs" ]; then
    echo "$problem_dirs" | while read -r problem_dir; do
      problem_id=$(basename "$problem_dir")
      
      echo "" >> "$NEW_CARGO_TOML_PATH"
      echo "[[bin]]" >> "$NEW_CARGO_TOML_PATH"
      echo "name = \"$problem_id\"" >> "$NEW_CARGO_TOML_PATH"
      echo "path = \"$problem_id/main.rs\"" >> "$NEW_CARGO_TOML_PATH"
    done
    echo "✅ Cargo.toml generated successfully with problem binaries."
  fi

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
echo "Updating .vscode/settings.json for rust-analyzer..."

SOLUTIONS_DIR_NAME="src" # あなたの構成に合わせています
SOLUTIONS_ABS_PATH="${REPO_ROOT}/${SOLUTIONS_DIR_NAME}"
SETTINGS_JSON_PATH="${REPO_ROOT}/.vscode/settings.json"

# .vscodeディレクトリがなければ作成
mkdir -p "$(dirname "$SETTINGS_JSON_PATH")"
# settings.jsonがなければ空のJSONファイルを作成
touch "$SETTINGS_JSON_PATH"
if ! jq . "$SETTINGS_JSON_PATH" &>/dev/null; then
  echo "{}" > "$SETTINGS_JSON_PATH"
fi

# 全てのCargo.tomlのパスをJSON配列として取得
CARGO_PATHS=$(find "$SOLUTIONS_ABS_PATH" -name "Cargo.toml" | jq -R -s 'split("\n") | map(select(length > 0))')

# jqを使ってsettings.jsonを更新（既存の内容は保持）
jq --argjson paths "$CARGO_PATHS" '."rust-analyzer.linkedProjects" = $paths' "$SETTINGS_JSON_PATH" > "${SETTINGS_JSON_PATH}.tmp" && mv "${SETTINGS_JSON_PATH}.tmp" "$SETTINGS_JSON_PATH"

echo "✅ .vscode/settings.json has been updated."