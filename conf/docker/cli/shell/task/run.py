#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import os
import sys
import yaml
from yaml.loader import SafeLoader

if __name__ == '__main__':
    task = sys.argv[1]
    print("Task: {0}".format(task))
    with open(task, 'r') as f:
        data = yaml.load(f, Loader=SafeLoader)
        #print(type(data))
        #print(yaml.dump(data))
        #print(data)
        # log to name.log
        print(data['name'])
        # algo exist, then execute algo.name with algo.param
        if 'algo' in data:
            aname = data['algo']['name'] if "name" in data['algo'] else ""
            aparam = data['algo']['param'] if "param" in data['algo'] else ""
            #print("asa exec {0} {1}".format(aname, aparam))
            os.system("asa exec {0} {1}".format(aname, aparam))
        else:
            print("Task file don't have 'algo' key for execute algorithm.")
        # result exist, when algo stdout put into that protocol.
        #   - file
        #   - callback function
        #   - message queue
        print(data['result'])
