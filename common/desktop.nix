{ pkgs, ... }:

{
  system.copySystemConfiguration = true;

  # Desktop environment agnostic packages.
  environment.systemPackages = with pkgs; [
    dmidecode
    firefox
    git
    htop
    inetutils
    mkpasswd
    tmux
    tree
    rxvt_unicode
    vim
    unzip
    wget
    
    # Wireless
    bluez
    iw # wireless tooling
  ];

  fonts.fonts = with pkgs; [
    hermit
    source-code-pro
    terminus_font
  ];

  # Select internationalisation properties.
  i18n = {
    consoleFont = "${pkgs.terminus_font}/share/consolefonts/ter-u28n.psf.gz";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };

  networking.networkmanager.enable = true;
  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # networking.firewall.enable = false;
  # Or disable the firewall altogether.

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio = {
    enable = true;
    # Need full for bluetooth support
    package = pkgs.pulseaudioFull;
    extraModules = [ pkgs.pulseaudio-modules-bt ];
  };

  # Services to enable:
  services.dnsmasq.enable = true;
  services.dnsmasq.servers = [ "1.1.1.1" "8.8.8.8" "8.8.4.4" ];
  services.printing.enable = true; # Enable CUPS to print documents.

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = { enable = true; enableSSHSupport = true; };
  # services.openssh.enable = true; # Enable the OpenSSH daemon.

  programs.light.enable = true;

}
