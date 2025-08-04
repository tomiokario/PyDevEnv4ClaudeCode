# Python Development Environment

![Docker](https://img.shields.io/badge/docker-ready-brightgreen.svg)
![Python](https://img.shields.io/badge/python-3.11-blue.svg)

**開発AIエージェント（Claude Code）が自律的に環境をメンテナンスしながら開発作業を行うための専用Python開発環境**です。Docker + Development Containersを使用して、AIエージェントが必要に応じてパッケージを追加・削除し、環境を最適化しながら開発できる軽量で拡張しやすい環境を提供します。

## 🤖 Claude Codeでの使用方法

このリポジトリは、開発AIエージェントであるClaude Codeが自律的に環境をメンテナンスしながら開発作業を行うことを目的として設計されています。

### Claude Codeに開発してもらう方法

Claude Codeでこのディレクトリを開いて、以下のように指示してください：

```
このリポジトリは、あなた（Claude Code）が自律的に開発作業を行うためのPython開発環境です。
必要に応じてパッケージをインストール・管理しながら、[具体的な開発タスク]を実装してください。

環境の特徴：
- 軽量で拡張しやすい構成
- パッケージ管理スクリプト（/scripts/install-packages.sh）が利用可能
- 作業内容は自動的に永続化される
```

### Claude Codeが環境をメンテナンスする方法

Claude Codeは以下のコマンドで環境を管理できます：

```bash
# パッケージを追加してrequirements.txtに記録
docker compose exec dev /scripts/install-packages.sh add numpy pandas

# 一時的なテスト用インストール
docker compose exec dev /scripts/install-packages.sh install requests

# 不要なパッケージを削除
docker compose exec dev /scripts/install-packages.sh remove old-package

# 現在のパッケージ状況を確認
docker compose exec dev /scripts/install-packages.sh list

# 変更を永続化（イメージ再ビルド）
docker compose exec dev /scripts/install-packages.sh rebuild
```

### 自律的な開発ワークフロー

1. **環境の確認**: `docker compose exec dev /scripts/install-packages.sh list`
2. **必要なパッケージの追加**: `add`コマンドでrequirements.txtに記録
3. **開発作業**: `src/`ディレクトリで作業
4. **テスト・確認**: `docker compose exec dev python src/your_script.py`
5. **永続化**: 必要に応じて`rebuild`コマンドでイメージ更新

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

- **🤖 Claude Code完全対応**: AIエージェントが自律的に環境構築・パッケージ管理・開発作業を実行
- **🔧 自律的メンテナンス**: 開発中に必要なパッケージを自動で追加・管理し、環境を最適化
- **⚡ 軽量設計**: 必要最小限のパッケージから開始、必要に応じて拡張
- **🔄 作業中の拡張**: 開発しながらリアルタイムでパッケージを追加・削除可能
- **🏗️ 独立環境**: プロジェクトごとに完全分離された環境でクリーンな開発
- **📖 理解しやすい**: シンプルな構成でAIエージェントも人間も理解・カスタマイズが簡単

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

Claude Codeによる自律的な開発環境メンテナンスの実践記録：

- **[環境構築実践記録](articles/1_make_environment.md)**: Claude Codeが自律的にPython開発環境を構築・最適化した実践記録
- **[自律的開発実践](articles/2_mnist_cnn_implementation.md)**: Claude Codeが環境をメンテナンスしながら開発作業を行った実例
- **AIエージェントによる環境管理**: パッケージの自動追加・削除、要件に応じた環境最適化の事例

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

`python` `docker` `claude-code` `development-environment` `devcontainers` `lightweight` `ai-agent` `autonomous-development` `package-management` `self-maintaining`