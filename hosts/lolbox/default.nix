# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{

  imports =
    [ 
      ./hardware-configuration.nix
      ./thinkpad-x1c.nix
      ./sops.nix

      ../../system/desktop.nix
      ../../system/i3.nix
      ../../system/mounts/nas-1.nix
    ];

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # LUKS
  boot.initrd.luks.devices = {
    root = { device = "/dev/nvme0n1p2"; allowDiscards = true; preLVM = true; };
  };

  nix.settings.experimental-features = ["nix-command" "flakes"];

  networking.hostName = "lolbox"; 
  networking.networkmanager.enable = true;
  networking.networkmanager.wifi.macAddress = "preserve";  
  networking.resolvconf.dnsExtensionMechanism = false; # Remove edns0 option in resolv.conf: Breaks some public WiFi but it is required for DNSSEC.

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp0s31f6.useDHCP = true;
  networking.interfaces.wlp0s20f3.useDHCP = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  users.extraUsers.tahia = {
    createHome = true;
    extraGroups = [ "wheel" "video" "audio" "disk" "networkmanager" "docker"]; # Enable ‘sudo’ for the user.
    group = "users";
    home = "/home/tahia";
    isNormalUser = true;
    uid = 1000;
  };

  # TODO move
  virtualisation.docker.enable = true;

  system.autoUpgrade.enable = true;
  system.autoUpgrade.allowReboot = true;

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "19.09"; # Did you read the comment?
}

