#!/bin/bash

# Dockerコンテナ内でパッケージをインストールするスクリプト
# このスクリプトはコンテナ内で実行する必要があります

set -e

echo "📦 Dockerコンテナ内でパッケージをインストール中..."

# 引数としてパッケージ名を受け取る
if [ $# -eq 0 ]; then
    echo "使用方法: $0 <package_name> [package_name2] ..."
    echo "例: $0 requests beautifulsoup4"
    exit 1
fi

# パッケージをインストール
echo "インストール中: $@"
pip install --user "$@"

# インストール確認
echo ""
echo "✅ インストール完了"
echo "インストールされたパッケージ:"
for package in "$@"; do
    python -c "import ${package%%[=<>!]*}; print(f'  - ${package%%[=<>!]*}: {${package%%[=<>!]*}.__version__ if hasattr(${package%%[=<>!]*}, \"__version__\") else \"version unknown\"}')" 2>/dev/null || echo "  - $package: インストール済み"
done

echo ""
echo "💡 ヒント: 永続化するにはrequirements.txtに追加してDockerイメージを再ビルドしてください"
echo "   echo '$1' >> requirements.txt"
echo "   docker compose build --no-cache"