{ inputs, ... }:
#let
#  nixvim = import (builtins.fetchGit {
#    url = "https://github.com/nix-community/nixvim";
#  });
#in
{
  imports = [
    inputs.nixvim.homeManagerModules.nixvim
  ];

  programs.nixvim = {
    enable = true;
    defaultEditor = true;
  };
}
