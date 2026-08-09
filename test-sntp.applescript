-- SNTP実行テスト
try
	-- 管理者権限なしで実行テスト（出力確認用）
	set result1 to do shell script "sntp ntp.nict.jp"
	display notification ("sntp実行成功: " & result1) with title "テスト"

on error errMsg number errNum
	display notification ("sntp実行失敗: " & errMsg) with title "テスト"
end try
