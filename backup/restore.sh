#!/bin/bash

# 檢查是否提供了備份檔案名稱
if [ -z "$1" ]; then
  echo "請提供要復原的備份檔案名稱"
  exit 1
fi

backup_file=$1
deploy_path=~/OnlineJudge/OnlineJudgeDeploy

# 檢查備份檔案是否存在
if [ ! -f $backup_file ]; then
  echo "備份檔案不存在: $backup_file"
  exit 1
fi

# 要求使用者確認是否要復原
read -p "確定要復原備份檔案 $backup_file 嗎？(y/N) "

if [[ ! $REPLY =~ ^[Yy]$ ]]; then
  echo "取消復原"
  exit 1
fi

# 切換到 deploy_path 目錄
cd $deploy_path

# 解壓縮備份檔案
sudo tar -xzvf $backup_file -C /tmp oj_db_backup.sql

# 複製資料庫備份文件到 oj-postgres 容器
docker compose cp /tmp/oj_db_backup.sql oj-postgres:/tmp/oj_db_backup.sql

# 還原資料庫
docker compose exec -T oj-postgres psql -U onlinejudge -f /tmp/oj_db_backup.sql

# 還原資料
sudo tar -xzvf $backup_file -C $deploy_path data/backend/public data/backend/test_case

# 還原後重啟容器
docker compose --profile esa restart

# 切換回原來的目錄
cd -

echo "復原完成"