# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  # services.localtime.enable = true;
  services.automatic-timezoned.enable = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;
  #hardware.enableAllFirmware = true;
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = false;

  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../../hardware/thinkpad-x1c.nix
      ../../common/boot.nix
      ../../common/desktop-i3.nix
    ];

  networking.hostName = "lolbox"; # Define your hostname.
  #networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.wifi.macAddress = "preserve";  # Or "random", "stable", "permanent", "00:11:22:33:44:55"
  networking.resolvconf.dnsExtensionMechanism = false; # Remove edns0 option in resolv.conf: Breaks some public WiFi but it is required for DNSSEC.


  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp0s31f6.useDHCP = true;
  networking.interfaces.wlp0s20f3.useDHCP = true;

  # Enable networkmanager
  networking.networkmanager.enable = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Set your time zone.
  # time.timeZone = "Europe/Amsterdam";

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  virtualisation.docker.enable = true;
  environment.systemPackages = with pkgs; [
    home-manager
    alsaTools
    arandr
    blueman
    dunst
    feh
    xclip
    xsel
  ];

  nix.settings.experimental-features = ["nix-command" "flakes"];

  users.extraUsers.tahia = {
    createHome = true;
    extraGroups = [ "wheel" "video" "audio" "disk" "networkmanager" "docker"]; # Enable ‘sudo’ for the user.
    group = "users";
    home = "/home/tahia";
    isNormalUser = true;
    uid = 1000;
  };

  system.autoUpgrade.enable = true;
  system.autoUpgrade.allowReboot = true;

  ## temp for kubectl example
  networking.extraHosts =
  ''
    172.17.255.2 alpaca.example.com bandicoot.example.com
  '';

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "19.09"; # Did you read the comment?
}

