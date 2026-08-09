#!/bin/bash
# NTP-Sync テストスクリプト

echo "=========================================="
echo "NTP-Sync テスト開始"
echo "=========================================="
echo ""

# テスト1: NTPサーバーへの接続確認
echo "[テスト1] NTPサーバー接続確認"
echo "コマンド: sntp ntp.nict.jp"
sntp ntp.nict.jp
echo ""

# テスト2: 同期前後の時刻確認
echo "[テスト2] 現在の時刻"
echo "同期前: $(date '+%Y-%m-%d %H:%M:%S')"
echo ""

# テスト3: NTP-Syncアプリの実行
echo "[テスト3] NTP-Sync アプリを実行します"
echo "パスワードダイアログが表示されます"
echo "--------"

open "$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/NTP-Sync.app"

echo "--------"
echo "アプリが起動しました。通知センターを確認してください。"
echo ""

# テスト4: 同期後の時刻確認
sleep 2
echo "[テスト4] 同期後の時刻"
echo "同期後: $(date '+%Y-%m-%d %H:%M:%S')"
echo ""

echo "=========================================="
echo "テスト完了"
echo "=========================================="
