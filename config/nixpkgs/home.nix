{ config, pkgs, ... }:

{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  nixpkgs.config.allowUnfree = true;

  home.packages = with pkgs; [
    gnumake
    deluge
    zoom-us
    ffmpeg
    peek
    redshift

    # Progamming
    ctags
    python3
    gcc
    go
  ];


  services.redshift = {
    enable = true;
    provider = "geoclue2";
  };

  xresources.properties = {
    "Xft.dpi" = 140; # = 210 / 1.5, where 210 is the native DPI.
    "URxvt.font" = "xft:monospace:size=10";
    "URxvt.scrollBar" = false;

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

    # xsession.pointerCursor = {
    # name = "Vanilla-DMZ-AA";
    # package = pkgs.vanilla-dmz;
    # size = 32;
  # };

}
