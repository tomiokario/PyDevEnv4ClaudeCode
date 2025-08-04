# Dockerコンテナでの正しいパッケージ管理方法

## 概要
Dockerコンテナ環境でPythonパッケージを効率的に管理する方法を説明します。実際の検証に基づいた実用的な手順を記載しています。

## ❌ 間違った方法（ホストマシンにインストール）

```bash
# これらはホストマシンで実行されてしまう
pip install --user requests
python -c "import requests; print(requests.__version__)"
```

## ✅ 正しい方法（検証済み）

### 方法1: 直接pipコマンドを使用（推奨）


1. **基本的なパッケージのインストール**
```bash
docker compose exec dev pip install numpy pandas matplotlib scikit-learn
```

2. **機械学習フレームワークのインストール**
```bash
# PyTorch (CPU版)
docker compose exec dev pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cpu

# TensorFlow
docker compose exec dev pip install tensorflow
```

3. **インストール状況の確認**
```bash
docker compose exec dev pip list
```

### 方法2: requirements.txtの手動管理

1. **requirements.txtにパッケージを追加**
```bash
echo "numpy>=1.24.0" >> requirements.txt
echo "pandas>=2.0.0" >> requirements.txt
```

2. **Dockerイメージを再ビルド**
```bash
docker compose build --no-cache
docker compose up -d
```

### 方法3: 一時的なテスト用インストール

開発・テスト段階で一時的にパッケージを試したい場合：

```bash
# 一時的にインストール（コンテナ再作成で消失）
docker compose exec dev pip install --user beautifulsoup4

# 動作確認
docker compose exec dev python -c "import bs4; print('BeautifulSoup4 available')"
```

**注意**: この方法でインストールしたパッケージはコンテナを再作成すると消えます。

## Dockerfileの構成

改善されたDockerfileでは以下のような構成になっています：

```dockerfile
# requirements.txtのコピー（存在する場合）
COPY --chown=developer:developer requirements.txt* /tmp/

# requirements.txtからパッケージをインストール
RUN if [ -f /tmp/requirements.txt ]; then \
        pip install --user --no-cache-dir -r /tmp/requirements.txt; \
    fi
```

## 環境の確認方法（検証済み）

### ホストとコンテナの環境を区別して確認

```bash
# ホスト環境の確認
python -c "import sys; print('ホストPython:', sys.version)"
pip list | grep requests || echo "ホスト: requestsなし"

# コンテナ環境の確認
docker compose exec dev python -c "import sys; print('コンテナPython:', sys.version)"
docker compose exec dev pip list | head -20

# 基本パッケージの動作確認
docker compose exec dev python -c "import requests; print('✅ requests available')"
```

## ベストプラクティス

1. **直接pipコマンドを使用**
   - コンテナ内で`pip install`コマンドを直接実行
   - `pip list`コマンドで現在の状況を確認
   - 必要に応じて`pip uninstall`でパッケージを削除

2. **永続化の管理**
   - 永続化が必要な場合はrequirements.txtに手動で記録
   - その後`docker compose build --no-cache`でイメージを再ビルド
   - 一時的な検証には直接pipコマンドを使用

3. **コンテナ内での作業**
   - `docker compose exec dev bash`でコンテナに入る
   - またはすべてのコマンドに`docker compose exec dev`を付ける

4. **軽量な環境を維持**
   - 基本はrequestsのみ
   - 必要に応じてパッケージを追加

## トラブルシューティング

### パッケージが見つからない場合

```bash
# コンテナを完全に再作成
docker compose down -v
docker compose build --no-cache
docker compose up -d

# パッケージを再インストール
docker compose exec dev pip install パッケージ名

# パッケージを確認
docker compose exec dev pip list
```

### 権限エラーが発生する場合

```bash
# developerユーザーとして実行
docker compose exec -u developer dev pip install --user requests

# または、rootユーザーとして実行
docker compose exec -u root dev pip install requests
```

## まとめ

- ホストマシンとDockerコンテナの環境を明確に区別する
- 直接pipコマンドを使用してパッケージをインストールする
- 永続化が必要な場合はrequirements.txtを手動で更新してイメージを再ビルド
- コンテナ内での作業は`docker compose exec dev`を使用する
- 軽量な環境を維持し、必要に応じてパッケージを追加する

