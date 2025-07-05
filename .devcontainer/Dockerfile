FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    curl \
    git \
    nodejs \
    npm \
    unzip \
    software-properties-common \
    gpg-agent \
    sudo && \
    add-apt-repository -y ppa:deadsnakes/ppa && \
    apt-get update && \
    apt-get install -y python3.11 python3.11-venv && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

ENV RUSTUP_HOME=/usr/local/rustup \
    CARGO_HOME=/usr/local/cargo \
    PATH=/usr/local/cargo/bin:$PATH

RUN useradd -m -s /bin/bash compro && \
    echo "compro ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

RUN npm install -g atcoder-cli

RUN python3.11 -m venv /opt/oj-tools && \
    /opt/oj-tools/bin/pip install --no-cache-dir online-judge-tools

ENV PATH=/opt/oj-tools/bin:$PATH

USER compro
WORKDIR /home/compro

CMD ["/bin/bash"]