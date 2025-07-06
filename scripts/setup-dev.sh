#!/bin/bash
set -eu

echo "--- DevContainerの初回セットアップを実行します ---"

# シンボリックリンクの作成
sudo ln -sf /workspace/scripts/compete /usr/local/bin/compete

# 設定ファイルの準備
mkdir -p ~/.config/compete-cli
cp /workspace/config.default ~/.config/compete-cli/config
mkdir -p ~/.config/atcoder-cli-nodejs
if [ ! -f ~/.config/atcoder-cli-nodejs/config.json ]; then
  echo "{}" > ~/.config/atcoder-cli-nodejs/config.json
fi

# atcoder-cli の設定
acc config default-test-dirname-format test

echo "--- セットアップが完了しました ---"
