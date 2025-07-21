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

      vim.opt.termguicolors = true
    '';
  };
  
  home.packages = with pkgs; [
    ripgrep
  ];

  xdg.configFile."nvim".source = ./configs;
}
