#!/usr/bin/python

#@PARAME task_id logs_line
#@DESC 取回指定演算法的執行記錄
#@DESC task_id 演算法 ID
#@DESC logs_line 記錄行數 ( 預設為 1 )

# Import library
import sys
import os
import time
import subprocess

if __name__ == '__main__':
    task_id = sys.argv[1] if len(sys.argv) > 1 else "demo"
    logs_line = sys.argv[2] if len(sys.argv) > 2 else "1"
    log_dir="/var/log/asa"
    target_file="/{0}/{1}.log".format(log_dir, task_id)
    if os.path.exists(target_file) and os.path.isfile(target_file):
        output_file="/tmp/{0}.log".format(time.time())
        subprocess.run(["tail -n {1} {0} > {2}".format(target_file, logs_line, output_file)], shell=True, timeout=3600)
        f = open(output_file, "r")
        print(f.read())
        subprocess.run(["rm {0}".format(output_file)], shell=True)
    else:
        print("file {0} not find.".format(target_file))
