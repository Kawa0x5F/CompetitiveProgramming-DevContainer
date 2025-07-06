
# Competitive Programming DevContainer

## 概要

このリポジトリでは、AtCoderやCodeforcesなどの競技プログラミング用の環境を提供します。
VS Code Dev Containersを利用することで、WindowsやMacなどに関わらず、統一された環境で競プロを行えます。

oj、accを同じように利用するために`compete`コマンドを実装しており、コードのテストや提出を面倒な設定無く行うことが可能です。
デフォルトでRust、C++、Pythonの基礎環境が構築されますが、設定ファイルを調整することで任意の言語に置き換えることができます。

## 導入手順

### 1\. 事前準備

  * [Visual Studio Code](https://code.visualstudio.com/)
  * [Dev Containers 拡張機能](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)
  * [Docker Desktop](https://www.docker.com/products/docker-desktop/) または互換性のあるDocker環境

### 2\. リポジトリのクローン

このリポジトリをローカルマシンにクローンします。

```bash
git clone <your-repository-url>
cd <repository-directory>
```

### 3\. 環境変数ファイル `.env` の作成

ログイン情報などの機密情報を格納するための`.env`ファイルを作成します。`.gitignore`によってGitの追跡対象から除外されているため、安全です。

```bash
cp .devcontainer/.env.example .devcontainer/.env
```

次に、作成した`.devcontainer/.env`ファイルを開き、あなたの情報に合わせて内容を編集してください。

```ini
# --- AtCoder ---
# セッション情報でのログインを推奨（安全性が高い）
# ブラウザでAtCoderにログイン後、開発者ツールでCookieからREVEL_SESSIONの値をコピー
ATCODER_REVEL_SESSION="<your_revel_session_value>"

# ユーザー名/パスワードでのログインも可能（非推奨）
# ATCODER_USERNAME="<your_atcoder_username>"
# ATCODER_PASSWORD="<your_atcoder_password>"


# --- Codeforces ---
CODEFORCES_USERNAME="<your_codeforces_username>"
CODEFORCES_PASSWORD="<your_codeforces_password>"
```

### 4\. Dev Containerで開く

1.  VS Codeでこのリポジトリのフォルダを開きます。
2.  左下の緑色の`><`アイコンをクリックし、表示されたメニューから「Reopen in Container」を選択します。
3.  初回起動時はDockerイメージのビルドが実行されるため、数分かかります。ビルド完了後、環境が自動的にセットアップされ、ログイン処理が実行されます。

-----

## 利用方法

この環境では、ターミナルから`compete`コマンドが利用できます。

### コンテストの準備 (`compete new`)

新しいコンテストのディレクトリとテンプレートファイルを自動で作成します。コンテストIDからAtCoder (ABC/ARC/AGC/AHC) やCodeforcesを自動判別します。

```bash
# AtCoderのコンテスト準備
compete new abc365
compete new arc180

# Codeforcesのコンテスト準備
compete new 1985
```

### コードのテスト (`compete test`)

カレントディレクトリの問題に対するテストを実行します。初回実行時には、自動でサンプルケースをダウンロードします。

```bash
# abc365/a ディレクトリに移動してから実行
cd solutions/AtCoder/ABC/abc365/a

# main.cpp を自動で見つけてテストする
compete test

# ファイルを明示的に指定してテストする
compete test main.rs
```

### コードの提出 (`compete submit`)

ファイルを指定して解答を提出します。提出前に自動でテストが実行されます。

```bash
# main.cpp を自動で見つけてテストし、提出する
compete submit

# テストをスキップして強制的に提出する
compete submit --force main.py
```

### 設定ファイルの管理 (`compete config`)

設定ファイル`config.default`を簡単に表示・編集できます。

```bash
# 設定内容を表示
compete config view

# エディタで設定ファイルを開く
compete config edit
```

-----

## ディレクトリ構成

```
.
├── .devcontainer/
│   ├── Dockerfile       # Dev Containerの環境定義
│   ├── devcontainer.json # Dev Containerの設定
│   └── .env             # 環境変数ファイル（Git管理外）
├── config.default       # competeコマンドや各ツールの設定ファイル
├── scripts/             # competeコマンドのスクリプト群
├── solutions/           # 解答コードを保存するディレクトリ
└── templates/           # 各言語・サイトのテンプレートファイル
```

## カスタマイズ

### 設定の変更

`config.default`ファイル（または`compete config edit`）を編集することで、解答を保存するディレクトリ名や、テスト時に優先する言語などを変更できます。

### テンプレートの編集

`templates/`ディレクトリ内の各テンプレート（`ac-rust/`や`cf/`など）を編集することで、`compete new`で生成されるファイルの雛形を自由に変更できます。