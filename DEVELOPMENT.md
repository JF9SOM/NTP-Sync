# NTP-Sync 開発ノート

## プロジェクト概要

macOSでNTPサーバーへの強制時刻同期をワンクリックで実行するアプリケーション。

## 実装完了事項

### 1. ✅ AppleScript実装
- `NTP-Sync.applescript` - メインのAppleScriptコード
- 管理者権限でのsntp実行
- エラーハンドリング（タイムアウト、ホスト名解決失敗など）
- 通知センターへの結果表示

### 2. ✅ アプリケーション生成
- `osacompile` でコンパイル
- `NTP-Sync.app` - 実行可能なmacOSアプリケーション
- ユニバーサルバイナリ対応（Intel + Apple Silicon）

### 3. ✅ ドキュメント
- `README.md` - ユーザー向けドキュメント
- `test-ntp-sync.sh` - テスト用スクリプト
- `DEVELOPMENT.md` - このファイル

## ファイル構成

```
NTP-Sync/
├── CLAUDE.md                          # プロジェクト要件
├── README.md                          # ユーザー向けドキュメント
├── DEVELOPMENT.md                     # 開発ノート（このファイル）
├── NTP-Sync.applescript               # AppleScript ソースコード
├── NTP-Sync.app/                      # コンパイル済みアプリケーション
│   └── Contents/
│       ├── MacOS/applet               # 実行可能バイナリ
│       ├── Resources/
│       ├── Info.plist                 # アプリケーション情報
│       └── ...
└── test-ntp-sync.sh                   # テスト用スクリプト
```

## 使用方法

### ユーザー向け
```bash
# アプリをダブルクリックして実行
open NTP-Sync.app
```

### 開発者向け
```bash
# ソースコードを編集してアプリを再構築
osacompile -o NTP-Sync.app NTP-Sync.applescript

# テストスクリプトで動作確認
./test-ntp-sync.sh
```

## 機能詳細

### 実行処理
1. パスワード入力ダイアログを表示（管理者権限取得）
2. `sntp -sS ntp.nict.jp` を実行
3. NTP出力を解析してオフセット情報を抽出
4. 通知センターに結果を表示

### エラー処理
| エラー | 対応メッセージ |
|--------|-------------|
| パスワードキャンセル | 「管理者パスワードが必要です。キャンセルされました。」 |
| ネットワークタイムアウト | 「NTPサーバーに接続できません。ネットワークの接続を確認してください。」 |
| ホスト名解決失敗 | 「NTPサーバーが見つかりません」 |
| 権限エラー | 「管理者権限の実行に失敗しました。」 |

## テスト環境

### 動作確認済み環境
- macOS (Intel / Apple Silicon対応)
- ネットワーク接続環境

### テスト方法

#### 1. 正常系テスト
```bash
open NTP-Sync.app
# パスワードを入力して実行
# 通知センターに同期完了メッセージが表示される
```

#### 2. オフセット取得テスト
```bash
# オフセット情報の確認
sntp ntp.nict.jp

# 出力形式: "-0.021111 +/- 0.022104 ntp.nict.jp ..."
# アプリはこのオフセット値をミリ秒に変換して表示
```

#### 3. エラーハンドリングテスト
```bash
# ネットワーク接続を切ってアプリを実行
open NTP-Sync.app
# エラーメッセージが通知センターに表示される
```

## 今後の改善案

### 短期（優先度：高）
1. **アプリアイコン追加**
   - 通知アイコンと区別可能なアイコンを作成
   - `Contents/Resources/applet.icns` に配置

2. **バージョン情報**
   - `Contents/Info.plist` にバージョン番号を追加
   - アプリの説明を追加

3. **詳細なオフセット表示**
   - 同期前後の時刻をログに記録
   - より詳細なエラー情報を表示

### 中期（優先度：中）
1. **設定機能**
   - NTPサーバーアドレスをユーザーが変更可能に
   - 同期スケジュール設定

2. **ログ機能**
   - 同期履歴をログファイルに記録
   - デバッグ情報の記録

3. **UI改善**
   - Swift/SwiftUI版への移行検討
   - より詳細な同期情報ダイアログ

### 長期（優先度：低）
1. **複数NTPサーバー対応**
   - フェイルオーバー機能
   - ラウンドロビン同期

2. **クロスプラットフォーム対応**
   - Linux対応
   - Windows対応

## 技術仕様

### 使用技術
- **言語**: AppleScript
- **コンパイル**: macOS osacompile ユーティリティ
- **形式**: macOS .app バンドル形式
- **依存関係**: macOS組み込みコマンド（sntp）

### AppleScript実装のポイント

1. **管理者権限取得**
   ```applescript
   do shell script "command" with administrator privileges
   ```

2. **通知センター**
   ```applescript
   display notification "message" with title "title"
   ```

3. **テキスト処理**
   ```applescript
   set AppleScript's text item delimiters to " "
   set tokens to text items of text
   ```

## ビルド・デプロイ

### ビルド手順
```bash
cd /Users/sadatoshikoike/NTP-Sync
osacompile -o NTP-Sync.app NTP-Sync.applescript
```

### 配布方法
```bash
# Applications フォルダにコピー
cp -r NTP-Sync.app ~/Applications/

# または、Zipファイルで配布
zip -r NTP-Sync.zip NTP-Sync.app
```

## トラブルシューティング

### 問題: パスワードダイアログが表示されない
**原因**: セキュリティ設定
**解決**: システム設定 > セキュリティとプライバシー を確認

### 問題: 通知が表示されない
**原因**: 通知センター設定
**解決**: システム設定 > 通知 で通知を有効化

### 問題: NTPサーバーに接続できない
**原因**: ネットワーク接続または ファイアウォール
**解決**: 
```bash
ping ntp.nict.jp
sntp ntp.nict.jp  # 直接接続テスト
```

## 参考資料

- [SNTP man page](https://man7.org/linux/man-pages/man1/sntp.1.html)
- [NICTの日本標準時サービス](https://www.nict.go.jp/)
- [AppleScript Language Guide](https://developer.apple.com/library/archive/documentation/AppleScript/Conceptual/AppleScriptLangGuide/introduction/ASLR_intro.html)

## ライセンス

（GitHubのリポジトリに記載予定）

## 連絡先

jf9som@gmail.com
