# Algorithm service Application

## 簡介

運算服務應用程式是將運算服務以容器封裝的服務應用程式，其封裝後的映像檔可再次以容器掛起，並透過如下介面執行服務：

+ 命令介面 ( CLI )，經由 ```docker exec``` 執行
+ 網頁應用介面 ( WebAPI )，經由容器設定的連接埠執行應用介面，此介面亦為執行可運行的命令介面
    - 透過 CGI 呼叫 CLI 執行，實踐遠端程序呼叫 ( Remote Procedure Call、RPC )
    - 在封裝時可以選擇是否建置此項目，Dockerfile 需要區分
+ 需求檔 ( Request file )，以監控的方式處理指定目錄中的檔案，若有新增為處理的內容，則觸發執行
    - 透過 watch 監控目錄中檔案變更，並依據 inode 記錄讀取檔案

## 適用情境

+ 封裝演算法、模型計算邏輯與執行環境相關函式庫
+ 封裝內容為映像檔，可提供給其他容器服務系統使用
+ 對外連接埠與執行目錄應為固定

## 開發環境

本專案預設於 Windows 環境設計，相關操作指令如下：

#### 服務開發

使用此命令會啟動容器並進入，以此設計命令介面內容與演算法內容

```
asa.bat [--rpc] dev
```
> ```--rpc``` 開發容器具有 RPC + CLI 功能，若未指定僅有 CLI 功能

開發模式中會掛起不同目錄以便開發細節

+ ```/app``` 目錄會指向 ```src``` ，用於演算法開發，亦是容器指定的工作目錄
+ ```/usr/local/src/asa``` 目錄指向 ```conf/docker/cli```，用於命令介面 ```sas``` 開發
+ ```/usr/share/nginx/html``` 目錄指向 ```conf/docker/rpc/nginx/html```，用於遠端程序呼叫的服務頁面設計
+ ```/usr/share/nginx/rpc``` 目錄指向 ```conf/docker/rpc/nginx/rpc```，用於遠端程序呼叫的服務邏輯設計

#### 服務封裝

使用此命令會以 Docker 將相關內容複製入容器，並匯出容器至快取目錄

```
asa.bat pack
```

#### 服務執行

使用此命應會將映像檔匯入 Docker 並啟用容器

```
asa.bat run
```

#### 執行服務的命令介面

使用此命應會對啟用容器執行指定的命令介面

```
asa.bat exec -c="command"
```

## 演算測試

+ 命令介面 ( CLI )

+ 網頁應用介面 ( WebAPI )

+ 需求檔 ( Request file )
