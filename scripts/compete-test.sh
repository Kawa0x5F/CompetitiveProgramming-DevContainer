#!/bin/bash

set -eu

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
source "$SCRIPT_DIR/compete-lib.sh"

REPO_ROOT=$(cd "$SCRIPT_DIR/.." && pwd)
load_config

# テストケースのダウンロード処理
if [ ! -d "test" ]; then
  echo "テストケースが見つかりません。ダウンロードを開始します..."
  SITE=$(get_contest_site)

  if [ "$SITE" == "AtCoder" ]; then
    echo "AtCoderコンテストを検出しました。'acc download' を使用します..."
    acc download
  elif [ "$SITE" == "Codeforces" ]; then
    echo "Codeforcesコンテストを検出しました。'oj download' を使用します..."
    CONTEST_ID=$(basename "$(dirname "$(pwd)")")
    PROBLEM_LETTER=$(basename "$(pwd)")
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
detect_source_file FILE

if [ -z "$FILE" ]; then
  echo "エラー: テスト対象のソースファイルが見つかりません。"
  exit 1
fi

echo "テストを実行します: $FILE"
PROBLEM_NAME=$(basename "$(pwd)")
TEST_DIR="test"

case $FILE in
  *.rs)
    oj t -d "$TEST_DIR" -c "cargo run --bin $PROBLEM_NAME --release"
    ;;
  *.py)
    oj t -d "$TEST_DIR" -c "python3.11 $FILE"
    ;;
  *.cpp)
    g++ "$FILE" -o a.out "${CPP_COMPILER_FLAGS[@]}" ${CPP_LINKER_FLAGS} && oj t -d "$TEST_DIR" -c "./a.out"
    ;;
  *)
    echo "エラー: サポートされていないファイル形式です: $FILE"
    exit 1
    ;;
esac

echo "テストが完了しました。"
