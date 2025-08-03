# Examples Directory

このディレクトリには、検証済みの設定ファイルとサンプルコードが含まれています。

## 📁 構成

- **`.devcontainer/`**: 検証済みのDevelopment Container設定
- **`scripts/`**: 検証済みの初期化スクリプト
- **`docker-compose.yml`**: 検証済みのDocker Compose設定

## 🧪 検証内容

これらのファイルは以下の環境で動作確認済みです：

- **Docker version**: 28.3.2, build 578ccf6
- **Docker Compose version**: v2.38.2-desktop.1
- **ホストOS**: macOS (Darwin 23.6.0)
- **Python**: 3.11
- **検証日**: 2025-08-04

## ✅ 確認済み機能

- ✅ ファイルの永続化
- ✅ パッケージインストールの永続化
- ✅ コンテナ再起動後の状態維持
- ✅ PyTorchなど大型パッケージのインストール
- ✅ プロジェクト独立性
- ✅ Jupyter Notebook環境

## 🚀 使用方法

### 設定ファイルの使用

これらの設定ファイルをプロジェクトルートにコピーして使用してください：

```bash
# プロジェクトルートで実行
cp examples/.devcontainer/* .devcontainer/
cp examples/scripts/* scripts/
cp examples/docker-compose.yml .
```

### カスタマイズ

必要に応じて以下をカスタマイズしてください：

1. **Dockerfile**: 追加パッケージのインストール
2. **devcontainer.json**: VS Code拡張機能の追加  
3. **setup.sh**: 初期化時の追加処理
4. **docker-compose.yml**: ポートマッピングや環境変数の追加

## 📋 設定ファイルの詳細

### .devcontainer/devcontainer.json

VS Code Development Containersの設定ファイル。以下の機能を提供：

- Python 3.11環境
- 基本的な機械学習パッケージ
- 永続ボリュームマウント
- 開発用ユーザー設定

### .devcontainer/Dockerfile

コンテナイメージの構築設定。以下を含む：

- Python 3.11 slim baseimage
- システムパッケージ（git, curl, build-essential等）
- 開発用ユーザー（developer）の作成
- 基本的なPythonパッケージの事前インストール

### scripts/setup.sh

コンテナ初期化時に実行されるスクリプト：

- ディレクトリ構造の作成
- Git設定
- 環境変数とエイリアスの設定

### docker-compose.yml

Docker Composeによるマルチコンテナ管理：

- 開発コンテナの定義
- 永続化ボリューム設定
- ネットワーク設定

## 🔧 トラブルシューティング

これらの設定で問題が発生した場合：

1. Dockerのバージョンを確認
2. [setup-guide.md](../docs/setup-guide.md)のトラブルシューティングセクションを参照
3. [Issues](https://github.com/yourusername/claude-code-ml-env/issues)で既知の問題を確認