# Claude Code ML Environment

![Docker](https://img.shields.io/badge/docker-ready-brightgreen.svg)
![Python](https://img.shields.io/badge/python-3.11-blue.svg)

Claude Codeが自律的にPython機械学習開発環境を構築するためのテンプレートリポジトリです。Docker + Development Containersを使用して、永続的で独立した開発環境を簡単に作成できます。
Claude Codeでこのディレクトリを開いて「このリポジトリの内容を確認して，趣旨に沿った環境構築してください．」と伝えてください。

## クイックスタート

### 前提条件

- [Docker Desktop](https://www.docker.com/products/docker-desktop/) がインストールされていること
- Claude Code または任意のターミナル環境

### Cluade Codeを用いた環境構築方法
Claude Codeでこのディレクトリを開いて「このリポジトリの内容を確認して，趣旨に沿った環境構築してください．」と伝えてください。

### 環境構築方法

```bash
# 1. リポジトリをクローン
git clone https://github.com/yourusername/claude-code-ml-env.git
cd claude-code-ml-env

# 2. Docker環境をビルド
docker compose build

# 3. コンテナを起動
docker compose up -d

# 4. 環境に入る
docker compose exec dev bash

# 5. 動作確認
python -c "import numpy, pandas, matplotlib, sklearn; print('✅ 環境準備完了!')"
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
claude-code-ml-env/
├── .devcontainer/          # Development Container設定
├── scripts/                # 環境初期化スクリプト
├── examples/               # サンプルコード・設定ファイル
├── docs/                   # ドキュメント
├── articles/               # 実践記事・開発体験記録
├── src/                    # ソースコード
├── data/                   # データファイル
├── models/                 # 機械学習モデル
└── README.md              # このファイル
```

詳細な構造については[プロジェクト構造ガイド](docs/setup-guide.md#プロジェクト構造)を参照してください。

## 特徴

- **Claude Code対応**: AIが自律的に環境を構築・管理可能
- **永続化**: ファイルとパッケージが永続的に保存
- **独立性**: プロジェクトごとに完全に独立した環境
- **即利用可能**: 機械学習に必要なパッケージを事前インストール
- **カスタマイズ可能**: 設定ファイルで簡単にカスタマイズ

## パッケージ管理

### 基本パッケージ
- **Python 3.11**: 最新の安定版Python
- **numpy**: 数値計算ライブラリ
- **pandas**: データ分析ライブラリ  
- **matplotlib**: グラフ描画ライブラリ
- **jupyter**: ノートブック環境
- **scikit-learn**: 機械学習ライブラリ

詳細なパッケージリストと追加インストール方法は[パッケージ管理ガイド](docs/setup-guide.md#パッケージ管理)を参照してください。

## 使用方法

### クイックスタート

```bash
# 環境起動
docker compose up -d

# 環境に入る
docker compose exec dev bash

# 環境停止（データは保持される）
docker compose down
```

詳細な使用方法とワークフローについては[使用方法ガイド](docs/setup-guide.md#使用方法)を参照してください。

## ドキュメント

詳細な情報は以下のドキュメントを参照してください：

- **[セットアップガイド](docs/setup-guide.md)**: 詳細なインストールと設定手順
- **[実装記録](docs/implementation-log.md)**: 環境構築の技術的詳細と学習内容
- **[トラブルシューティング](docs/setup-guide.md#トラブルシューティング)**: よくある問題と解決方法

## 実践記事

本環境を使用した実際の開発体験と技術検証記事：

- **[環境構築実践記録](articles/1_make_environment.md)**: Claude Codeによる自律的なPython機械学習開発環境の構築実践記録
- **[MNIST CNN開発体験](articles/2_mnist_cnn_implementation.md)**: 実際の機械学習プロジェクト（MNIST画像分類CNN）の開発実践記録

## カスタマイズ・テスト

環境のカスタマイズ方法と動作確認手順については以下を参照してください：

- **[カスタマイズガイド](docs/setup-guide.md#カスタマイズ)**: Dockerfileとパッケージの追加方法
- **[テスト手順](docs/setup-guide.md#動作確認)**: 環境の動作確認とトラブルシューティング

## タグ

`machine-learning` `docker` `python` `claude-code` `development-environment` `data-science` `jupyter` `devcontainers`
