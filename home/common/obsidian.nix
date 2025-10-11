{ config, pkgs, ... }:
{
  home.packages = [
    pkgs.obsidian
  ];

  xdg.enable = true;

  xdg.desktopEntries.obsidian = {
    name = "Obsidian";
    exec = "obsidian";
    icon = "obsidian";
    type = "Application";
    categories = [ "Office" "TextEditor" ];
  };
}
