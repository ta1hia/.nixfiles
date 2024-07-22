{ config, pkgs, ... }:

{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  nixpkgs.config.allowUnfree = true;
  manual.manpages.enable = false;

  home.packages = with pkgs; [
    chromium
    deluge
    peek
    zoom-us
    redshift
    vlc
    unrar
    weechat

    zathura
    aseprite
    gimp

    gnumake
    ctags
    python3
    gcc
    go
    rg

    rust-analyzer
    vscode
  ];

  programs.vscode = {
      extensions = with pkgs.vscode-extensions; [
        # Projects mananged by nix-shell that need this 
        # will need to include "rust-src" as an extension 
        # on the rust override
        matklad.rust-analyzer
      ];
  };

  xsession = {
    enable = true;
    windowManager.command = "dbus-launch --exit-with-x11 i3";

    pointerCursor = {
      name = "Vanilla-DMZ-AA";
      package = pkgs.vanilla-dmz;
      size = 32;
    };
  };

  home.file.".xinitrc".text = ''
    # Delegate to xsession config
    . ~/.xsession
  '';

  services.redshift = {
    enable = true;
    provider = "geoclue2";
  };

  services.random-background = {
    enable = true;
    imageDirectory = "%h/.wallpapers";
    interval = "1h";
  };

  xresources.properties = {
    "Xft.dpi" = 140; # = 210 / 1.5, where 210 is the native DPI.
    "URxvt.font" = "xft:monospace:size=10";
    "URxvt.scrollBar" = false;
    "urxvt.perl-ext-common" =  "default,tabbed,matcher,resize-font,-tabbed";

    # terminal colours
    "*foreground" = "#CCCCCC";
    "*background" = "#1B1D1E";

    # black darkgray
    "*color0" = "#1B1D1E";
    "*color8" = "#808080";
    # darkred red
    "*color1" = "#FF0044";
    "*color9" = "#F92672";
    # darkgreen green
    "*color2" = "#82B414";
    "*color10" = "#A6E22E";
    # darkyellow yellow
    "*color3" = "#FD971F";
    "*color11" = "#E6DB74";
    # darkblue blue
    "*color4" = "#266C98";
    "*color12" = "#7070F0";
    # darkmagenta magenta
    "*color5" = "#AC0CB1";
    "*color13" = "#D63AE1";
    # darkcyan cyan
    "*color6" = "#AE81FF";
    "*color14" = "#66D9EF";
    # gray white
    "*color7" = "#CCCCCC";
    "*color15" ="#F8F8F2";
  };

}
