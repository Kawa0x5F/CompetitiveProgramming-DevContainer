FROM ubuntu:22.04

# 環境変数を一箇所で定義
ENV DEBIAN_FRONTEND=noninteractive \
    RUSTUP_HOME=/usr/local/rustup \
    CARGO_HOME=/usr/local/cargo \
    PATH=/usr/local/cargo/bin:/opt/oj-tools/bin:$PATH \
    PYTHON_VERSION=3.11

# パッケージのインストールとPython環境のセットアップ
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      build-essential \
      curl \
      git \
      nodejs \
      npm \
      unzip \
      software-properties-common \
      gpg-agent \
      jq \
      sudo && \
    add-apt-repository -y ppa:deadsnakes/ppa && \
    apt-get update && \
    apt-get install -y python${PYTHON_VERSION} python${PYTHON_VERSION}-venv && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Rust環境のセットアップ
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

# グローバルなnpmパッケージのインストール
RUN npm install -g atcoder-cli

# Pythonツール (oj-tools, aclogin) のインストール
RUN python${PYTHON_VERSION} -m venv /opt/oj-tools && \
    /opt/oj-tools/bin/pip install --no-cache-dir online-judge-tools setuptools selenium aclogin

# 一般ユーザーの作成とsudo権限の付与
RUN useradd -m -s /bin/bash compro && \
    echo "compro ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# ユーザーを切り替え
USER compro
WORKDIR /home/compro

CMD ["/bin/bash"]