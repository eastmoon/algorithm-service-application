#@PARAME Parame1 Parame2
#@DESC 這是加法演算法
#@DESC Parame1 是第一個數值
#@DESC Parame2 是第二個數值

import sys
import numpy as np

if __name__ == '__main__':
    num1 = int(sys.argv[1])
    num2 = int(sys.argv[2])
    r = np.add(num1, num2)
    print("Result: {0}".format(r))
