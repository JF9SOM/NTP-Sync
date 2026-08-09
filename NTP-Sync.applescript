-- NTP-Sync: macOS向けNTP強制時刻同期アプリ
-- ダイアログで結果を表示するバージョン

property NTP_SERVER : "ntp.nict.jp"

on run
	try
		-- ユーザーに実行確認
		display dialog "NTP強制同期を実行します。" & return & "サーバー: " & NTP_SERVER buttons {"キャンセル", "実行"} default button "実行"

		-- sntp実行（管理者権限で実行）
		set cmdResult to do shell script "/usr/bin/sntp -sS " & NTP_SERVER with administrator privileges

		-- 成功時：結果をダイアログで表示
		display alert "時刻同期完了" message cmdResult buttons {"OK"}

	on error errMsg number errNum
		-- エラー処理
		if errNum = -128 then
			display alert "キャンセル" message "パスワードダイアログがキャンセルされました。"
		else
			display alert "エラー" message ("同期に失敗しました。" & return & return & errMsg) buttons {"OK"}
		end if
	end try
end run
