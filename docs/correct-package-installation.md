# 正しいDockerコンテナでのパッケージインストール方法

## 概要
Dockerコンテナ環境で正しくPythonパッケージをインストールし、永続化する方法を説明します。

## ❌ 間違った方法（ホストマシンにインストール）

```bash
# これらはホストマシンで実行されてしまう
pip install --user requests
python -c "import requests; print(requests.__version__)"
```

## ✅ 正しい方法

### 方法1: requirements.txtを使用（推奨）

1. **requirements.txtにパッケージを追加**
```bash
echo "requests>=2.31.0" >> requirements.txt
```

2. **Dockerイメージを再ビルド**
```bash
docker compose build --no-cache
```

3. **コンテナを再起動**
```bash
docker compose down
docker compose up -d
```

4. **確認**
```bash
docker compose exec dev python -c "import requests; print('✅ requests version:', requests.__version__)"
```

### 方法2: コンテナ内で直接インストール（一時的）

1. **コンテナ内でインストール**
```bash
docker compose exec dev pip install --user requests
```

2. **確認**
```bash
docker compose exec dev python -c "import requests; print('✅ requests version:', requests.__version__)"
```

**注意**: この方法ではコンテナを再作成すると消えてしまいます。

### 方法3: インストールスクリプトを使用

1. **スクリプトを使用してインストール**
```bash
docker compose exec dev /scripts/install-packages.sh requests beautifulsoup4
```

2. **永続化したい場合はrequirements.txtに追加**
```bash
echo "requests>=2.31.0" >> requirements.txt
echo "beautifulsoup4>=4.12.0" >> requirements.txt
docker compose build --no-cache
```

## Dockerfileの構成

改善されたDockerfileでは以下のような構成になっています：

```dockerfile
# requirements.txtのコピー（存在する場合）
COPY --chown=developer:developer requirements.txt* /tmp/

# requirements.txtが存在する場合はそれを使用
RUN if [ -f /tmp/requirements.txt ]; then \
        pip install --user --no-cache-dir -r /tmp/requirements.txt; \
    else \
        pip install --user --no-cache-dir \
            numpy pandas matplotlib jupyter \
            scikit-learn; \
    fi
```

## 環境の確認方法

### ホストとコンテナの環境を区別して確認

```bash
# ホスト環境の確認
python -c "import sys; print('ホストPython:', sys.version)"
pip list | grep requests || echo "ホスト: requestsなし"

# コンテナ環境の確認
docker compose exec dev python -c "import sys; print('コンテナPython:', sys.version)"
docker compose exec dev pip list | grep requests || echo "コンテナ: requestsなし"
```

## ベストプラクティス

1. **常にrequirements.txtで管理**
   - バージョンを明記
   - チーム間で環境を統一

2. **Dockerイメージの再ビルド**
   - 新しいパッケージを追加後は必ず再ビルド
   - `--no-cache`オプションでクリーンビルド

3. **コンテナ内での作業**
   - `docker compose exec dev bash`でコンテナに入る
   - またはすべてのコマンドに`docker compose exec dev`を付ける

4. **ボリュームマウントの活用**
   - ソースコードは`volumes`でマウント
   - パッケージはDockerイメージに含める

## トラブルシューティング

### パッケージが見つからない場合

```bash
# コンテナを完全に再作成
docker compose down -v
docker compose build --no-cache
docker compose up -d

# パッケージを確認
docker compose exec dev pip list
```

### 権限エラーが発生する場合

```bash
# developerユーザーとして実行
docker compose exec -u developer dev pip install --user requests
```

## まとめ

- ホストマシンとDockerコンテナの環境を明確に区別する
- パッケージ管理はrequirements.txtで行う
- コンテナ内での作業は`docker compose exec`を使用する
- 永続化にはDockerイメージの再ビルドが必要