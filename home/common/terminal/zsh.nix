{ pkgs, ... }:
{
  programs.zsh = {
    enable = true;
    # Set Zsh as your default shell.
    # Home Manager will create a symlink in your home directory.
    enableCompletion = true;
    autocd = true; # Automatically change to a directory without 'cd'
    syntaxHighlighting.enable = true;

    # You can add aliases, functions, and shell options here.
    shellAliases = {
      v = "nvim";
      mkdir = "mkdir -pv";
      rm = "rm -i";
      ll = "ls -AlFh";
      ls = "ls -lhg --color=always";
      l = "LC_COLLATE=C ls -C";
      la = "ls -A";

      # git aliases
      gs = "git status";
      gc = "git commit";
      gd = "git diff";
    };

    initContent = ''
      bindkey '^R' history-incremental-search-backward

      export PS1="%F{yellow}%B%n %F{magenta}%1~ %b%f$ "
    '';
  };

  # Ensure zsh is in your home-manager packages
  home.packages = with pkgs; [
    zsh
  ];
}
