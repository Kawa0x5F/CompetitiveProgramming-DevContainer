#!/bin/bash

# 設定ファイルを読み込む
# REPO_ROOTとDEFAULT_LANG_PRIORITYが設定されている前提
load_config() {
  local config_file
  if [ -f "$REPO_ROOT/config.default" ]; then
    config_file="$REPO_ROOT/config.default"
  elif [ -f "$HOME/.config/compete-cli/config" ]; then
    config_file="$HOME/.config/compete-cli/config"
  else
    echo "エラー: 設定ファイルが見つかりません。" >&2
    exit 1
  fi
  source "$config_file"
}

# 提出・テスト対象のソースファイルを自動検出する
detect_source_file() {
  local file_var_name=$1
  
  if [ -z "${!file_var_name}" ]; then
    local detected_file=""
    # DEFAULT_LANG_PRIORITY は設定ファイルから読み込まれる
    for ext in "${DEFAULT_LANG_PRIORITY[@]}"; do
      if [ -f "main.$ext" ]; then
        detected_file="main.$ext"
        break
      fi
    done
    
    if [ -n "$detected_file" ]; then
      # 関数の呼び出し元で変数を設定する
      eval "$file_var_name=\"$detected_file\""
      echo "対象ファイル: ${!file_var_name} (自動検出)"
    fi
  fi
}

# 現在のディレクトリからコンテストサイトを判別する
get_contest_site() {
  local current_path
  current_path=$(pwd)
  if [[ "$current_path" == *"/AtCoder/"* ]]; then
    echo "AtCoder"
  elif [[ "$current_path" == *"/Codeforces/"* ]]; then
    echo "Codeforces"
  else
    echo "Unknown"
  fi
}
