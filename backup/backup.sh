#!/bin/bash

# 生成時間戳
timestamp=$(date +%Y_%m_%d"_"%H_%M_%S)

# 設定路徑
deploy_path=/home/esa/OnlineJudge/OnlineJudgeDeploy
deploy_backup_path=$deploy_path/backup

# 建立資料夾
mkdir -p $deploy_backup_path/{db,data}

# 執行 pg_dump 將資料庫保存到 .sql 中
docker compose exec -it oj-postgres pg_dump -c -U onlinejudge > $deploy_backup_path/db/db_backup_$timestamp.sql

# 將需要的東西保存到 .zip 中
sudo zip -r $deploy_backup_path/data/data_backup_$timestamp.zip $deploy_path/data/backend/{public,test_case}

# 將備份文件複製到 backup 目錄
cp $deploy_backup_path/db/db_backup_$timestamp.sql $deploy_backup_path/db_backup.sql
cp $deploy_backup_path/data/data_backup_$timestamp.zip $deploy_backup_path/data_backup.zip

# 將備份文件複製到 /tmp 目錄
cp $deploy_backup_path/db/db_backup_$timestamp.sql /tmp/db_backup.sql
cp $deploy_backup_path/data/data_backup_$timestamp.zip /tmp/data_backup.zip