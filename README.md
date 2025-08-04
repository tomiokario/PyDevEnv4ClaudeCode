# Python Development Environment

![Docker](https://img.shields.io/badge/docker-ready-brightgreen.svg)
![Python](https://img.shields.io/badge/python-3.11-blue.svg)

Claude Codeが自律的にPython開発環境を構築するためのテンプレートリポジトリです。Docker + Development Containersを使用して、軽量で拡張しやすい開発環境を簡単に作成できます。

## クイックスタート

### 前提条件

- [Docker Desktop](https://www.docker.com/products/docker-desktop/) がインストールされていること
- Claude Code または任意のターミナル環境

### 環境構築方法

```bash
# 1. リポジトリをクローン
git clone https://github.com/yourusername/python-dev-env.git
cd python-dev-env

# 2. Docker環境をビルド
docker compose build

# 3. コンテナを起動
docker compose up -d

# 4. 環境に入る
docker compose exec dev bash

# 5. 動作確認（コンテナ内で実行）
python -c "import requests; print('✅ 環境準備完了!')"
```

### VS Code Development Containers使用の場合

```bash
# VS Codeで開く
code .

# コマンドパレット (Cmd/Ctrl + Shift + P) で実行:
# "Dev Containers: Reopen in Container"
```

## プロジェクト構造

```
python-dev-env/
├── .devcontainer/          # Development Container設定
│   └── Dockerfile          # コンテナ定義（requirements.txt対応）
├── scripts/                # 環境管理スクリプト
│   ├── setup.sh           # 初期設定スクリプト
│   └── install-packages.sh # パッケージ管理ヘルパー
├── docs/                   # ドキュメント
│   ├── setup-guide.md     # セットアップガイド
│   ├── correct-package-installation.md # パッケージ管理方法
│   └── implementation-log.md # 実装記録
├── articles/               # 実践記事・開発体験記録
├── src/                    # ソースコード
├── requirements.txt        # Pythonパッケージ依存関係
├── docker-compose.yml      # Docker Compose設定
└── README.md              # このファイル
```

詳細な構造については[プロジェクト構造ガイド](docs/setup-guide.md#プロジェクト構造)を参照してください。

## 特徴

- **Claude Code対応**: AIが自律的に環境を構築・管理可能
- **軽量**: 必要最小限のパッケージのみをインストール
- **拡張可能**: 作業しながら必要なパッケージを簡単追加
- **独立性**: プロジェクトごとに完全に独立した環境
- **理解しやすい**: シンプルな構成で理解・カスタマイズが容易

## パッケージ管理

### 基本パッケージ（requirements.txt）
- **Python 3.11**: 最新の安定版Python
- **requests**: HTTPライブラリ（よく使用される基本ライブラリとして含める）

### よくあるパッケージ（コメントアウト済み）
- **numpy**: 数値計算ライブラリ
- **pandas**: データ分析ライブラリ  
- **matplotlib**: グラフ描画ライブラリ

必要に応じてコメントアウトを外すか、パッケージ管理スクリプトで追加してください。

### パッケージの追加方法

```bash
# 方法1: パッケージ管理スクリプトを使用（推奨）
docker compose exec dev /scripts/install-packages.sh add numpy pandas

# 方法2: 一時的にインストール
docker compose exec dev /scripts/install-packages.sh install beautifulsoup4

# 方法3: パッケージを削除
docker compose exec dev /scripts/install-packages.sh remove old-package

# 方法4: インストール済みパッケージを確認
docker compose exec dev /scripts/install-packages.sh list
```

**重要**: ホストマシンでの`pip install`は避けてください。必ず`docker compose exec dev`を使用してコンテナ内で実行してください。

詳細は[正しいパッケージインストール方法](docs/correct-package-installation.md)を参照してください。

## 使用方法

### 基本的なワークフロー

```bash
# 1. 環境起動
docker compose up -d

# 2. コンテナ内で作業
docker compose exec dev bash

# 3. Pythonスクリプトを実行（コンテナ内）
docker compose exec dev python src/your_script.py

# 4. Pythonインタープリターを起動（コンテナ内）
docker compose exec dev python

# 5. 環境停止（データは保持される）
docker compose down

# 6. 環境の完全削除
docker compose down
```

### 環境の検証

```bash
# パッケージ一覧を確認（コンテナ内）
docker compose exec dev /scripts/install-packages.sh list
```

詳細な使用方法とワークフローについては[使用方法ガイド](docs/setup-guide.md#使用方法)を参照してください。

## ドキュメント

詳細な情報は以下のドキュメントを参照してください：

- **[セットアップガイド](docs/setup-guide.md)**: 詳細なインストールと設定手順
- **[正しいパッケージ管理](docs/correct-package-installation.md)**: Dockerコンテナでの正しいパッケージ管理方法
- **[実装記録](docs/implementation-log.md)**: 環境構築の技術的詳細と学習内容
- **[トラブルシューティング](docs/setup-guide.md#トラブルシューティング)**: よくある問題と解決方法

## 実践記事

本環境を使用した実際の開発体験と技術検証記事：

- **[環境構築実践記録](articles/1_make_environment.md)**: Claude Codeによる自律的なPython開発環境の構築実践記録
- **[開発実践体験](articles/2_mnist_cnn_implementation.md)**: 実際の開発プロジェクトでの活用例

## トラブルシューティング

### Dockerが起動しない場合
```bash
# Docker Desktopが起動していることを確認
docker info

# Docker Desktopを再起動
# macOS/Windows: Docker Desktopアプリを再起動
```

### パッケージが見つからない場合
```bash
# コンテナを再ビルド
docker compose down
docker compose build --no-cache
docker compose up -d

# パッケージリストを確認
docker compose exec dev /scripts/install-packages.sh list
```

### 権限エラーが発生する場合
```bash
# developerユーザーとして実行
docker compose exec -u developer dev bash
```

## カスタマイズ・テスト

環境のカスタマイズ方法と動作確認手順については以下を参照してください：

- **[カスタマイズガイド](docs/setup-guide.md#カスタマイズ)**: Dockerfileとパッケージの追加方法
- **[テスト手順](docs/setup-guide.md#動作確認)**: 環境の動作確認とトラブルシューティング

## タグ

`python` `docker` `claude-code` `development-environment` `devcontainers` `lightweight`