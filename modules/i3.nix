{ config, pkgs, lib, ... }:

{
  services.xserver = {
    enable = true;
    xkb.layout = "us";
    windowManager.i3.enable = true;
  };

  services.displayManager.autoLogin = {
    enable = true;
    user = "tahia";
  };

  environment.systemPackages = with pkgs; [
    clipmenu
    clipnotify
    feh                     # wallpaper
    i3lock
    i3status
    networkmanagerapplet
    ranger
    pcmanfm
    xss-lock
  ];


  # Based on https://github.com/cdown/clipmenu/blob/develop/init/clipmenud.service
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
