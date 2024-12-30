@echo off
chcp 65001 >nul

set oj=oj
set backup_file=
set restore_db=true

@REM ---------------------------------------- 處理參數 ----------------------------------------
:process_args
if "%~1"=="" goto end_args
if "%~1"=="-t" (
    set oj=oj_test
) else if "%~1"=="--test" (
    set oj=oj_test
) else if "%~1"=="--no-db" (
    set restore_db=false
) else (
    set backup_file=%~1
)
shift
goto process_args
:end_args

if "%oj%"=="oj" (
    set server_name=正式伺服器
) else (
    set server_name=測試伺服器
)

@REM ---------------------------------------- 檢查是否設置了備份檔案名稱 ----------------------------------------
if "%backup_file%"=="" (
    echo 請提供要復原的備份檔案名稱
    exit /b 1
)

@REM echo OJ=%oj%
echo 復原 %backup_file%
for %%A in ("%backup_file%") do set "backup_file_name=%%~nxA"

@REM ---------------------------------------- 設定遠端伺服器復原腳本路徑 ----------------------------------------
set ssh_oj_restore_script_path=~/OnlineJudge/OnlineJudgeDeploy/backup/restore.sh

@REM ---------------------------------------- 使用 SCP 將備份檔案從本地複製到遠端伺服器 ----------------------------------------
echo 複製備份檔案到「%server_name%」
scp "%backup_file%" %oj%:/tmp/%backup_file_name%

@REM ---------------------------------------- 執行遠端復原腳本 ----------------------------------------
if "%restore_db%"=="true" (
    echo 「%server_name%」執行復原腳本（包含資料庫）
    ssh -t %oj% "bash %ssh_oj_restore_script_path% /tmp/%backup_file_name%"
) else (
    echo 「%server_name%」執行復原腳本（不包含資料庫）
    ssh -t %oj% "bash %ssh_oj_restore_script_path% /tmp/%backup_file_name% --no-db"
)

echo 本地復原腳本執行完畢
