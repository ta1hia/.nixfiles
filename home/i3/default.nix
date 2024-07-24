{ pkgs, configs, ... }: 

{
  home.file.".config/i3/config".source = ./config;
  home.file.".config/i3/wallpaper.jpg".source = ./wallpaper.jpg;
}
