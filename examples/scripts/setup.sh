#!/bin/bash
set -e

echo "🚀 環境を初期化しています..."

# プロジェクト構造の確認と作成
mkdir -p /workspace/{notebooks,scripts,configs}
mkdir -p /data/{raw,processed}
mkdir -p /cache/pip

# Git設定（必要に応じて）
git config --global --add safe.directory /workspace

# bashrcの設定
cat >> ~/.bashrc << 'EOF'
export WORKSPACE_DIR=/workspace
export DATA_DIR=/data
export CACHE_DIR=/cache
alias ll='ls -la'
EOF

echo "✅ セットアップ完了！"