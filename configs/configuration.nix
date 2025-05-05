# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.kernelModules = [ "amdgpu" ];

  # powersave kernel parameters
  boot.kernelParams = [
    "i915.enable_psr=1"         
    "i915.enable_dc=2"          
    "i915.enable_fbc=1"         
  ];
  
  # Define your hostname.
  networking.hostName = "iot";
  
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "America/New_York";
  # services.ntp.enable = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  # Enable the sway compositor
  services.xserver.enable = false;
  programs.sway.enable = true;

  services.xserver.windowManager.i3.enable = true;

  # Configure keymap
  services.xserver.xkb.layout = "us";

  # Enable sound.  
  services.pulseaudio.enable = false;

  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    audio.enable = true;
    pulse.enable = true;
	alsa = {
		enable = true;
		support32Bit = true;
	};
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;
  services.libinput.touchpad.tapping = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.box = {
   isNormalUser = true;
   extraGroups = [ "wheel" "audio" ]; # Enable ‘sudo’ for the user.
   initialPassword = "@Amazon2693";
   packages = with pkgs; [
     tree
   ];
  };


  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim 										# Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    qutebrowser									# browser
    onedrive    								# onedrive file sync
    kitty										# terminal
    micro										# text editor
    vlc											# media player
    usbimager
    curl			
    wget
    obs-studio									# video recording
    w3m											# html reader cli
    mupdf										# pdf reader
    pavucontrol									# audio control
    libreoffice									# document viewer and editor
    xdelta										# ROM Patcher
    unzip										# decompression tool
    htop										# process viewer
    desmume										# nds emulator
    ollama 										# local AI
    gnumake										# make
	powertop									# power statistics 
	sqlite										# sql 
	git											# git 
	gh											# github cli
	
    nmap										# network mapper
    wireshark									# protocol analyzer
    exiftool									# image metadata analyzer

    zulu23										# java 23.0
    python312									# python 3.12
    python312Packages.pip 						# pip

    python312Packages.selenium					# headless browser functionality
  	geckodriver
  	firefox
 
   
	sway									    # desktop manager
	swaybg										# wallpaper manager
    brightnessctl								# brightness manager
    i3											# window manager 
	wl-clipboard								# c/p manager
    iw											# networking manager
    pamixer										# audio manager
    esptool										# esp32 flashing interface
    
    
  ];


  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;



  # List services that you want to enable:

  programs.nix-ld.enable = true;
  
  # power manager ( power save focus )
  services.auto-cpufreq = {
  	enable = true;
  
  	settings = {
  	
  		# powersave options using battery
  		battery = {
  			governor = "powersave";
  			turbo = "never";	
  		};	
  		
  		# powersave options using charger
  		charger = {
  			governor = "powersave";
  			turbo = "never";
  		};
  	};
  };

  # AMDGPU 
  systemd.tmpfiles.rules = [
	    "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
  ];

  # enabling / adding amdgpu video drivers
  services.xserver.videoDrivers = [ "amdgpu" ];
  
  hardware.graphics.extraPackages = with pkgs; [
    rocmPackages.clr.icd
  ];

  
  # allow all firmware
  hardware.enableRedistributableFirmware = true;

  # enable experimental nix / flake features
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;


  # Bluetooth settings
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;


  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.05"; # Did you read the comment?

}

