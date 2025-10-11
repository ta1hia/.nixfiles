# Common home-manager configuration file, meant to be shared across all host types
{ pkgs, ... }:

{
  imports = [
    ./terminal

    ./nixvim.nix
    ./obsidian.nix
  ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.username = "tahia";
  home.homeDirectory = "/home/tahia";

  home.packages = with pkgs; [
    jq

    tmux
  ];

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.05";
}
