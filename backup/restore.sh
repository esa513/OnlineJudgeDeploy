#!/bin/bash

# 複製資料庫備份文件到 oj-postgres 容器
docker compose cp /tmp/db_backup.sql oj-postgres:/tmp/db_backup.sql

# 還原資料庫
docker compose exec -it oj-postgres psql -U onlinejudge -f /tmp/db_backup.sql

# 還原資料
sudo unzip -o /tmp/data_backup.zip -d /

# 還原後重啟容器
docker compose --profile esa restart