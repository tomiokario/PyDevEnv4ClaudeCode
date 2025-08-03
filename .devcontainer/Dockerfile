FROM python:3.11-slim

# システムパッケージのインストール
RUN apt-get update && apt-get install -y \
    build-essential \
    git \
    curl \
    sudo \
    && rm -rf /var/lib/apt/lists/*

# 開発用ユーザーの作成
RUN useradd -m -s /bin/bash -G sudo developer && \
    echo "developer ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# 作業ディレクトリの設定
RUN mkdir -p /workspace /data /cache /scripts && \
    chown -R developer:developer /workspace /data /cache /scripts

# スクリプトのコピー
COPY scripts/setup.sh /scripts/
RUN chmod +x /scripts/setup.sh

USER developer
WORKDIR /workspace

# 基本的なPythonパッケージのインストール
RUN pip install --user --no-cache-dir \
    numpy pandas matplotlib jupyter \
    scikit-learn

# 環境変数の設定
ENV PATH="/home/developer/.local/bin:$PATH"
ENV PYTHONPATH="/workspace:$PYTHONPATH"