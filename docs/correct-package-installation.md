# Dockerコンテナでの正しいパッケージ管理方法

## 概要
Dockerコンテナ環境でPythonパッケージを効率的に管理し、永続化する方法を説明します。新しいパッケージ管理スクリプトの使用法も含みます。

## ❌ 間違った方法（ホストマシンにインストール）

```bash
# これらはホストマシンで実行されてしまう
pip install --user requests
python -c "import requests; print(requests.__version__)"
```

## ✅ 正しい方法

### 方法1: パッケージ管理スクリプトを使用（推奨）

1. **パッケージを追加してrequirements.txtに自動記録**
```bash
docker compose exec dev /scripts/install-packages.sh add numpy pandas matplotlib
```

2. **変更を永続化（イメージ再ビルド）**
```bash
docker compose exec dev /scripts/install-packages.sh rebuild
```

3. **確認**
```bash
docker compose exec dev /scripts/install-packages.sh list
```

### 方法2: 一時的なインストール

1. **コンテナ内で一時的にインストール**
```bash
docker compose exec dev /scripts/install-packages.sh install beautifulsoup4
```

**注意**: この方法ではコンテナを再作成すると消えてしまいます。

### 方法3: 手動でrequirements.txtを編集

1. **requirements.txtにパッケージを追加**
```bash
echo "requests>=2.31.0" >> requirements.txt
```

2. **Dockerイメージを再ビルド**
```bash
docker compose build --no-cache
docker compose up -d
```

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

## 環境の確認方法

### ホストとコンテナの環境を区別して確認

```bash
# ホスト環境の確認
python -c "import sys; print('ホストPython:', sys.version)"
pip list | grep requests || echo "ホスト: requestsなし"

# コンテナ環境の確認
docker compose exec dev python -c "import sys; print('コンテナPython:', sys.version)"
docker compose exec dev /scripts/install-packages.sh list | head -20
```

## ベストプラクティス

1. **パッケージ管理スクリプトを活用**
   - `add`コマンドで自動的にrequirements.txtに記録
   - `remove`コマンドで不要なパッケージを削除
   - `list`コマンドで現在の状況を確認

2. **永続化の管理**
   - `add`コマンド使用後は`rebuild`で永続化
   - 一時的な検証には`install`コマンドを使用

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

# パッケージを確認
docker compose exec dev /scripts/install-packages.sh list
```

### 権限エラーが発生する場合

```bash
# developerユーザーとして実行
docker compose exec -u developer dev /scripts/install-packages.sh install requests
```

## まとめ

- ホストマシンとDockerコンテナの環境を明確に区別する
- パッケージ管理スクリプト（`/scripts/install-packages.sh`）を積極的に活用する
- `add`コマンドで自動的にrequirements.txtを更新し、`rebuild`で永続化
- コンテナ内での作業は`docker compose exec dev`を使用する
- 軽量な環境を維持し、必要に応じてパッケージを追加する