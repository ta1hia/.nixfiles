{ config, pkgs, ... }:

{
  imports = [
    ./i3
    ./redshift.nix
  ];

  home.username = "tahia";   
  home.homeDirectory = "/home/tahia";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  nixpkgs.config.allowUnfree = true;

  home.packages = with pkgs; [
    chromium
    deluge
    peek
    redshift
    vlc
    unrar
    zoom-us
    weechat

    zathura

    gnumake
    ctags
    python3
    gcc
    go
    ripgrep

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

  home.stateVersion = "23.11";
}
