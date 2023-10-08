# Algorithm service Application

## 簡介

運算服務應用程式是將運算服務以容器封裝的服務應用程式，其封裝後的映像檔可再次以容器掛起，並透過如下介面執行服務：

+ 命令介面 ( CLI )，經由 ```docker exec``` 執行
+ 遠端程序呼叫 ( RPC )，經由容器設定的連接埠執行應用介面，此介面亦為執行可運行的命令介面
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

+ ```/app``` 目錄會指向 ```app``` ，用於演算法開發，亦是容器指定的工作目錄
+ ```/task``` 目錄會指向 ```task```，用於演算法任務來源目錄
+ ```/data``` 目錄會指向 ```cache/data```，用於演算法外部資料提供
+ ```/usr/local/src/asa``` 目錄指向 ```conf/docker/cli```，用於命令介面 ```sas``` 開發
+ ```/usr/share/nginx/html``` 目錄指向 ```conf/docker/rpc/nginx/html```，用於遠端程序呼叫的服務頁面設計
+ ```/usr/share/nginx/rpc``` 目錄指向 ```conf/docker/rpc/nginx/rpc```，用於遠端程序呼叫的服務邏輯設計

#### 服務封裝

使用此命令會以 Docker 將相關內容複製入容器，並匯出容器至快取目錄

```
asa.bat pack
```

在封裝服務時，會將 ```/app``` 目錄複製入映像檔中

#### 服務執行

使用此命應會將映像檔匯入 Docker 並啟用容器

```
asa.bat run
```

#### 執行服務的命令介面

使用此命令對啟用容器列舉可執行的演算法

```
asa.bat ls
```

使用此命令對啟用容器執行指定的演算法

```
asa.bat exec -c="command"
```
> 若命令間有空白請用 "_" 替代，如 ```asa.bat exec -c="command_param1_parame2"

## 演算法執行

演算法存在於容器內的 ```/app``` 目錄下，會被視為演算法進入點的規則如下：

+ 存在於 ```/app``` 目錄下的 ```*.py``` 檔案
+ 存在於 ```/app/<sub-dir>``` 目錄下的 ```main.py``` 檔案

基於上述規則，若 ```/app``` 目錄如下：

```
/app
  └ 0001.py
  └ 0002
    └ main.py
  └ 0003
    └ test.py
```

則基於上述規則，可執行的演算法僅有 ```0001```、```0002```，由於 ```0003``` 因為條件不符合規則不會出現在列舉與可執行項目中。

#### 命令介面 ( CLI )

```
asa exec <algorithm> <parameter-1> ... <parameter-N>
```

#### 遠端程序呼叫 ( RPC )

```
http://localhost/asa/exec/<algorithm>/<parameter-1>/.../<parameter-N>
```

#### 任務檔 ( Request file )

儲存至共享目錄 ```/task``` 的 YAML 格式檔案，此任務檔案可透過以下方式執行內容。

+ CLI
```
asa task <filename>
```

+ RPC
```
http://localhost/asa/task/<filename>
```

+ Watcher
若目錄監視者 ( Watcher ) 若發現目錄變更，則將此變更的檔案列入執行柱列，依序執行任務檔所述的內容。

## 文獻

+ [RPC 與 REST 之間有何差異？](https://aws.amazon.com/tw/compare/the-difference-between-rpc-and-rest/)
+ [Logstash Alternatives](https://alternativeto.net/software/logstash/)
