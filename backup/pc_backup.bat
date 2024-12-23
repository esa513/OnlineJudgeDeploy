chcp 65001
@echo off

@REM if arguments -t or --test, use oj_test
set oj=oj
for %%i in (%*) do (
    if "%%i" == "-t" (
        set oj=oj_test
    ) else if "%%i" == "--test" (
        set oj=oj_test
    )
)

@REM ---------------------------------------- 取得時間戳 ----------------------------------------
for /f "tokens=1-7 delims=:. " %%a in ('wmic os get localdatetime ^| find "."') do (
    set timestamp=%%a
)
set timestamp=%timestamp:~0,4%_%timestamp:~4,2%_%timestamp:~6,2%_%timestamp:~8,2%_%timestamp:~10,2%_%timestamp:~12,2%

@REM ---------------------------------------- 取得備份檔路徑 ----------------------------------------
@REM 讀取用戶 Documents 資料夾的路徑
for /f "tokens=3*" %%a in ('reg query "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" /v Personal') do set documents_path=%%a

@REM 如果路徑包含 %USERPROFILE%，展開實際路徑
call set documents_path=%documents_path%

@REM ---------------------------------------- 建立本地備份檔案資料夾 ----------------------------------------
set pc_oj_backup_files_folder=%documents_path%\%oj%_backup_files
set pc_oj_backup_file_name=oj_backup_%timestamp%.tar.gz
if not exist "%pc_oj_backup_files_folder%" mkdir "%pc_oj_backup_files_folder%"

@REM ---------------------------------------- 設定遠端伺服器備份檔案資料夾 ----------------------------------------
set ssh_oj_backup_file_name=oj_backup.tar.gz
set ssh_oj_backup_files_folder=/tmp
set ssh_oj_backup_script_path=~/OnlineJudge/OnlineJudgeDeploy/backup/backup.sh

@REM ---------------------------------------- 使用 SSH 執行遠端備份腳本 ----------------------------------------
ssh -t %oj% "bash %ssh_oj_backup_script_path% %timestamp%"

@REM ---------------------------------------- 使用 SCP 將壓縮檔案從遠端伺服器複製到本地 ----------------------------------------
scp %oj%:%ssh_oj_backup_files_folder%/%ssh_oj_backup_file_name% "%pc_oj_backup_files_folder%\%pc_oj_backup_file_name%"

@REM ---------------------------------------- 開啟檔案總管並選取備份檔案 ----------------------------------------
if exist "%pc_oj_backup_files_folder%\%pc_oj_backup_file_name%" (
    echo 備份成功
    explorer.exe /select,"%pc_oj_backup_files_folder%\%pc_oj_backup_file_name%"

) else (
    echo 備份失敗
pause
)
