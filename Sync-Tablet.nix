{ pkgs ? import <nixpkgs> {}}:
pkgs.mkShell {
	buildInputs = [
		pkgs.poppler-utils
		pkgs.python313Packages.tkinter
		pkgs.python313Packages.easygui
		
		
	];

	shellHook = ''
		cleanup() {
			fusermount -u /home/box/Sync-Tablet
			
		}

		
		trap cleanup EXIT

		bash /home/box/scripts/Sync-Tablet.sh		

		sudo mkdir /tmp/TabTools/

		usenv
		
		sudo python /home/box/scripts/Sync-Tablet.py

	'';
}
