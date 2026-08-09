-- NTP-Sync: パスワード不要バージョン
-- 事前に sudoers で /usr/bin/sntp を NOPASSWD に設定している必要があります

property NTP_SERVER : "ntp.nict.jp"

on run
	try
		-- ユーザーに実行確認
		display dialog "NTP強制同期を実行します。" & return & "サーバー: " & NTP_SERVER buttons {"キャンセル", "実行"} default button "実行"

		-- sntp実行（管理者権限不要 - sudoers設定済み）
		set cmdResult to do shell script "sudo /usr/bin/sntp -sS " & NTP_SERVER

		-- 成功時：結果をダイアログで表示
		display alert "時刻同期完了" message cmdResult buttons {"OK"}

	on error errMsg number errNum
		-- エラー処理
		if errNum = -128 then
			display alert "キャンセル" message "実行がキャンセルされました。"
		else
			display alert "エラー" message ("同期に失敗しました。" & return & return & errMsg) buttons {"OK"}
		end if
	end try
end run
