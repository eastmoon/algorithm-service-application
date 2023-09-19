import sys
import numpy as np

if __name__ == '__main__':
    num1 = int(sys.argv[1])
    num2 = int(sys.argv[2])
    r = np.add(num1, num2)
    print("Result: {0}".format(r))
