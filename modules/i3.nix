{ config, pkgs, lib, ... }:

{
  services.xserver = {
    enable = true;
    xkb.layout = "us";

    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [
        clipmenu
        clipnotify
        dmenu-rs                # dmenu app launcher
        feh                     # wallpaper
        i3lock                  # lock screen
        i3status                # basic i3bar customization
        networkmanagerapplet    # network tray applet
        ranger                  # term file manager
        volctl                  # volume tray applet
        xss-lock                # lock screen
      ];
    };
  };

  services.displayManager.autoLogin = {
    enable = true;
    user = "tahia";
  };

  programs.i3lock.enable = true;

  programs.thunar.plugins = with pkgs.xfce; [
    thunar-archive-plugin
    thunar-volman
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
