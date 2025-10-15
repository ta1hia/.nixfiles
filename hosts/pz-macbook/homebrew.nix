{ ... }:
{
  homebrew = {
    # I had to install homebrew outside of nix first
    enable = true;

    taps = [ ];
    brews = [ "cowsay" ];
    casks = [ "firefox" "obsidian" "nikitabobko/tap/aerospace" "spotify" ];

  };
}

