{ pkgs, ... }:

let
  treesitterLanguages = [
    "c"
    "go"
    "lua"
    "python"
    "javascript"
    "nix"
    "rust"
    "vim"
    "vimdoc"
    "query"
  ];
in
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;

    plugins = with pkgs.vimPlugins; [
      # treesitter and friends
      (nvim-treesitter.withPlugins (p: 
        builtins.map (lang: builtins.getAttr ("tree-sitter-" + lang) p) treesitterLanguages
      )) 
    ];

    extraLuaConfig = ''
      require('nvim-treesitter.configs').setup {
        highlight = {
          enable = true,
	  additional_vim_regex_highlighting = false,
        },

        indent = {
          enable = true,
        },
    '';
  };
  
  home.packages = with pkgs; [
    ripgrep
  ];

  xdg.configFile."nvim".source = ./configs;
}
