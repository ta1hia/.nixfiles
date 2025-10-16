{ ... }:

{
  imports = [
    ../common
  ];

  home.username = "tahia";
  home.homeDirectory = "/home/tahia";

  programs.zsh = {
    initContent = ''
      bindkey '^R' history-incremental-search-backward
      export PS1="%{%F{124}%}%n%{%F{52}%}@%{%F{88}%}%m %{%F{253}%}%1~ %{%f%}$ "
    '';
  };
}
