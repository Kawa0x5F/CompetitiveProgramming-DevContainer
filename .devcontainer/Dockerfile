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
    add-apt-repository -y ppa:ubuntu-toolchain-r/test && \
    apt-get update && \
    apt-get install -y g++-12 libgmp-dev libeigen3-dev && \
    update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-12 100 && \
    add-apt-repository -y ppa:deadsnakes/ppa && \
    apt-get update && \
    apt-get install -y python${PYTHON_VERSION} python${PYTHON_VERSION}-venv python${PYTHON_VERSION}-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*


# Boost 1.82.0 のインストール
RUN curl -L https://sourceforge.net/projects/boost/files/boost/1.82.0/boost_1_82_0.tar.gz/download -o /tmp/boost.tar.gz && \
    tar -xzf /tmp/boost.tar.gz -C /opt && \
    rm /tmp/boost.tar.gz && \
    cd /opt/boost_1_82_0 && \
    ./bootstrap.sh --prefix=/opt/boost/gcc && \
    ./b2 install --prefix=/opt/boost/gcc -j"$(nproc)"

# AtCoder AC-Library 1.5.1 のインストール
RUN git clone https://github.com/atcoder/ac-library.git /opt/ac-library && \
    cd /opt/ac-library && \
    git checkout v1.5.1

# Rust環境のセットアップ
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain 1.70.0

# グローバルなnpmパッケージのインストール
RUN npm install -g atcoder-cli

# Pythonツール (oj-tools, aclogin) のインストール
RUN python${PYTHON_VERSION} -m venv /opt/oj-tools && \
    /opt/oj-tools/bin/pip install --no-cache-dir online-judge-tools setuptools selenium aclogin
RUN /opt/oj-tools/bin/pip install --no-cache-dir \
    numpy==1.24.1 \
    scipy==1.10.1 \
    networkx==3.0 \
    sympy==1.11.1 \
    sortedcontainers==2.4.0 \
    more-itertools==9.0.0 \
    shapely==2.0.0 \
    bitarray==2.6.2 \
    PuLP==2.7.0 \
    mpmath==1.2.1 \
    pandas==1.5.2 \
    z3-solver==4.12.1.0 \
    scikit-learn==1.2.0 \
    ortools==9.5.2237 \
    ac-library-python \
    setuptools==66.0.0 \
    cppyy==2.4.1 \
    torch==1.13.1 \
    polars==0.15.15 \
    lightgbm==3.3.1 \
    gmpy2==2.1.5 \
    numba==0.57.0

# 一般ユーザーの作成とsudo権限の付与
RUN useradd -m -s /bin/bash compro && \
    echo "compro ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# comproユーザーにrustとcargoのディレクトリの所有権を渡す
RUN chown -R compro:compro /usr/local/rustup /usr/local/cargo

# ユーザーを切り替え
USER compro
WORKDIR /home/compro

CMD ["/bin/bash"]