# NixosConfig

This is a collection of my prefered nixos configurations, tools and files.
The install-configs.sh script is used to sync my scripts and configs to a new nixos installation to make my life easier.

# Usage

To make sure you have neccessary permisions, run:
	`sudo -i`

To run the script, run this with changing `/dev/sdX` with you drive:
	`bash install-configs.sh /dev/sdX`


# Future Developments

I want to make this allow for people copying their own nixos configurations, files and directories to be uploaded and loaded automatically whenever those files are changed.
Kind of like git but instead of just any code its specifically for nixos.
