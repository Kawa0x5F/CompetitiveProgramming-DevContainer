#!/bin/bash

# スクリプトが失敗したら即座に終了する設定
set -eu

echo "--- Logging in to AtCoder (acc) ---"
acc login

echo ""
echo "--- Logging in to AtCoder (oj) ---"
oj login https://atcoder.jp

echo ""
echo "--- Logging in to Codeforces (oj) ---"
oj login https://codeforces.com

echo ""
echo "All login processes initiated."