{ pkgs, configs, ... }: 

{
  home.file.".config/i3/config".source = ./config;
  home.file.".config/i3/wallpaper.png".source = ./wallpaper.png;
  home.file.".config/i3/lock.png".source = ./lock.png;
  home.file.".config/i3/scripts" = {
    source = ./scripts;
    recursive = true;
    executable = true;
  };
}
