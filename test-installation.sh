#!/bin/bash

echo "🔍 Docker環境のパッケージインストール検証スクリプト"
echo "================================================"
echo ""

# Dockerが起動しているか確認
if ! docker info > /dev/null 2>&1; then
    echo "❌ Dockerが起動していません。"
    echo "   Docker Desktopを起動してください。"
    exit 1
fi

echo "1. Dockerコンテナの状態確認"
echo "----------------------------"
docker compose ps

echo ""
echo "2. コンテナが起動していない場合は起動"
echo "--------------------------------------"
if ! docker compose ps | grep -q "dev.*running"; then
    echo "コンテナを起動中..."
    docker compose up -d
    sleep 3
fi

echo ""
echo "3. 現在のパッケージ状態確認"
echo "----------------------------"
echo "ホスト環境:"
python -c "import requests; print('  ✅ requests インストール済み')" 2>/dev/null || echo "  ❌ requests なし"

echo ""
echo "コンテナ環境:"
docker compose exec dev python -c "import requests; print('  ✅ requests インストール済み')" 2>/dev/null || echo "  ❌ requests なし"

echo ""
echo "4. requirements.txtの内容"
echo "-------------------------"
if [ -f requirements.txt ]; then
    echo "requirements.txt:"
    cat requirements.txt | head -10
else
    echo "requirements.txtが存在しません"
fi

echo ""
echo "5. 推奨される次のステップ"
echo "-------------------------"
echo "📝 パッケージを永続的にインストールするには："
echo ""
echo "  1. requirements.txtに追加:"
echo "     echo 'requests>=2.31.0' >> requirements.txt"
echo ""
echo "  2. Dockerイメージを再ビルド:"
echo "     docker compose build --no-cache"
echo ""
echo "  3. コンテナを再起動:"
echo "     docker compose down && docker compose up -d"
echo ""
echo "  4. 確認:"
echo "     docker compose exec dev python -c \"import requests; print('✅', requests.__version__)\""
echo ""
echo "🔧 一時的にインストールするには："
echo "     docker compose exec dev pip install --user requests"