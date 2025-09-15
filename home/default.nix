{ pkgs, ... }:

{
  imports = [
    ./i3
    ./terminal

    ./darkman.nix
    ./nixvim.nix
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
    nodejs_20

    processing
    rust-analyzer
    vscode

    # dummy rust test
    rustc
    cargo
    rustfmt

  ];

  home.stateVersion = "24.05";
}
