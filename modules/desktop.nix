{ pkgs, ... }:

{
  # Desktop environment agnostic packages.
  environment.systemPackages = with pkgs; [
    alsaTools
    arandr
    blueman
    pulseaudio
    dunst
    xclip
    xsel

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
    xfce.thunar
    wget
    
    # Wireless
    bluez
    iw # wireless tooling
     
  ];

  fonts.packages = with pkgs; [
    hermit
    source-code-pro
    terminus_font
  ];

  # Select internationalisation properties.
  console = {
    font = "${pkgs.terminus_font}/share/consolefonts/ter-u28n.psf.gz";
    keyMap = "us";
  };

  # Set your time zone.
  services.automatic-timezoned.enable = true;

  networking.networkmanager.enable = true;
  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # networking.firewall.enable = false;
  # Or disable the firewall altogether.

  # Enable sound.
  hardware.pulseaudio = {
    enable = true;
    support32Bit = true;
    # Need full for bluetooth support
    package = pkgs.pulseaudioFull;
    # extraModules = [ pkgs.pulseaudio-modules-bt ];
  };

  # Services to enable:
  services.printing.enable = true; # Enable CUPS to print documents.

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = { enable = true; enableSSHSupport = true; };
  # services.openssh.enable = true; # Enable the OpenSSH daemon.

  # Brightness control
  programs.light.enable = true;
  services.actkbd = {
    enable = true;
    bindings = [
      { keys = [ 64 ]; events = [ "key" ]; command = "/run/current-system/sw/bin/light -A 10"; }
      { keys = [ 63 ]; events = [ "key" ]; command = "/run/current-system/sw/bin/light -U 10"; }
    ];
  };

  nixpkgs.config.allowUnfree = true;
  services.flatpak.enable = true;
  services.accounts-daemon.enable = true; # Required for flatpak+xdg
  xdg.portal.enable = true; # xdg portal is used for tunneling permissions to flatpak
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

  #programs.steam.enable = true;
  hardware.graphics.enable32Bit = true;
  hardware.graphics.extraPackages = with pkgs; [ vaapiIntel libvdpau-va-gl vaapiVdpau intel-ocl intel-media-driver ];

}
