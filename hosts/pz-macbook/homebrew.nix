{ ... }:
{
  homebrew = {
    # I had to install homebrew outside of nix first
    # Grabbing via brew directly: firefox, obsidian

    enable = true;

    taps = [ ];
    brews = [ "cowsay" ];
    casks = [ "nikitabobko/tap/aerospace" "spotify" ];

    # TODO: https://nikitabobko.github.io/AeroSpace/goodies#i3-like-config to ~/.aerospace.toml

  };
}

