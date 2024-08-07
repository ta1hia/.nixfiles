{ pkgs, ... }:

{

  xresources.properties = {
    "Xft.dpi" = 140; # = 210 / 1.5, where 210 is the native DPI.
    "URxvt.font" = "xft:monospace:size=10";
    "URxvt.scrollBar" = false;
    "urxvt.perl-ext-common" =  "default,tabbed,matcher,resize-font,-tabbed";

    "*geometry" = "80x240+0+0";  # https://github.com/NixOS/nixpkgs/issues/241646

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
