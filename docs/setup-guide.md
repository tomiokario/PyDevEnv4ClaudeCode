# セットアップガイド

このガイドでは、Python Development Environmentの詳細なセットアップ手順を説明します。

## 前提条件

### Dockerのインストール

この環境構築にはDockerが必要です。以下の手順でインストールしてください：

#### macOS (Homebrew使用)
```bash
# Homebrewがない場合は先にインストール
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Docker Desktopをインストール
brew install --cask docker

# Docker Desktopを起動
open /Applications/Docker.app
```

#### macOS (公式サイトから)
1. [Docker Desktop for Mac](https://docs.docker.com/desktop/install/mac-install/)から.dmgファイルをダウンロード
2. .dmgファイルを開いてDocker.appをApplicationsフォルダにドラッグ
3. Docker Desktopを起動

#### Linux (Ubuntu/Debian)
```bash
# 古いDockerを削除
sudo apt-get remove docker docker-engine docker.io containerd runc

# 必要なパッケージをインストール
sudo apt-get update
sudo apt-get install ca-certificates curl gnupg lsb-release

# DockerのGPGキーを追加
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# Dockerリポジトリを追加
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Dockerをインストール
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin

# ユーザーをdockerグループに追加
sudo usermod -aG docker $USER

# ログアウトして再ログイン、またはターミナルを再起動
```

#### Windows
1. [Docker Desktop for Windows](https://docs.docker.com/desktop/install/windows-install/)から.exeファイルをダウンロード
2. インストーラーを実行してインストール
3. Docker Desktopを起動

#### インストール確認
```bash
# Dockerのバージョン確認
docker --version

# Docker Composeのバージョン確認  
docker compose version

# Dockerの動作確認
docker run hello-world
```

## 環境構築手順

### ステップ1: リポジトリのクローン

```bash
# GitHubからクローン
git clone https://github.com/yourusername/python-dev-env.git
cd python-dev-env
```

### ステップ2: Docker環境のビルド

```bash
# コンテナイメージをビルド
docker compose build
```

**ビルド時間**: 初回は5-10分程度かかります（ネットワーク環境による）

### ステップ3: コンテナの起動

```bash
# バックグラウンドでコンテナを起動
docker compose up -d
```

### ステップ4: 環境への接続

```bash
# コンテナ内のシェルに接続
docker compose exec dev bash
```

### ステップ5: 動作確認

```bash
# 基本パッケージの確認
python -c "import requests; print('✅ 基本環境利用可能')"

# パッケージ一覧の確認
pip list
```

## VS Code Development Containers の使用

### 前提条件
- [Visual Studio Code](https://code.visualstudio.com/)
- [Dev Containers拡張機能](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)

### 使用手順

1. VS Codeでプロジェクトを開く:
   ```bash
   code .
   ```

2. コマンドパレット（Cmd/Ctrl + Shift + P）を開く

3. "Dev Containers: Reopen in Container"を実行

4. 初回は自動的にコンテナがビルドされます

5. VS Codeがコンテナ内で開かれたら準備完了

## 基本的な使用方法

### 開発環境の開始

```bash
# コンテナが停止している場合
docker compose up -d

# 環境に入る
docker compose exec dev bash
```

### Pythonスクリプトの実行

```bash
# コンテナ内でPythonスクリプトを実行
docker compose exec dev python src/your_script.py

# インタラクティブなPythonセッション
docker compose exec dev python
```

### パッケージの追加インストール（検証済み方法）

**重要**: パッケージ管理スクリプトは現在利用できないため、直接pipコマンドを使用します。

#### 推奨方法: 直接pipコマンドを使用

```bash
# 基本的なデータサイエンス・機械学習パッケージ
docker compose exec dev pip install numpy pandas matplotlib scikit-learn

# PyTorch（CPU版）
docker compose exec dev pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cpu

# TensorFlow
docker compose exec dev pip install tensorflow
```

#### パッケージの管理

```bash
# パッケージ一覧を確認
docker compose exec dev pip list

# パッケージの削除
docker compose exec dev pip uninstall パッケージ名

# パッケージの動作確認
docker compose exec dev python -c "import numpy; print('NumPy available')"
```

**注意**: パッケージを永続化したい場合は、必ずrequirements.txtに追加してイメージを再ビルドしてください。詳細は[correct-package-installation.md](correct-package-installation.md)を参照してください。

### ファイルの永続化

- **ワークスペース**: `/workspace` (ローカルの`.`と同期)
- **データ**: `/data` (Dockerボリューム、永続化)
- **キャッシュ**: `/cache` (Dockerボリューム、永続化)

### 環境の停止と再開

```bash
# 環境を停止（データは保持される）
docker compose down

# 環境を再開
docker compose up -d
```

## 動作確認

### 永続性の確認

```bash
# 1. ファイルを作成
echo "test data" > /workspace/test.txt

# 2. コンテナを再起動
docker compose restart

# 3. ファイルが残っているか確認
cat /workspace/test.txt
# "test data" が表示されれば成功
```

### パッケージインストールの確認

```bash
# 1. パッケージをコンテナ内でインストール
docker compose exec dev pip install --user requests

# 2. 動作確認
docker compose exec dev python -c "import requests; print(f'Requests version: {requests.__version__}')"

# 3. コンテナ再起動
docker compose restart

# 4. インストールされたパッケージが利用可能か確認
docker compose exec dev python -c "import requests; print('✅ パッケージが永続化されています')"
```

**注意**: 上記の方法は一時的なテストです。パッケージを永続化するには、requirements.txtに追加してイメージを再ビルドする必要があります。詳細な手順は[correct-package-installation.md](correct-package-installation.md)をご覧ください。

## トラブルシューティング

### よくある問題と解決方法

#### 1. "docker: command not found"

**原因**: Dockerがインストールされていない、またはPATHが通っていない

**解決方法**:
- 上記のDockerインストール手順を実行
- ターミナルを再起動
- Docker Desktopが起動しているか確認

#### 2. "Permission denied"エラー

**原因**: Dockerの実行権限がない

**解決方法**:
```bash
# Linuxの場合、ユーザーをdockerグループに追加
sudo usermod -aG docker $USER
# ログアウトして再ログイン
```

#### 3. ビルドが失敗する

**原因**: ネットワーク問題、またはDockerの設定問題

**解決方法**:
```bash
# キャッシュをクリアして再ビルド
docker compose build --no-cache

# システムのクリーンアップ
docker system prune
```

#### 4. VS Codeでコンテナが開かない

**原因**: Dev Containers拡張機能の問題

**解決方法**:
1. Dev Containers拡張機能がインストールされているか確認
2. VS Codeを再起動
3. コマンドパレットから"Dev Containers: Rebuild Container"を実行

#### 5. Jupyterノートブックにアクセスできない

**原因**: ポートフォワーディングの問題

**解決方法**:
```bash
# ポート番号を指定してJupyterを起動
jupyter notebook --ip=0.0.0.0 --port=8888 --no-browser --allow-root

# ブラウザで http://localhost:8888 にアクセス
# トークンが必要な場合は、ターミナルに表示されるURLをコピー
```

#### 6. パッケージインストールが永続化されない

**原因**: システム全体にインストールしようとしている

**解決方法**:
```bash
# コンテナ内で --user フラグを使用
docker compose exec dev pip install --user package-name

# 環境変数が設定されているか確認
docker compose exec dev bash -c "echo \$PATH"
# /home/developer/.local/bin が含まれているはず

# 永続化には requirements.txt を使用
echo "package-name>=version" >> requirements.txt
docker compose build --no-cache
docker compose up -d
```

**推奨**: パッケージの永続化には requirements.txt を使用してください。詳細は[correct-package-installation.md](correct-package-installation.md)をご覧ください。

### デバッグのためのコマンド

```bash
# コンテナの状態確認
docker compose ps

# コンテナのログ確認
docker compose logs dev

# ボリュームの確認
docker volume ls
docker volume inspect claude-code-ml-env_ml-data

# ネットワークの確認
docker network ls

# コンテナ内のプロセス確認
docker compose exec dev ps aux
```

## カスタマイズ

### 追加パッケージの事前インストール

推奨方法は `requirements.txt` ファイルを使用することです:

1. **requirements.txtを作成または編集**:
```txt
numpy>=1.24.0
pandas>=2.0.0
matplotlib>=3.7.0
jupyter>=1.0.0
scikit-learn>=1.3.0
torch>=2.0.0
tensorflow>=2.13.0
```

2. **Dockerfileで自動読み込み**:
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

詳細な手順は[correct-package-installation.md](correct-package-installation.md)を参照してください。

### システムパッケージの追加

```dockerfile
# システムパッケージのインストール
RUN apt-get update && apt-get install -y \
    build-essential \
    git \
    curl \
    sudo \
    vim \  # 追加パッケージ
    && rm -rf /var/lib/apt/lists/*
```

### 環境変数の設定

`docker-compose.yml`を編集:

```yaml
services:
  dev:
    # ... 他の設定
    environment:
      - CUSTOM_ENV_VAR=value
      - ANOTHER_VAR=another_value
```

### ポート番号の変更

```yaml
services:
  dev:
    # ... 他の設定
    ports:
      - "8888:8888"  # Jupyter用
      - "8000:8000"  # その他のWebアプリ用
```

## パフォーマンス最適化

### ビルド時間の短縮

1. `.dockerignore`ファイルを作成して不要なファイルを除外
2. 多段階ビルドの使用
3. パッケージのキャッシュ活用

### リソース使用量の調整

Docker Desktopの設定で以下を調整:
- CPU数
- メモリ使用量
- ディスク使用量

## セキュリティ

### 基本的なセキュリティ対策

1. **非rootユーザーの使用**: `developer`ユーザーで実行
2. **最小権限の原則**: 必要最小限の権限のみ付与
3. **定期的な更新**: ベースイメージとパッケージの定期更新

### 機密情報の管理

```bash
# 環境変数で機密情報を管理
docker compose run --rm -e SECRET_KEY=your-secret dev python your-script.py

# .envファイルの使用（Gitに含めない）
echo "SECRET_KEY=your-secret" > .env
# docker-compose.ymlでenv_fileを指定
```

## サポートとコミュニティ

- **Issues**: [GitHub Issues](https://github.com/yourusername/claude-code-ml-env/issues)
- **Discussions**: [GitHub Discussions](https://github.com/yourusername/claude-code-ml-env/discussions)
- **Wiki**: [GitHub Wiki](https://github.com/yourusername/claude-code-ml-env/wiki)

問題報告の際は以下の情報を含めてください:
- OS情報 (`uname -a`)
- Dockerバージョン (`docker --version`)
- エラーメッセージの全文
- 実行したコマンド
- 期待した動作vs実際の動作