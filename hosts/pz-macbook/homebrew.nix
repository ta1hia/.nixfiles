{ ... }:
{
  homebrew = {
    # I had to install homebrew outside of nix first
    # Grabbing via brew directly: firefox, obsidian

    enable = true;

    taps = [ ];
    brews = [ "cowsay" ];
    casks = [ "nikitabobko/tap/aerospace" "spotify" ];

  };
}

