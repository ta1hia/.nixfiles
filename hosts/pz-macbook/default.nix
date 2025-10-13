{ ... }:
{
  nix = {
    enable = false;
    settings.experimental-features = [ "nix-command" "flakes" ];
  };

  users.users.tahia = {
    home = "/Users/tahia";
  };

  system.stateVersion = 4;
}
