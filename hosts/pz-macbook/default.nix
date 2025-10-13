{ ... }:
{
  nix = {
    enable = false;
    settings.experimental-features = [ "nix-command" "flakes" ];
  };

  system.stateVersion = 4;
}
