#!/bin/bash

# 生成時間戳
timestamp=$(date +%Y_%m_%d"_"%H_%M_%S)

if [ -z "$1" ]; then
    timestamp=$1
fi

# 設定路徑
deploy_path=~/OnlineJudge/OnlineJudgeDeploy
deploy_backup_path=$deploy_path/backup/files
oj_db_backup_file_name=oj_db_backup_$timestamp.sql
oj_backup_file_name=oj_backup_$timestamp.tar.gz

# 建立資料夾
mkdir -p $deploy_backup_path

# 切換到 deploy_path 目錄
cd $deploy_path

# 執行 pg_dump 將資料庫保存到 .sql 中
docker compose exec -T oj-postgres pg_dump -c -U onlinejudge > $deploy_backup_path/$oj_db_backup_file_name

# 使用 tar 將資料庫和數據壓縮到 .tar.gz 中
sudo tar --transform 's/oj_db_backup_.*.sql/oj_db_backup.sql/' -czvf $deploy_backup_path/$oj_backup_file_name -C $deploy_backup_path $oj_db_backup_file_name -C $deploy_path data/backend/public data/backend/test_case

rm $deploy_backup_path/$oj_db_backup_file_name

# 將壓縮檔案複製到 /tmp 目錄
cp $deploy_backup_path/$oj_backup_file_name /tmp/oj_backup.tar.gz

# 切換回原來的目錄
cd -

echo "OJ 備份腳本執行完畢"
