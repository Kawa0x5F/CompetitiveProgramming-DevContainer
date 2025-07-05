#!/bin/bash
set -eu

echo "--- 自動ログインを試行中 ---"

# AtCoder Login with aclogin (using REVEL_SESSION)
if [ -n "${ATCODER_REVEL_SESSION:-}" ]; then
  echo "🔐 AtCoder に aclogin でログイン中 (REVEL_SESSIONを使用)..."
  # acloginをインストールしている場合、このコマンドでログインできるはず
  # acloginコマンドが存在するか確認し、存在しなければエラーメッセージを表示
  if command -v aclogin &> /dev/null; then
    echo "$ATCODER_REVEL_SESSION" | aclogin
    echo "✅ AtCoder ログイン試行完了。"
  else
    echo "❌ aclogin コマンドが見つかりません。acloginをインストールしてください。"
    echo "   GitHub: https://github.com/key-moon/aclogin"
    echo "   インストール後、DevContainerをリビルドしてください。"
  fi
elif [ -n "${ATCODER_USERNAME:-}" ] && [ -n "${ATCODER_PASSWORD:-}" ]; then
  echo "🔐 AtCoder に oj/acc login でログイン中 (ユーザー名/パスワードを使用)..."
  oj login -u "$ATCODER_USERNAME" -p "$ATCODER_PASSWORD" https://atcoder.jp
  acc login
  echo "✅ AtCoder ログイン試行完了。"
else
  echo "⚠️ AtCoder のセッション情報またはユーザー名/パスワードが.envファイルに設定されていません。スキップします。"
fi

echo ""

# Codeforces Login
if [ -n "${CODEFORCES_USERNAME:-}" ] && [ -n "${CODEFORCES_PASSWORD:-}" ]; then
  echo "🔐 Codeforces にログイン中..."
  oj login -u "$CODEFORCES_USERNAME" -p "$CODEFORCES_PASSWORD" https://codeforces.com
  echo "✅ Codeforces ログイン試行完了。"
else
  echo "⚠️ Codeforces のユーザー名/パスワードが.envファイルに設定されていません。スキップします。"
fi

echo ""
echo "自動ログイン処理が完了しました。"