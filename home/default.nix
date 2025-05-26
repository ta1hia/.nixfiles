{ config, pkgs, inputs, ... }:

{
  imports = [
    ./i3
    ./nixvim
    ./terminal
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

    processing
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

  home.stateVersion = "24.05";
}
