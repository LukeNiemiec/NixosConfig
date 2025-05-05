from subprocess import run
from re import findall

alias_file = run(["cat", "/home/box/.bashrc"], capture_output = True)


# match alaises from .bashrc
aliases = findall(r"(?:# \[ (\S*?) \])|(?:alias (\S*?)\=)", alias_file.stdout.decode())

# print(aliases)

for alias in aliases:
    if alias[0]:
        print(f"\n# [{alias[0]}]:")
    elif alias[1]:
        print(f"\t{alias[1]}")




