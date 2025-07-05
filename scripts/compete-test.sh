#!/bin/bash

set -eu

if [ ! -d "test" ]; then
  echo "テストケースが見つかりません。ダウンロードを開始します..."
  CURRENT_PATH=$(pwd)

  if [[ "$CURRENT_PATH" == *"/AtCoder/"* ]]; then
    echo "AtCoderコンテストを検出しました。'acc download' を使用します..."
    acc download
  elif [[ "$CURRENT_PATH" == *"/Codeforces/"* ]]; then
    echo "Codeforcesコンテストを検出しました。'oj download' を使用します..."
    CONTEST_ID=$(basename "$(dirname "$CURRENT_PATH")")
    PROBLEM_LETTER=$(basename "$CURRENT_PATH")
    URL="https://codeforces.com/contest/$CONTEST_ID/problem/$PROBLEM_LETTER"
    echo "ダウンロード元URL: $URL"
    oj d "$URL"
  else
    echo "エラー: コンテストサイトを判別できませんでした。"
    exit 1
  fi
  echo "ダウンロードが完了しました。"
  echo "-------------------------------------"
fi

FILE=${1:-}

if [ -z "$FILE" ]; then
  for ext in "${DEFAULT_LANG_PRIORITY[@]}"; do
    if [ -f "main.$ext" ]; then
      FILE="main.$ext"
      echo "テスト対象ファイル: $FILE (自動検出)"
      break
    fi
  done
fi

if [ -z "$FILE" ]; then
  echo "エラー: テスト対象のソースファイルが見つかりません。"
  exit 1
fi

echo "テストを実行します: $FILE"
PROBLEM_NAME=$(basename "$(pwd)")

case $FILE in
  *.rs)
    oj t -c "cargo run --bin $PROBLEM_NAME --release"
    ;;
  *.py)
    oj t -c "python3 $FILE"
    ;;
  *.cpp)
    g++ "$FILE" -o a.out "${CPP_FLAGS}" && oj t -c "./a.out"
    ;;
  *)
    echo "エラー: サポートされていないファイル形式です: $FILE"
    exit 1
    ;;
esac

echo "テストが完了しました。"