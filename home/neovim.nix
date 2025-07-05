{ pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    plugins = with pkgs.vimPlugins; [
      telescope-nvim
      nvim-treesitter
      vim-nix
    ];
    extraConfig = ''
      set number
      syntax on
      set relativenumber
    '';
  };
  
  home.packages = with pkgs; [
    ripgrep
  ];
}
