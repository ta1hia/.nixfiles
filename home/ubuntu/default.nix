{ inputs, ... }:

{
  imports = [
    ../common
    inputs.sops-nix.homeManagerModules.sops
  ];

  home.username = "tahia";
  home.homeDirectory = "/home/tahia";

  programs.zsh = {
    initContent = ''
      bindkey -e
      bindkey '^R' history-incremental-search-backward
      export PS1="%{%F{124}%}%n%{%F{52}%}@%{%F{88}%}%m %{%F{253}%}%1~ %{%f%}$ "
    '';
  };

  sops = {
    age.keyFile = "/home/tahia/.config/sops/age/keys.txt";
    defaultSopsFile = ./secrets.yaml;
  };
}
