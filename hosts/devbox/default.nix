{ config, pkgs, ... }:

{
  # This section configures system-wide packages.
  # For example, we're installing a common package like htop.
  environment.systemPackages = with pkgs; [
    ripgrep
    cowsay
    htop
  ];

  environment.etc."shells" = {
    text = ''
      /bin/sh
      /bin/bash
      /usr/bin/bash
      /bin/rbash
      /usr/bin/rbash
      /usr/bin/sh
      /home/tahia/.nix-profile/bin/zsh
    '';
    replaceExisting = true;
  };

  users.extraGroups.docker.members = [ "tahia" ];

  system-manager.allowAnyDistro = true;
}
