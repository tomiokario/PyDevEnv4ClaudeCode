#!/bin/bash

# Dockerコンテナ内でパッケージをインストール・管理するスクリプト

set -e

# 使用方法を表示
show_usage() {
    echo "使用方法:"
    echo "  $0 install <package_name> [package_name2] ...  # パッケージをインストール"
    echo "  $0 add <package_name> [package_name2] ...      # パッケージを追加してrequirements.txtに記録"
    echo "  $0 remove <package_name> [package_name2] ...   # パッケージを削除"
    echo "  $0 list                                         # インストール済みパッケージ一覧"
    echo "  $0 rebuild                                      # イメージを再ビルド"
    echo ""
    echo "例:"
    echo "  $0 install requests beautifulsoup4"
    echo "  $0 add numpy pandas"
    echo "  $0 remove old-package"
}

# パッケージをインストール
install_packages() {
    echo "📦 パッケージをインストール中: $@"
    pip install --user "$@"
    echo "✅ インストール完了"
}

# パッケージを追加してrequirements.txtに記録
add_packages() {
    install_packages "$@"
    
    echo "📝 requirements.txtに追加中..."
    for package in "$@"; do
        # すでに存在するかチェック
        if ! grep -q "^${package%%[=<>!]*}" requirements.txt 2>/dev/null; then
            echo "$package" >> requirements.txt
            echo "  + $package"
        else
            echo "  ~ $package (already in requirements.txt)"
        fi
    done
    
    echo "💡 変更を永続化するにはイメージを再ビルドしてください:"
    echo "   $0 rebuild"
}

# パッケージを削除
remove_packages() {
    echo "🗑️ パッケージを削除中: $@"
    pip uninstall -y "$@" || true
    
    echo "📝 requirements.txtから削除中..."
    for package in "$@"; do
        if [ -f requirements.txt ]; then
            sed -i.bak "/^${package%%[=<>!]*}/d" requirements.txt
            echo "  - $package"
        fi
    done
    echo "✅ 削除完了"
}

# インストール済みパッケージ一覧
list_packages() {
    echo "📋 インストール済みパッケージ:"
    pip list --user
}

# イメージを再ビルド
rebuild_image() {
    echo "🔄 Dockerイメージを再ビルド中..."
    docker compose build --no-cache
    echo "✅ 再ビルド完了"
}

# メイン処理
case "${1:-}" in
    "install")
        shift
        if [ $# -eq 0 ]; then
            show_usage
            exit 1
        fi
        install_packages "$@"
        ;;
    "add")
        shift
        if [ $# -eq 0 ]; then
            show_usage
            exit 1
        fi
        add_packages "$@"
        ;;
    "remove")
        shift
        if [ $# -eq 0 ]; then
            show_usage
            exit 1
        fi
        remove_packages "$@"
        ;;
    "list")
        list_packages
        ;;
    "rebuild")
        rebuild_image
        ;;
    *)
        show_usage
        exit 1
        ;;
esac