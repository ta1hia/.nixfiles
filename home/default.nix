{ config, pkgs, inputs, ... }:

{
  imports = [
    ./i3
    ./neovim
    ./terminal

    ./obsidian.nix
    ./redshift.nix
  ];

  home.username = "tahia";   
  home.homeDirectory = "/home/tahia";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    chromium
    deluge
    peek
    redshift
    vlc
    unrar
    zoom-us
    weechat

    obsidian
    zathura

    gnumake
    ctags
    python3
    gcc
    go
    ripgrep

    processing
    rust-analyzer
    vscode
  ];

  home.stateVersion = "24.05";
}
