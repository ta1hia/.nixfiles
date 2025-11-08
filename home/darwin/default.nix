{ ... }:

{
  imports = [
    ../common
  ];

  programs.zsh = {
    initContent = ''
      bindkey '^R' history-incremental-search-backward

      export PS1="%F{yellow}%B%n %F{magenta}%1~ %b%f$ "

      eval "$(/opt/homebrew/bin/brew shellenv)"
    '';
  };
}
