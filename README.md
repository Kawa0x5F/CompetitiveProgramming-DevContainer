
# Competitive Programming DevContainer

## 概要

このリポジトリでは、AtCoderやCodeforcesなどの競技プログラミング用の環境を提供します。
VS Code Dev Containersを利用することで、WindowsやMacなどに関わらず、統一された環境で競プロを行えます。
oj、accを利用したラッパーコマンド`compete`を実装しており、コードのテストや提出をコマンド一つでできます。

デフォルトでRust、C++、Pythonの基礎環境が構築されますが、設定ファイルを調整することで任意の言語に置き換えることができます。

## 導入手順

### 1\. 事前準備

  * [Visual Studio Code](https://code.visualstudio.com/)
  * [Dev Containers 拡張機能](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)
  * [Docker Desktop](https://www.docker.com/products/docker-desktop/)

### 2\. リポジトリのクローン

このリポジトリをローカルにクローン、もしくはフォークします。

```bash
$ git clone https://github.com/Kawa0x5F/CompetitiveProgramming-DevContainer.git
```

### 3\. 環境変数ファイル `.env`, `setting.json`の作成

ログイン情報などを格納するための`.env`ファイルと、Rustのプロジェクト情報を持つための`setting.json`ファイル、それを格納するための`.vscode`ディレクトリを作成します。

```bash
$ cp .devcontainer/.env.example .devcontainer/.env
$ mkdir .vscode
$ cp .devcontainer/setting.sample.json .vscode/setting.json
```

作成した`.devcontainer/.env`ファイルを開き、ログイン情報・セッション情報を入力してください。

```ini
# AtCoder
ATCODER_USERNAME="YOUR_ATCODER_USERNAME"
ATCODER_PASSWORD="YOUR_ATCODER_PASSWORD"
# ブラウザでAtCoderにログイン後、開発者ツールでCookieからREVEL_SESSIONの値をコピー
ATCODER_REVEL_SESSION="YOUR_REVEL_SESSION_COOKIE"

# Codeforces
CODEFORCES_USERNAME="YOUR_CODEFORCES_USERNAME"
CODEFORCES_PASSWORD="YOUR_CODEFORCES_PASSWORD"```
```

### 4\. Dev Containerで開く

1.  VS Codeでこのリポジトリのフォルダを開きます。
2.  左下の`><`アイコンをクリックし、表示されたメニューから「Reopen in Container」を選択します。
3.  初回起動時はDockerイメージのビルドが実行されるため、起動に数分かかります。ビルド完了後、環境が自動的にセットアップされ、`.env`ファイルの情報に基づいてログイン処理が実行されます。

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

コンテストがオープンになってからでないとうまく正常に動作しない点に注意してください。

### コードのテスト (`compete test`)

カレントディレクトリの問題に対するテストを実行します。
サンプルのテストケースがなかった場合、自動でダウンロードします。

```bash
# abc365/a ディレクトリに移動してから実行
cd solutions/AtCoder/ABC/abc365/a

# main.rs を自動で見つけてテストする
compete test

# ファイルを明示的に指定してテストする
compete test main.cpp
```

### コードの提出 (`compete submit`)

ファイルを指定して解答を提出します。提出前に自動でテストが実行されます。

```bash
# main.rs を自動で見つけてテストし、提出する
compete submit

# テストをスキップして強制的に提出する
compete submit --force main.rs
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
│   ├── Dockerfile        # Dev Containerの環境定義
│   ├── devcontainer.json # Dev Containerの設定
│   └── .env              # 環境変数ファイル（Git管理外）
├── config.default        # competeコマンドや各ツールの設定ファイル
├── scripts/              # competeコマンドのスクリプト群
├── src/                  # 解答コードを保存するディレクトリ
└── templates/            # 各言語・サイトのテンプレートファイル
```

## カスタマイズ

### 設定の変更

`config.default`ファイル（または`compete config edit`）を編集することで、解答を保存するディレクトリ名や、テスト時に優先する言語などを変更できます。

### テンプレートの編集

`templates/`ディレクトリ内の各テンプレート（`acc/`や`cf/`など）を編集することで、`compete new`で生成されるファイルの雛形を自由に変更できます。
