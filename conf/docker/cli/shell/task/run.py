#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import sys
import yaml
from yaml.loader import SafeLoader

if __name__ == '__main__':
    task = sys.argv[1]
    print("Task: {0}".format(task))
    with open(task, 'r') as f:
        data = yaml.load(f, Loader=SafeLoader)
        print(yaml.dump(data))
        print('---')
        print(type(data))
        print(data)
        print('---')
        print(data['name'])
        print(data['age'])
