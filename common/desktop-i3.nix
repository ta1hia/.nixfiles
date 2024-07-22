{ config, pkgs, lib, ... }:

{
  imports = [
    ./desktop.nix
  ];

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    xkb.layout = "us";
    windowManager.i3.enable = true;
  };
  services.libinput.enable = true;
  services.displayManager.autoLogin = {
    enable = true;
    user = "tahia";
  };


  environment.systemPackages = with pkgs; [
    clipmenu
    clipnotify
    i3lock
    i3status
    networkmanagerapplet
    ranger
    pcmanfm
  ];


  # Based on https://github.com/cdown/clipmenu/blob/develop/init/clipmenud.service
  #services.clipmenu.enable = true;
  systemd.user.services.clipmenud = {
    enable = true;
    description = "Clipmenu daemon";
    serviceConfig =  {
      Type = "simple";
      NoNewPrivileges = true;
      ProtectControlGroups = true;
      ProtectKernelTunables = true;
      RestrictRealtime = true;
      MemoryDenyWriteExecute = true;
    };
    wantedBy = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    environment = {
      DISPLAY = ":0";
    };
    path = [ pkgs.clipmenu ];
    script = ''
      ${pkgs.clipmenu}/bin/clipmenud
    '';
  };
}
