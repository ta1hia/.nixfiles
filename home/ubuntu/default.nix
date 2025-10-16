{ ... }:

{
  imports = [
    ../common
  ];

  programs.zsh = {
    initContent = ''
      bindkey '^R' history-incremental-search-backward
      export PS1="%{%F{124}%}%n%{%F{52}%}@%{%F{88}%}%m %{%F{253}%}%1~ %{%f%}$ "
      eval "$(/opt/homebrew/bin/brew shellenv)"
    '';
  }
}
