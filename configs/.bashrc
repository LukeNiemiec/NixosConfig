# [ Commands ]
alias ls="ls -al --color=auto"
alias notes="micro notes.txt"
alias todo="micro TODO.txt"
alias backup="onedrive --sync --upload-only"
alias msdb1="bash ~/scripts/mountSDB1.sh"
alias umsdb1="bash ~/scripts/unmountSDB1.sh"
alias commit="bash ~/scripts/git_upload.sh"
alias usenv="source ~/py-env/bin/activate"
alias aliasng="python ~/scripts/list_alias.py"
alias openlink="python ~/scripts/open_links.py"

# [ Goto ]
alias school="clear && cd ~/OneDrive/School/Spring2025"
alias research="clear && cd ~/OneDrive/Research"
alias github="clear && cd ~/OneDrive/GitHub/"

# [ Nixos ]
alias rebuild="sudo nixos-rebuild switch"
alias clean="sudo nix-collect-garbage -d && sudo nixos-rebuild boot"
alias fixboot="sudo nixos-rebuild --install-bootloader boot"


# print aliases on statup
aliasng
