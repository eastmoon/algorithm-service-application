# Import libraries
import os
import glob
import subprocess


from conf import attributes

# Declare variable

# Declare function
def conf(parser):
    ## command description
    new_parser = parser.add_parser('exec', help='Execute algorithm', description=f"Execute algorithm in '{attributes.APP_A_DIR}'")
    ## command options and description
    new_parser.add_argument('algorithm_name', help='A name which algorithm will be execute.')
    new_parser.add_argument('algorithm_params', nargs='*', help='Algorithm parameters array.')
    ## command process function
    new_parser.set_defaults(func=exec, helper=new_parser.print_help)

def exec(args):
    ## Generate execute information
    desc = f"Exec algorithm : {args.algorithm_name}"
    if len(args.algorithm_params) > 0: desc = f"{desc} {args.algorithm_params}"
    print(desc)
    ## Check and retrieve target algorithm file.
    algo_path = ""
    target_path = f"{attributes.APP_A_DIR}/{args.algorithm_name}.py"
    if os.path.isfile(target_path): algo_path = target_path
    target_path = f"{attributes.APP_A_DIR}/{args.algorithm_name}/main.py"
    if os.path.isfile(target_path): algo_path = target_path
    ## Run target algorithm file as a new process
    exec_cmd = ["python", algo_path]
    exec_cmd = exec_cmd + args.algorithm_params
    result = subprocess.run(exec_cmd, capture_output=True, text=True)
    print(result.stdout)
