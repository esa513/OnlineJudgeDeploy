# Backup

## 概述

此目錄包含用於備份和恢復 OnlineJudge 資料的腳本。

## 文件結構

- `backup.sh`: 用於在伺服器上生成備份的腳本。
- `restore.sh`: 用於在伺服器上恢復備份的腳本，需要傳入備份檔參數。
- `pc_backup.bat`: 用於在伺服器上生成備份並將其從伺服器複製到本地的批處理腳本，支援參數 `-t`/`--test`。
- `pc_restore.bat`: 用於從本地備份恢復的批處理腳本，需要傳入備份檔參數，支援參數 `-t`/`--test`。

## 使用說明

### 伺服器備份

* 執行 [backup.sh](backup.sh) 腳本以生成伺服器上的備份。
    ```sh
    ./backup.sh
    ```

### 伺服器恢復

* 執行 [restore.sh](restore.sh) 腳本以從備份恢復至伺服器。

    * 含資料庫
        ```sh
        ./restore.sh <backup_file>
        ```

    * 不含資料庫（只有前端圖片、測資等檔案）
        ```sh
        ./restore.sh --no-db <backup_file>
        ```

### 本地執行伺服器備份

* 執行 [pc_backup.bat](pc_backup.bat) 腳本以在伺服器上生成備份並將其從伺服器複製到本地。
    ```bat
    .\pc_backup.bat
    ```

### 本地執行伺服器恢復

* 執行 [pc_restore.bat](pc_restore.bat) 腳本以從本地備份恢復，並傳入備份檔參數。

    * 含資料庫
        ```sh
        .\pc_restore.bat <backup_file>
        ```

    * 不含資料庫（只有前端圖片、測資等檔案）
        ```sh
        .\pc_restore.bat --no-db <backup_file>
        ```

## 測試模式

[pc_backup.bat](pc_backup.bat) 和 [pc_restore.bat](pc_restore.bat) 腳本支援 `-t` 或 `--test` 參數，用於在測試伺服器上運行腳本。測試模式下，腳本將連接到測試伺服器而不是生產伺服器。

### 使用範例

* 在測試伺服器上執行本地備份：
    ```bat
    .\pc_backup.bat -t
    ```

* 在測試伺服器上執行本地恢復：
    ```bat
    .\pc_restore.bat -t <backup_file>
    ```

* 在測試伺服器上執行本地恢復（不含資料庫）：
    ```bat
    .\pc_restore.bat -t --no-db <backup_file>
    ```

## 注意事項

- 確保在執行恢復操作之前，已經備份了當前數據。
- 在執行任何腳本之前，請仔細閱讀並理解其內容。