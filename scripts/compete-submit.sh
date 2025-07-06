#!/bin/bash

set -eu

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
source "$SCRIPT_DIR/compete-lib.sh"

REPO_ROOT=$(cd "$SCRIPT_DIR/.." && pwd)
load_config

FORCE_SUBMIT=false
FILE=""

# 引数の解析
for arg in "$@"; do
  if [ "$arg" == "--force" ] || [ "$arg" == "-f" ]; then
    FORCE_SUBMIT=true
  else
    if [ -z "$FILE" ]; then
      FILE=$arg
    fi
  fi
done

detect_source_file FILE

if [ -z "$FILE" ]; then
  echo "エラー: 提出対象のソースファイルが見つかりません。"
  exit 1
fi

# テストの実行（--forceでスキップ）
if [ "$FORCE_SUBMIT" = false ]; then
  echo "提出前にテストを実行します..."
  "$SCRIPT_DIR/compete-test.sh" "$FILE"
  
  if [ $? -ne 0 ]; then
    echo "テストに失敗しました。提出を中断します。"
    echo "テストを無視して提出する場合は --force オプションを使用してください。"
    exit 1
  fi
  echo "テストに成功しました。"
else
  echo "テストをスキップして提出します... (--force)"
fi

# 提出処理
echo "提出処理を開始します: $FILE"
SITE=$(get_contest_site)

if [ "$SITE" == "AtCoder" ]; then
  acc submit "$FILE"
elif [ "$SITE" == "Codeforces" ]; then
  oj s --yes "$FILE"
else
  echo "エラー: コンテストサイトを判別できませんでした。"
  exit 1
fi

echo "提出が完了しました。"