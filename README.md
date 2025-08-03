# Claude Code ML Environment

![Docker](https://img.shields.io/badge/docker-ready-brightgreen.svg)
![Python](https://img.shields.io/badge/python-3.11-blue.svg)

Claude Codeが自律的にPython機械学習開発環境を構築するためのテンプレートリポジトリです。Docker + Development Containersを使用して、永続的で独立した開発環境を簡単に作成できます。
Claude Codeでこのディレクトリを開いて「このリポジトリの内容を確認して，趣旨に沿った環境構築してください．」と伝えてください。

## 🚀 クイックスタート

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

## 📁 プロジェクト構造

```
claude-code-ml-env/
├── .devcontainer/
│   ├── devcontainer.json    # VS Code Development Container設定
│   └── Dockerfile           # コンテナ構築設定
├── scripts/
│   └── setup.sh            # 環境初期化スクリプト
├── examples/               # サンプルコード・設定ファイル
│   ├── .devcontainer/      # 検証済み設定ファイル
│   ├── scripts/           # 検証済みスクリプト
│   └── docker-compose.yml # 検証済みDocker Compose設定
├── docs/                   # ドキュメント
│   ├── setup-guide.md     # 詳細セットアップガイド
│   └── implementation-log.md # 実装記録
├── src/                    # ソースコード
├── data/                   # データファイル
├── models/                 # 機械学習モデル
└── README.md              # このファイル
```

## ✨ 特徴

- **🤖 Claude Code対応**: AIが自律的に環境を構築・管理可能
- **🔒 永続化**: ファイルとパッケージが永続的に保存
- **🏗️ 独立性**: プロジェクトごとに完全に独立した環境
- **📦 即利用可能**: 機械学習に必要なパッケージを事前インストール
- **🔧 カスタマイズ可能**: 設定ファイルで簡単にカスタマイズ

## 📚 インストール済みパッケージ

### 基本パッケージ
- **Python 3.11**: 最新の安定版Python
- **numpy**: 数値計算ライブラリ
- **pandas**: データ分析ライブラリ  
- **matplotlib**: グラフ描画ライブラリ
- **jupyter**: ノートブック環境
- **scikit-learn**: 機械学習ライブラリ

### 追加インストール例
```bash
# コンテナ内で実行
pip install --user torch tensorflow transformers
pip install --user seaborn plotly opencv-python
pip install --user pymunk pybullet  # 物理シミュレーション
```

## 🛠️ 使用方法

### 基本的な開発ワークフロー

```bash
# 1. 環境に入る
docker compose exec dev bash

# 2. Jupyterノートブックを起動
jupyter notebook --ip=0.0.0.0 --port=8888 --no-browser

# 3. Pythonスクリプトを実行
python src/your_script.py

# 4. パッケージを追加インストール
pip install --user your-package

# 5. 作業終了時
exit
docker compose down  # 環境停止（データは保持される）

# 6. 作業再開時
docker compose up -d  # 環境再開
```

### データの永続化

- `/workspace` : プロジェクトファイル（ローカルと同期）
- `/data` : データファイル（永続ボリューム）
- `/cache` : キャッシュファイル（永続ボリューム）

## 📖 ドキュメント

詳細な情報は以下のドキュメントを参照してください：

- **[セットアップガイド](docs/setup-guide.md)**: 詳細なインストールと設定手順
- **[実装記録](docs/implementation-log.md)**: 環境構築の技術的詳細と学習内容
- **[トラブルシューティング](docs/setup-guide.md#トラブルシューティング)**: よくある問題と解決方法

## 🔧 カスタマイズ

### Dockerfileのカスタマイズ

追加のシステムパッケージが必要な場合：

```dockerfile
# .devcontainer/Dockerfile に追加
RUN apt-get update && apt-get install -y \
    your-system-package \
    && rm -rf /var/lib/apt/lists/*
```

### Pythonパッケージの事前インストール

```dockerfile
# .devcontainer/Dockerfile のpip installセクションに追加
RUN pip install --user --no-cache-dir \
    numpy pandas matplotlib jupyter \
    scikit-learn \
    your-additional-package
```

## 🧪 動作確認

### 環境のテスト

```bash
# 永続性の確認
echo "test" > /workspace/test.txt
docker compose restart
cat /workspace/test.txt  # "test" が表示されるはず

# パッケージの確認
python -c "import numpy, pandas, matplotlib, sklearn; print('All packages imported successfully')"
```
   - 実行したコマンド

## 🏷️ タグ

`machine-learning` `docker` `python` `claude-code` `development-environment` `data-science` `jupyter` `devcontainers`
