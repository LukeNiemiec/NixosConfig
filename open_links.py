from subprocess import run
from re import findall
from sys import argv
from os import getcwd

link_file = run(["cat", argv[1]], capture_output = True)

if not link_file.stderr:
   
    # match alaises from .bashrc
    links = findall(r"(https://\S*?)[\n|\s]", link_file.stdout.decode())

    browser_command = run(["exec","--no-startup-id", "qutebrowser"] + links, capture_output = True)

    if browser_command.stderr:
        print("ERROR running qutebrowser command!")

    
