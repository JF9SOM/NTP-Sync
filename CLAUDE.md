# NTP-Sync

macOSでNTPサーバーへの強制時刻同期をワンクリックで実行するアプリ。
屋外での4G Wi-Fiルーター経由のアマチュア無線運用(WSJT-X / FT8等)時、
Macの時計ズレによるデコード失敗を防ぐことが目的。

## 背景

- 屋外の4G回線環境で `time.apple.com` へのNTP同期がタイムアウトすることがある
- `ntp.nict.jp` (NICTの日本標準時サーバー)の方が経路が安定しており推奨
- FT8等のデジタルモードは時刻ズレに極めて敏感(±1秒程度でデコード不能)
- 毎回ターミナルで `sudo sntp -sS ntp.nict.jp` を打つのは手間なのでアプリ化したい

## 要件

- **形式**: ダブルクリックで起動できる macOS アプリ(.app)。Dock やデスクトップに置いて使う
- **動作**: `sudo sntp -sS ntp.nict.jp` を管理者権限で実行し、システム時刻を強制同期する
  - 管理者権限の取得はGUIのパスワードダイアログで行う(ターミナル不要)
- **結果表示**: 同期成功時はオフセット(ズレ量)を通知センターに表示
- **エラー処理**: 同期失敗時(タイムアウト等)もその旨を通知センターに表示する
- **NTPサーバー**: `ntp.nict.jp` を既定値とする(将来的に変更しやすいよう定数化しておくと良い)

## 実装方針(候補)

- AppleScript (`osacompile` で `.app` 化) を軸に検討。Automatorより軽量でコード管理しやすい
- `do shell script "sntp -sS ntp.nict.jp" with administrator privileges` でパスワードダイアログ+sudo実行
- 通知は `display notification` (AppleScript) または `osascript -e 'display notification ...'` で実装
- Swift/SwiftUIでの実装も選択肢だが、まずはシンプルなAppleScript版で動作確認を優先

## 開発環境

- 本アプリはMac本体のGUIアプリのため、GPD MicroPC2からのSSH経由ではなく
  **Mac本体のターミナルで直接Claude Codeを起動**して作業する
- 完成後はGitHubの JF9SOM リポジトリに保存する想定

## 動作確認の観点

- 通常のWi-Fi環境、および4Gルーター経由の環境の両方でテストする
- 同期前後の時刻オフセットが `sntp` の出力と一致することを確認
- パスワードダイアログのキャンセル時、ネットワーク不通時など異常系の通知も確認
