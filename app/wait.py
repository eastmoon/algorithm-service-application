#!/usr/bin/env python

#@PARAME task_id loop_time
#@DESC 長延遲範例，所有執行記錄會撰寫於記錄檔中
#@DESC task_id 演算法 ID
#@DESC loop_time 延遲次數 ( 預設為 5 )

# Import library
import os
import sys
import logging
import time

if __name__ == '__main__':
    task_id = sys.argv[1] if len(sys.argv) > 1 else "demo"
    loop_time = sys.argv[2] if len(sys.argv) > 2 else "5"
    log_dir="/var/log/asa"
    # 設定日誌
    # 若存在 Task-ID 則建立任務記錄檔
    if not os.path.exists(log_dir): os.mkdir(log_dir)
    logging.basicConfig(filename='{0}/{1}.log'.format(log_dir, task_id), level=logging.INFO)
    logger = logging.getLogger("con")
    logger.addHandler(logging.StreamHandler())
    statlog = logging.getLogger("stat")
    #
    statlog.info("wait:execute")
    #
    for t in range(1, int(loop_time) + 1):
        statlog.info(f'wait:step{t}')
        time.sleep(2)
    #
    statlog.info("wait:complete")
