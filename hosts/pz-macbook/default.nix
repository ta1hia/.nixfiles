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

  services.tailscale.enable = true;

  system.stateVersion = 4;
}
