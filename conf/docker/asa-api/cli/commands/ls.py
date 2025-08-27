# Import libraries
import os
import re
import glob
from conf import attributes

# Declare variable
BLU="\033[36m"
GRE="\033[1;32m"
RED="\033[1;31m"
END="\033[0m"

# Declare function
def conf(parser):
    ## command description
    new_parser = parser.add_parser('ls', help='List algorithm', description=f"List all algorithm script in '{attributes.APP_A_DIR}'")
    ## command options and description
    ## command process function
    new_parser.set_defaults(func=exec, helper=new_parser.print_help)

def exec(args):
    print("Algorithm list:")
    # For recursive search, use '**' and set recursive=True
    ## Search all python file in application directories
    files = glob.glob(f"{attributes.APP_A_DIR}/*.py")
    for file in files:
        file_name = os.path.basename(file)
        algorithm_name = os.path.splitext(file_name)[0]
        show(algorithm_name, file)
    ## Search all main.py in application sub-directories
    files = glob.glob(f"{attributes.APP_A_DIR}/*/main.py")
    for file in files:
        folder_path = os.path.dirname(file)
        algorithm_name = os.path.basename(folder_path) # Returns "folder"
        show(algorithm_name, file)
    return files

def show(algorithm_name, file_path):
    """
    Show algorithm file description.

    Args:
        algorithm_name (str): The algorithm name.
        file_path (str): The algorithm file paths.
    """
    try:
        ## Search #@PARAME , #@DESC tag in algorithm file.
        with open(file_path, 'r') as f:
            print("")
            title = []
            desc = []
            for line_num, line in enumerate(f, 1):
                if re.search("#@PARAME", line):
                    title.append(line.split("#@PARAME")[1].strip())
                elif re.search("#@DESC", line):
                    desc.append(line.split("#@DESC")[1].strip())
        ## Show information with parser result.
        if len(title) == 0:
            print(f"{GRE}{algorithm_name}{END}")
        else:
            for str in title:
                print(f"{GRE}{algorithm_name} : {str}{END}")
        for str in desc:
            print(f" {str}")
    except FileNotFoundError:
        print(f"Error: File not found at '{file_path}'")
    except Exception as e:
        print(f"An error occurred: {e}")
