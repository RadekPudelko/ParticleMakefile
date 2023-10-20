# Script to find old version of the Makefile and replace it with the new
import os
from os.path import isdir
import re
import shutil

def recurse_list(top_path):
    files = os.listdir(top_path)
    myList = []
    for file in files:
        path = f"{top_path}/{file}"
        if os.path.isdir(path):
            myList.extend(recurse_list(path))
        elif file == "Makefile":
            with open(path, "r") as f:
                line = f.readline()
                if "### MY_PARTICLE_MAKEFILE" not in line:
                    continue
            myList.append(path)
    return myList

def main():
    new_makefile = "/Users/radek/code/scripts/ParticleMakefile/Makefile"
    top_path = "/Users/radek/code/cpp"
    myList = recurse_list(top_path)
    for path in myList:
        print(path)
        # shutil.copy(new_makefile, path)

if __name__ == "__main__":
    main()
    
