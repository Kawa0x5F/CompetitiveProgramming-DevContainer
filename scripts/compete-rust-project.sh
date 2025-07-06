#!/bin/bash

set -eu

# --- 共通ライブラリと設定の読み込み ---
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
source "$SCRIPT_DIR/compete-lib.sh"

REPO_ROOT=$(cd "$SCRIPT_DIR/.." && pwd)
load_config # config.defaultから設定を読み込む
# -----------------------------------------

# config.defaultで定義された解答ディレクトリの絶対パス
# 'src/' という名前に合わせる
SOLUTIONS_DIR_NAME="src"
SOLUTIONS_ABS_PATH="${REPO_ROOT}/${SOLUTIONS_DIR_NAME}"
RUST_PROJECT_JSON="${REPO_ROOT}/rust-project.json"

echo "Searching for main.rs files in ${SOLUTIONS_ABS_PATH}..."

# 'jq'を使用して、見つかった全てのmain.rsからrust-project.jsonを生成
# この構成では依存関係の自動解決は難しいため、depsは空にしておく
CRATES_JSON=$(find "$SOLUTIONS_ABS_PATH" -name "main.rs" | jq -R -s '
  split("\n") |
  map(select(length > 0)) |
  map({
    "root_module": .,
    "edition": "2021",
    "deps": []
  })
')

if ! command -v jq &> /dev/null; then
  echo "エラー: この機能には 'jq' が必要です。" >&2
  exit 1
fi

echo "Generating ${RUST_PROJECT_JSON}..."

jq -n --argjson crates "$CRATES_JSON" '{
  "crates": $crates
}' > "$RUST_PROJECT_JSON"

echo "✅ Done. rust-project.json has been updated."
echo "VS Codeで 'Rust-Analyzer: Restart Server' を実行して変更を適用してください。"