# NIX CONFIGURATION -------------------------
{ config, pkgs, ... }:

{
# NIXOS SETTINGS-----------------------------

  # GENERAL
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  system.stateVersion = "26.05"; # Did you read the comment?
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true; #PROPRIETARY GARBAGE
  time.timeZone = "America/Los_Angeles";
  services.printing.enable = true; # printing
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  programs.zsh.enable = true;

  # Touch Settings
environment.etc."libinput/local-overrides.quirks".text = ''
  [LattePanda eDP Touchscreen Calibration]
  MatchName=*
  AttrSizeHint=260x140
  AttrPalmSizeThreshold=0
  AttrHysteresisMargin=10
''; 
  	
  
  # USER [set pw with ‘passwd’]
    users.users."wavhart" = {
      isNormalUser = true;
      description = "wavhart";
      extraGroups = [ "networkmanager" "wheel" ];
    };

    users.defaultUserShell = pkgs.zsh;
    
  networking.networkmanager.enable = true; # enable network
  networking.hostName = "nixos"; # hostname
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # BLUETOOTH
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;

  # SOUND
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    # jack.enable = true;
  };

# BASE PACKAGES----------------------------------
  environment.systemPackages = with pkgs; [
    firefox
    micro
    neovim    
    wget
    git
    foot
    kitty
    cliphist
    wl-clip-persist
   ];

# DESKTOP ENVIRONMENTS---------------------------

  services.libinput.enable = true; # touch support

  #HYPRLAND
  programs.hyprland = {
    	enable = true;
    	xwayland.enable = true;
    };

  # PLASMA
  services.displayManager.sddm = {
  	enable = true;
  	wayland.enable = true;
  };
  services.desktopManager.plasma6.enable = true;
  security.polkit.enable = true;
  
  # X11
  services.xserver = {
    enable = true;
  	xkb = {
	  	layout = "us";
		variant = "";
  	};
  };

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
  

}
