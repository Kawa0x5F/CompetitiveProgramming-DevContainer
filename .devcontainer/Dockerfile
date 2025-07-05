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
    gpg-agent && \
    add-apt-repository -y ppa:deadsnakes/ppa && \
    apt-get update && \
    apt-get install -y python3.11 python3.11-venv

    ENV RUSTUP_HOME=/usr/local/rustup \
    CARGO_HOME=/usr/local/cargo \
    PATH=/usr/local/cargo/bin:$PATH
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

RUN npm install -g atcoder-cli

RUN python3.11 -m venv /opt/oj-tools
RUN /opt/oj-tools/bin/pip install online-judge-tools

ENV PATH=/opt/oj-tools/bin:$PATH

CMD ["/bin/bash"]
