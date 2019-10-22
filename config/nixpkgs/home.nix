{ config, pkgs, ... }:

{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    ctags
    python3
    gcc
    go

  ];

  xresources.properties = {
    "Xft.dpi" = 140; # = 210 / 1.5, where 210 is the native DPI.
    "URxvt.font" = "xft:monospace:size=9";
    "URxvt.scrollBar" = false;
    "*.foreground" = "#93a1a1";
    "*.background" = "#141c21";

    "*.color0" = "#263640";
    "*.color1" = "#d12f2c";
    "*.color2" = "#819400";
    "*.color3" = "#b08500";
    "*.color4" = "#2587cc";
    "*.color5" = "#696ebf";
    "*.color6" = "#289c93";
    "*.color7" = "#bfbaac";
    "*.color8" = "#4a697d";
    "*.color9" = "#fa3935";
    "*.color10" = "#a4bd00"; 
    "*.color11" = "#d9a400";
    "*.color12" = "#2ca2f5";
    "*.color13" = "#8086e8";
    "*.color14" = "#33c5ba";
    "*.color15" = "#fdf6e3";
  };

}
