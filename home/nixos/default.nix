{ pkgs, ... }:

{
  imports = [
    ../common

    ./i3

    ./darkman.nix
    ./redshift.nix
    ./obsidian.nix
  ];

  home.username = "tahia";
  home.homeDirectory = "/home/tahia";

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

  home.pointerCursor = {
    package = pkgs.bibata-cursors; # You can choose any cursor package, like 'capitaine-cursors' or 'adwaita-icon-theme'
    name = "Bibata-Modern-Classic"; # Theme name, must match the folder name inside the package
    size = 32; # Standard size: 24, 32, 48, 64. Increase this number to increase the cursor size.
    x11 = {
      enable = true;
      # The theme is also configured in system Xresources, ensuring compatibility.
    };
  };

  services.xsettingsd.enable = true;
}
