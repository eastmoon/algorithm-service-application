# Import libraries
from conf import attributes

# Declare variable

# Declare function
def conf(parser):
    ## command description
    new_parser = parser.add_parser('exec', help='Execute algorithm', description=f"Execute algorithm in '{attributes.APP_A_DIR}'")
    ## command options and description
    ## command process function
    new_parser.set_defaults(func=exec, helper=new_parser.print_help)

def exec(args):
    print("exec algorithm ...")
