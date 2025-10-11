{ pkgs, ... }:

{
  imports = [
    ../common

    ./i3

    ./darkman.nix
    ./redshift.nix
  ];

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

    # dummy rust test
    rustc
    cargo
    rustfmt
  ];

  services.xsettingsd.enable = true;
}
