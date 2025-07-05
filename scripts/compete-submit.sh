#!/bin/bash

set -eu

FORCE_SUBMIT=false
FILE=""

for arg in "$@"; do
  if [ "$arg" == "--force" ] || [ "$arg" == "-f" ]; then
    FORCE_SUBMIT=true
  else
    if [ -z "$FILE" ]; then
      FILE=$arg
    fi
  fi
done

if [ -z "$FILE" ]; then
  for ext in "${DEFAULT_LANG_PRIORITY[@]}"; do
    if [ -f "main.$ext" ]; then
      FILE="main.$ext"
      echo "提出ファイル: $FILE (自動検出)"
      break
    fi
  done
fi

if [ -z "$FILE" ]; then
  echo "エラー: 提出対象のソースファイルが見つかりません。"
  exit 1
fi

if [ "$FORCE_SUBMIT" = false ]; then
  echo "提出前にテストを実行します..."
  # compete-test.sh を呼び出す
  "$(dirname "$0")/compete-test.sh" "$FILE"
  
  if [ $? -ne 0 ]; then
    echo "テストに失敗しました。提出を中断します。"
    echo "テストを無視して提出する場合は --force オプションを使用してください。"
    exit 1
  fi
  echo "テストに成功しました。"
else
  echo "テストをスキップして提出します... (--force)"
fi

echo "提出処理を開始します: $FILE"
CURRENT_PATH=$(pwd)

if [[ "$CURRENT_PATH" == *"/AtCoder/"* ]]; then
  acc submit "$FILE"
elif [[ "$CURRENT_PATH" == *"/Codeforces/"* ]]; then
  oj s --yes "$FILE"
else
  echo "エラー: コンテストサイトを判別できませんでした。"
  exit 1
fi

echo "提出が完了しました。"