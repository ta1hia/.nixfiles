{ config, pkgs, ... }:

{
  nixpkgs.hostPlatform = "aarch64-linux";

  # This section configures system-wide packages.
  # For example, we're installing a common package like htop.
  environment.systemPackages = with pkgs; [
    ripgrep
    cowsay
    htop
  ];
}
