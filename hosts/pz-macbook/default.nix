{ ... }:
{
  imports = [
    ./homebrew.nix
  ];

  nix = {
    enable = false;
    settings.experimental-features = [ "nix-command" "flakes" ];
  };

  system.primaryUser = "tahia";
  users.users.tahia = {
    home = "/Users/tahia";
  };

  system.stateVersion = 4;
}
