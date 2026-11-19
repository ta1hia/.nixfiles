{ pkgs, ... }:

{
  imports = [
    ../common
  ];

  home.packages = with pkgs; [
    go
  ];

  programs.gh = {
    enable = true;
  };

  programs.zsh = {
    initContent = ''
      bindkey '^R' history-incremental-search-backward

      export PS1="%F{yellow}%B%n %F{magenta}%1~ %b%f$ "

      eval "$(/opt/homebrew/bin/brew shellenv)"
    '';
  };
}
